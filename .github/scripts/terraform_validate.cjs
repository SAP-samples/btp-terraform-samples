// SPDX-FileCopyrightText: 2026 SAP SE or an SAP affiliate company and btp-terraform-samples contributors
// SPDX-License-Identifier: Apache-2.0

const fs = require('node:fs/promises');
const path = require('node:path');

// Invoked by actions/github-script, which supplies Octokit and the Actions toolkit.
module.exports = async ({ github, context, core, exec }) => {
  const workspace = await fs.realpath(process.env.GITHUB_WORKSPACE);
  const gitFiles = async (args) => {
    const { stdout } = await exec.getExecOutput('git', args, {
      cwd: workspace,
      silent: true,
    });
    return stdout.split('\0').filter(Boolean);
  };

  let base;
  let head;
  if (context.eventName === 'pull_request') {
    // Use event SHAs so a newer push cannot change this run's comparison.
    base = context.payload.pull_request.base.sha;
    head = context.payload.pull_request.head.sha;
  } else if (context.eventName === 'workflow_dispatch') {
    head = context.sha;
    const { data: commit } = await github.rest.repos.getCommit({
      ...context.repo,
      ref: head,
    });
    // Manual runs validate changes in the selected default-branch commit.
    base = commit.parents[0]?.sha;
  } else {
    throw new Error('Unsupported Terraform validation event');
  }

  let filenames;
  if (base) {
    const { data: comparison } = await github.rest.repos.compareCommitsWithBasehead({
      ...context.repo,
      basehead: `${base}...${head}`,
      per_page: 1,
    });
    if (!Array.isArray(comparison.files)) {
      throw new Error('GitHub did not return the changed files');
    }
    // GitHub returns at most 300 files, even when commit results are paginated.
    // Full checkout history allows a complete comparison at that limit.
    if (comparison.files.length >= 300) {
      core.info('Using Git to avoid the GitHub comparison file limit.');
      filenames = await gitFiles([
        'diff', '--name-only', '--no-renames', '-z', `${base}...${head}`, '--',
      ]);
    } else {
      filenames = comparison.files.flatMap((file) =>
        file.previous_filename ? [file.filename, file.previous_filename] : [file.filename],
      );
    }
  } else {
    // A repository's first commit has no parent to compare through the API.
    filenames = await gitFiles([
      'diff-tree', '--root', '--no-commit-id', '--name-only', '--no-renames', '-r', '-z', head, '--',
    ]);
  }

  const directories = new Set();
  for (const filename of filenames) {
    if (path.isAbsolute(filename) || filename.split('/').includes('..')) {
      throw new Error(`Unsafe changed path: ${JSON.stringify(filename)}`);
    }
    let directory;
    try {
      directory = await fs.realpath(path.resolve(workspace, path.dirname(filename)));
    } catch (error) {
      // Deleted directories need no initialization.
      if (error.code === 'ENOENT' || error.code === 'ENOTDIR') continue;
      throw error;
    }
    const relative = path.relative(workspace, directory);
    if (relative === '..' || relative.startsWith(`..${path.sep}`) || path.isAbsolute(relative)) {
      throw new Error(`Changed directory escapes checkout: ${JSON.stringify(filename)}`);
    }
    if (directories.has(directory) || !(await fs.stat(directory)).isDirectory()) continue;
    for (const entry of await fs.readdir(directory)) {
      if ((entry.endsWith('.tf') || entry.endsWith('.tf.json')) &&
          (await fs.stat(path.join(directory, entry))).isFile()) {
        directories.add(directory);
        break;
      }
    }
  }

  if (directories.size === 0) core.info('No changed directories with Terraform configuration.');

  // Do not pass github-script's API token to Terraform child processes.
  const terraformEnv = { ...process.env };
  delete terraformEnv['INPUT_GITHUB-TOKEN'];
  delete terraformEnv.GITHUB_TOKEN;
  delete terraformEnv.GH_TOKEN;
  const options = { ignoreReturnCode: true, env: terraformEnv };
  let failed = false;
  for (const directory of [...directories].sort()) {
    core.info(`Validating Terraform in ${JSON.stringify(path.relative(workspace, directory))}`);
    const args = [`-chdir=${directory}`];
    if (await exec.exec('terraform', [...args, 'init', '-backend=false', '-input=false'], options) !== 0) {
      failed = true;
      continue;
    }
    if (await exec.exec('terraform', [...args, 'validate'], options) !== 0) failed = true;
  }
  if (failed) core.setFailed('Terraform initialization or validation failed.');
};
