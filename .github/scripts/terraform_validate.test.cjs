// SPDX-FileCopyrightText: 2026 SAP SE or an SAP affiliate company and btp-terraform-samples contributors
// SPDX-License-Identifier: Apache-2.0

const assert = require('node:assert/strict');
const fs = require('node:fs/promises');
const os = require('node:os');
const path = require('node:path');
const { test } = require('node:test');
const validate = require('./terraform_validate.cjs');

async function fixture(t, files = []) {
  const root = await fs.mkdtemp(path.join(os.tmpdir(), 'terraform-validation-'));
  const workspace = path.join(root, 'repo');
  await fs.mkdir(workspace);
  const previousWorkspace = process.env.GITHUB_WORKSPACE;
  process.env.GITHUB_WORKSPACE = workspace;
  t.after(async () => {
    if (previousWorkspace === undefined) delete process.env.GITHUB_WORKSPACE;
    else process.env.GITHUB_WORKSPACE = previousWorkspace;
    await fs.rm(root, { recursive: true, force: true });
  });
  const write = async (filename) => {
    await fs.mkdir(path.dirname(path.join(workspace, filename)), { recursive: true });
    await fs.writeFile(path.join(workspace, filename), '');
  };
  const calls = [];
  const comparisons = [];
  const failures = [];
  const commits = [];
  const gitCalls = [];
  const dependencies = {
    context: {
      eventName: 'pull_request',
      repo: { owner: 'owner', repo: 'repo' },
      sha: 'merge-sha',
      payload: { pull_request: { base: { sha: 'base-sha' }, head: { sha: 'head-sha' } } },
    },
    github: { rest: { repos: {
      compareCommitsWithBasehead: async (request) => {
        comparisons.push(request);
        return { data: { files } };
      },
      getCommit: async (request) => {
        commits.push(request);
        return { data: { parents: [{ sha: 'parent-sha' }] } };
      },
    } } },
    core: { info: () => {}, setFailed: (message) => failures.push(message) },
    exec: {
      exec: async (command, args, options) => {
        calls.push({ command, args, options });
        return 0;
      },
      getExecOutput: async (command, args, options) => {
        gitCalls.push({ command, args, options });
        return { stdout: '' };
      },
    },
  };
  return { root, workspace: await fs.realpath(workspace), write, calls, comparisons, failures, commits, gitCalls, dependencies };
}

test('uses event SHAs and passes unusual filenames as individual arguments', async (t) => {
  const names = ['space dir', 'tab\tdir', 'newline\ndir', '-option', 'glob[*]', '$(touch PWNED)', "quote'dir"];
  const files = names.map((name) => ({ filename: `${name}/main.tf` }));
  const f = await fixture(t, files);
  for (const file of files) await f.write(file.filename);
  await validate(f.dependencies);
  assert.deepEqual(f.comparisons, [{ owner: 'owner', repo: 'repo', basehead: 'base-sha...head-sha', per_page: 1 }]);
  assert.equal(f.calls.length, names.length * 2);
  for (const name of names) {
    const calls = f.calls.filter((call) => call.args[0] === `-chdir=${path.join(f.workspace, name)}`);
    assert.deepEqual(calls.map((call) => call.args.slice(1)), [['init', '-backend=false', '-input=false'], ['validate']]);
    assert.ok(calls.every((call) => call.command === 'terraform'));
  }
});

test('deduplicates directories and recognizes JSON configuration and lockfile-only changes', async (t) => {
  const f = await fixture(t, [{ filename: 'example/.terraform.lock.hcl' }, { filename: 'example/variables.tf.json' }]);
  await f.write('example/main.tf.json');
  await validate(f.dependencies);
  assert.equal(f.calls.length, 2);
});

test('renames check both directories and deletions check remaining configuration', async (t) => {
  const f = await fixture(t, [
    { filename: 'new/main.tf', previous_filename: 'old/main.tf' },
    { filename: 'remaining/deleted.tf', status: 'removed' },
    { filename: 'deleted/main.tf', status: 'removed' },
  ]);
  for (const filename of ['new/main.tf', 'old/keep.tf', 'remaining/keep.tf']) await f.write(filename);
  await validate(f.dependencies);
  assert.deepEqual(f.calls.filter((call) => call.args[1] === 'init').map((call) => path.basename(call.args[0])), ['new', 'old', 'remaining']);
});

test('does not initialize directories without Terraform configuration', async (t) => {
  const f = await fixture(t, [{ filename: 'docs/README.md' }]);
  await f.write('docs/README.md');
  await validate(f.dependencies);
  assert.deepEqual(f.calls, []);
});

