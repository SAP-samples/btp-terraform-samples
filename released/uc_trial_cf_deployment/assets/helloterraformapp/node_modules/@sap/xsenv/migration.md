# Migration Guide

## Version 2 ==> Version 3

### Changes to application code

#### Nested objects in credentials (K8S case only)

The following service credentials:

```
/etc/
  /secrets/
    /sapcp/
      /some-service/
        /some-instance/
          /url   - containing https://some-service
          /uaa   - containing { "url": "https://uaa", "clientid": "client", "clientsecret": "secret" }
          /other - containing [1, "two"]
```

had been provided to applications in v2 of _@sap/xsenv_ as:

```js
{
  url: 'https://some-service',
  uaa: '{ "url": "https://uaa", "clientid": "client", "clientsecret": "secret" }',
  other: '[1, "two"]'
}
```

The `uaa` property requires parsing (with `JSON.parse`) in order to use its properties individually.

With v3 of _@sap/xsenv_ nested JSON objects are parsed automatically and are provided to applications as:

```js
{
  url: 'https://some-service',
  uaa:  {
    url: 'https://uaa',
    clientid: 'client',
    clientsecret: 'secret'
  },
  other: '[1, "two"]'
```

Invocation to `JSON.parse` should be removed from application code.

**Note**: property values representing arrays are currently not automatically parsed.
