# IAS Support

Since version 3.2.0 you can configure a security context with an IAS configuration and validate IAS tokens.
But keep in mind that IAS tokens do NOT have all features of an XSUAA token. For example there is NO scope checks possible with an IAS token.


### How to use this feature
The integration of IAS support is straightforward

#### If you create the SecurityContext on your own
```js
const config_ias = xsenv.getServices({ias:{tag:'ias'}}).ias;

xssec.createSecurityContext(access_token, config_ias, "IAS", function(error, securityContext, tokenInfo) {
    //...
});

//the string "IAS" as the third parameter is optional. 
//But then you make sure, that only a valid IAS configuration can be configured!
//you can also do this:

xssec.createSecurityContext(access_token, config_ias, function(error, securityContext, tokenInfo) {
    //...
});

//now the library checks if there is a "xsappname" entry in the configuration to identify an XSUAA config.
//otherwise it will considered to be an IAS config.

```

#### If you use the passport library. 
For the passport library the integration is also very simple.

```js
const config_ias = xsenv.getServices({ias:{tag:'ias'}}).ias;

passport.use(new JWTStrategy(config_ias, "IAS"));

//or (same as mentioned above)
passport.use(new JWTStrategy(config_ias));


app.use(passport.initialize());

//and so on
```

#### Support for both configurations in ONE context
Currently there is no support to configure the security context for XSUAA andd IAS together and then decide which config to used based on the token.
If you need such feature feel free to open an issue, so we can discuss the details.
