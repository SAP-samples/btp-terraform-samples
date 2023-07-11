# How to directly intiate token flows

There is a method ```requestToken()``` in the securityContext object. 
With this you can call ClientCredentials or the JWT Bearer tokenflow in the scope of the securityContext.

But sometimes you want to do a ClientCredentials or a JWT Bearer tokenflow without creating a SecurityContext first. Since version 3.1.0 this is possible.

### Obtaining the request object
The library now exports the request object.

```js
const xssec = require('@sap/xssec');
const requests = xssec.requests;
```

#### JWT Bearer token flow
```js
requests.requestUserToken(appToken, serviceCredentials, additionalAttributes, scopes, subdomain, zoneId, cb);
// appToken: your current token 
// serviceCredentials: the service credentials. (the config object from environment)
// additionalAttributes: object if you need to set additional attributes (or null)
// scopes: object if you need to set scopes (or null)
// subdomain: The subdomain of the xsuaa instance (or null)
// ?zoneId: sometimes you do not know the subdomain. Then you have to set the zoneID (optional)
// cb: the callback function cb(err, encodedTokenAsString)
```

#### Client Credentials flow
```js
requests.requestClientCredentialsToken(subdomain, serviceCredentials, additionalAttributes, zoneId, cb);
// subdomain: The subdomain of the xsuaa instance (or null)
// serviceCredentials: the service credentials. (the config object from environment)
// additionalAttributes: object if you need to set additional attributes (or null)
// ?zoneId: sometimes you do not know the subdomain. Then you have to set the zoneID (optional)
// cb: the callback function cb(err, encodedTokenAsString)
```

#### Password Token flow
```js
requests.requestPasswordUserToken(subdomain, serviceCredentials, additionalAttributes, cb);
// subdomain: The subdomain of the xsuaa instance (or null)
// serviceCredentials: the service credentials. (the config object from environment)
// additionalAttributes: object if you need to set additional attributes (or null)
// cb: the callback function cb(err, encodedTokenAsString)
```