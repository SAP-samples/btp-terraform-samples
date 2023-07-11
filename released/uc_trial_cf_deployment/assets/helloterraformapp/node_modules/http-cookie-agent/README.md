# HTTP Cookie Agent

![HTTP Cookie Agent](./docs/assets/ogp.jpg)

[![npm](https://flat.badgen.net/npm/v/http-cookie-agent)](https://www.npmjs.com/package/http-cookie-agent)
[![license](https://flat.badgen.net/badge/license/MIT/blue)](LICENSE)
[![standard-readme compliant](https://flat.badgen.net/badge/readme%20style/standard/green)](https://github.com/RichardLitt/standard-readme)

Allows cookies with every Node.js HTTP clients (e.g. axios, node-fetch).

## Table of Contents

- [Install](#install)
- [Usage](#usage)
  - [Supported libraries](#supported-libraries)
  - [Using with HTTP clients](#using-with-http-clients)
  - [Using with another Agent library](#using-with-another-agent-library)
- [Contributing](#contributing)
- [License](#license)

## Install

```
npm install http-cookie-agent tough-cookie
```

## Usage

Pass `http-cookie-agent` to HTTP clients instead of http(s).Agent.

```js
import { CookieJar } from 'tough-cookie';
import { HttpCookieAgent, HttpsCookieAgent, MixedCookieAgent } from 'http-cookie-agent';

const jar = new CookieJar();

const httpAgent = new HttpCookieAgent({ jar });

// To access via HTTPS, use HttpsCookieAgent instead.
const httpsAgent = new HttpsCookieAgent({ jar });

// If the client library cannot switch Agents based on the protocol, use MixedCookieAgent instead.
const mixedAgent = new MixedCookieAgent({ jar });

// Pass agent to HTTP client.
client.request('https://example.com', { agent: httpAgent });
```

### Supported libraries

`http` / `https` / `axios` / `node-fetch` / `got`\*\* / `superagent`\*\* / `request`\*\* / `needle` / `phin` / `@hapi/wreck` / `urllib` etc.

\*\* The library supports cookies by default. You may not need `http-cookie-agent`.

### Using with HTTP clients

See also [examples](./examples) for more details.

#### `http` / `https`

```js
import https from 'https';
import { CookieJar } from 'tough-cookie';
import { HttpsCookieAgent } from 'http-cookie-agent';

const jar = new CookieJar();
const agent = new HttpsCookieAgent({ jar });

https.get('https://example.com', { agent }, (res) => {
  // ...
});
```

#### `axios`

```js
import axios from 'axios';
import { CookieJar } from 'tough-cookie';
import { HttpCookieAgent, HttpsCookieAgent } from 'http-cookie-agent';

const jar = new CookieJar();

const client = axios.create({
  httpAgent: new HttpCookieAgent({ jar }),
  httpsAgent: new HttpsCookieAgent({ jar }),
});

await client.get('https://example.com');
```

#### `node-fetch`

```js
import fetch from 'node-fetch';
import { CookieJar } from 'tough-cookie';
import { HttpCookieAgent, HttpsCookieAgent } from 'http-cookie-agent';

const jar = new CookieJar();

const httpAgent = new HttpCookieAgent({ jar });
const httpsAgent = new HttpsCookieAgent({ jar });

await fetch('https://example.com', {
  agent: ({ protocol }) => {
    return protocol === 'https:' ? httpsAgent : httpAgent;
  },
});
```

#### `got`

:warning: `got` supports cookies by default. You may not need `http-cookie-agent`.

See https://github.com/sindresorhus/got/tree/v11.8.2#cookies.

```js
import got from 'got';
import { CookieJar } from 'tough-cookie';
import { HttpCookieAgent, HttpsCookieAgent } from 'http-cookie-agent';

const jar = new CookieJar();

const client = got.extend({
  agent: {
    http: new HttpCookieAgent({ jar }),
    https: new HttpsCookieAgent({ jar }),
  },
});

await client('https://example.com');
```

#### `superagent`

:warning: `superagent` supports cookies by default. You may not need `http-cookie-agent`.

See https://github.com/visionmedia/superagent/blob/v6.1.0/docs/index.md#saving-cookies.

```js
import superagent from 'superagent';
import { CookieJar } from 'tough-cookie';
import { MixedCookieAgent } from 'http-cookie-agent';

const jar = new CookieJar();
const mixedAgent = new MixedCookieAgent({ jar });

const client = superagent.agent().use((req) => req.agent(mixedAgent));

await client.get('https://example.com');
```

#### `request`

:warning: `request` supports cookies by default. You may not need `http-cookie-agent`.

See https://github.com/request/request/tree/v2.88.1#examples.

```js
import request from 'request';
import { CookieJar } from 'tough-cookie';
import { MixedCookieAgent } from 'http-cookie-agent';

const jar = new CookieJar();

const client = request.defaults({
  agent: new MixedCookieAgent({ jar }),
});

client.get('https://example.com', (_err, _res) => {
  // ...
});
```

#### `needle`

```js
import needle from 'needle';
import { CookieJar } from 'tough-cookie';
import { MixedCookieAgent } from 'http-cookie-agent';

const jar = new CookieJar();

await needle('get', 'https://example.com', {
  agent: new MixedCookieAgent({ jar }),
});
```

#### `phin`

```js
import phin from 'phin';
import { CookieJar } from 'tough-cookie';
import { MixedCookieAgent } from 'http-cookie-agent';

const jar = new CookieJar();

await phin({
  url: 'https://example.com',
  core: {
    agent: new MixedCookieAgent({ jar }),
  },
});
```

#### `@hapi/wreck`

```js
import Wreck from '@hapi/wreck';
import { CookieJar } from 'tough-cookie';
import { HttpCookieAgent, HttpsCookieAgent } from 'http-cookie-agent';

const jar = new CookieJar();

const client = Wreck.defaults({
  agents: {
    http: new HttpCookieAgent({ jar }),
    https: new HttpsCookieAgent({ jar }),
    httpsAllowUnauthorized: new HttpsCookieAgent({ jar }),
  },
});

await client.get('https://example.com');
```

#### `urllib`

```js
import urllib from 'urllib';
import { CookieJar } from 'tough-cookie';
import { HttpCookieAgent, HttpsCookieAgent } from 'http-cookie-agent';

const jar = new CookieJar();

const client = urllib.create({
  agent: new HttpCookieAgent({ jar }),
  httpsAgent: new HttpsCookieAgent({ jar }),
});

await client.request('https://example.com');
```

### Using with another Agent library

If you want to use another Agent library, wrap the agent in `createCookieAgent`.

```js
import https from 'https';
import { HttpsAgent as KeepAliveAgent } from 'agentkeepalive';
import { CookieJar } from 'tough-cookie';
import { createCookieAgent } from 'http-cookie-agent';

const Agent = createCookieAgent(KeepAliveAgent);

const jar = new CookieJar();
const agent = new Agent({ jar });

https.get('https://example.com', { agent }, (res) => {
  // ...
});
```

## Contributing

PRs accepted.

## License

[MIT (c) 3846masa](../LICENSE)