test('rejects absolute paths and traversal before invoking Terraform', async (t) => {
  const files = [{ filename: '../outside/main.tf' }];
  const f = await fixture(t, files);
  await assert.rejects(validate(f.dependencies), /Unsafe changed path/);
  files[0].filename = '/tmp/main.tf';
  await assert.rejects(validate(f.dependencies), /Unsafe changed path/);
  assert.deepEqual(f.calls, []);
});

test('rejects directories symlinked outside the checkout', async (t) => {
  const f = await fixture(t, [{ filename: 'link/main.tf' }]);
  const outside = path.join(f.root, 'outside');
  await fs.mkdir(outside);
  await fs.writeFile(path.join(outside, 'main.tf'), '');
  await fs.symlink(outside, path.join(f.workspace, 'link'));
  await assert.rejects(validate(f.dependencies), /escapes checkout/);
  assert.deepEqual(f.calls, []);
});

test('falls back to NUL-delimited Git output at the API file limit', async (t) => {
  const f = await fixture(t, Array.from({ length: 300 }, (_, n) => ({ filename: `docs/${n}.md` })));
  await f.write('beyond limit/main.tf');
  const original = f.dependencies.exec.getExecOutput;
  f.dependencies.exec.getExecOutput = async (...args) => {
    await original(...args);
    return { stdout: 'beyond limit/main.tf\0' };
  };
  await validate(f.dependencies);
  assert.deepEqual(f.gitCalls[0].args, ['diff', '--name-only', '--no-renames', '-z', 'base-sha...head-sha', '--']);
  assert.equal(f.gitCalls[0].options.silent, true);
  assert.equal(f.calls.length, 2);
});

test('manual runs compare the selected commit to its first parent', async (t) => {
  const f = await fixture(t);
  f.dependencies.context.eventName = 'workflow_dispatch';
  f.dependencies.context.sha = 'selected-sha';
  await validate(f.dependencies);
  assert.equal(f.commits[0].ref, 'selected-sha');
  assert.equal(f.comparisons[0].basehead, 'parent-sha...selected-sha');
});

test('manual runs can inspect the first commit of a repository', async (t) => {
  const f = await fixture(t);
  f.dependencies.context.eventName = 'workflow_dispatch';
  f.dependencies.github.rest.repos.getCommit = async () => ({ data: { parents: [] } });
  await validate(f.dependencies);
  assert.equal(f.comparisons.length, 0);
  assert.deepEqual(f.gitCalls[0].args, ['diff-tree', '--root', '--no-commit-id', '--name-only', '--no-renames', '-r', '-z', 'merge-sha', '--']);
});

test('API and Git errors fail instead of silently skipping validation', async (t) => {
  const f = await fixture(t);
  f.dependencies.github.rest.repos.compareCommitsWithBasehead = async () => { throw new Error('API failed'); };
  await assert.rejects(validate(f.dependencies), /API failed/);
  f.dependencies.github.rest.repos.compareCommitsWithBasehead = async () => ({ data: {} });
  await assert.rejects(validate(f.dependencies), /did not return/);
  f.dependencies.github.rest.repos.compareCommitsWithBasehead = async () => ({ data: { files: Array(300).fill({}) } });
  f.dependencies.exec.getExecOutput = async () => { throw new Error('Git failed'); };
  await assert.rejects(validate(f.dependencies), /Git failed/);
  assert.deepEqual(f.calls, []);
});

test('continues after failures but never validates a directory whose init failed', async (t) => {
  const names = ['a-init-fails', 'b-validate-fails', 'c-success'];
  const f = await fixture(t, names.map((name) => ({ filename: `${name}/main.tf` })));
  for (const name of names) await f.write(`${name}/main.tf`);
  const original = f.dependencies.exec.exec;
  f.dependencies.exec.exec = async (...args) => {
    await original(...args);
    const [, argv] = args;
    return path.basename(argv[0]) === 'a-init-fails' ||
      (path.basename(argv[0]) === 'b-validate-fails' && argv[1] === 'validate') ? 1 : 0;
  };
  await validate(f.dependencies);
  assert.deepEqual(f.calls.map((call) => [path.basename(call.args[0]), call.args[1]]), [
    ['a-init-fails', 'init'], ['b-validate-fails', 'init'], ['b-validate-fails', 'validate'],
    ['c-success', 'init'], ['c-success', 'validate'],
  ]);
  assert.equal(f.failures.length, 1);
});

test('does not pass the action API token to Terraform', async (t) => {
  const f = await fixture(t, [{ filename: 'example/main.tf' }]);
  await f.write('example/main.tf');
  const key = 'INPUT_GITHUB-TOKEN';
  const previous = process.env[key];
  process.env[key] = 'test-token';
  t.after(() => {
    if (previous === undefined) delete process.env[key];
    else process.env[key] = previous;
  });
  await validate(f.dependencies);
  assert.ok(f.calls.every((call) => !(key in call.options.env)));
  assert.equal(process.env[key], 'test-token');
});
