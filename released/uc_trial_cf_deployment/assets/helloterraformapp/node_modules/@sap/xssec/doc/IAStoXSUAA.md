# IAS to XSUAA Token exchange

With version 3.1.2 we support the automatic exchange of an IAS token to a XSUAA token.
This happens inside the creation of the security context.
Currently there is no cache functionality implemented. This is planned for the next release. 

Click [here](https://github.com/SAP/cloud-security-xsuaa-integration/blob/master/docs/IAS-XSUAA-token-xchange.md) for more details about this.

### How to use this feature

This feature is turned on by default, there are no additional steps required to set it up.
If you create a securityContext with an IAS token, this will be exchanged to an XSUAA token internally.
For this an extra REST call to the XSUAA is needed. (currently there is no cache. But will come soon)

### How to disable this feature 
If you don't want to convert an IAS token to a XSUAA token, you can simply disable token exchange by setting flag 'IAS_XSUAA_XCHANGE_ENABLED' to false.
Keep in mind, that this configuration setting is application wide. You can't turn this off only for a specific security context.

So this flag will also work for the passport integration.

```js
const xssec = require('@sap/xssec');

//turn off the automatic exchange
xssec.config["IAS_XSUAA_XCHANGE_ENABLED"] = false;

//and so on
```

### Full IAS support
Since version 3.2.0 the library can validate and verify IAS tokens directly. Have a look [here](IAS.md) for more details.