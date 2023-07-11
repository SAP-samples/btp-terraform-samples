# SecurityContext with multiple configurations

There are scenarios, where you need to "feed" the audience validator with 2 or more different configurations.
For example if you have a REST API that is called from two different XSUAA bindings.

Since version 3.1.0 we support to have 2 or ServiceBinding configurations for one SecurityContext.


### How to use this feature
Just pass an array of configuration objects to the method instead of a single object.
This feature is fully backward compatible. So you can pass an array or a simple object to the method.

#### If you create the SecurityContext on your own
```js
const config1 = xsenv.getServices({xsuaa:{tag:'xsuaa'}}).xsuaa;
const config2 = xsenv.getServices({xsuaa:{tag:'xsuaaB'}}).xsuaaB;

xssec.createSecurityContext(access_token, [config1, config2], function(error, securityContext, tokenInfo) {
    //...
});
```

#### If you use the passport library. 
For the passport library the integration is also very simple.

```js
const config1 = xsenv.getServices({xsuaa:{tag:'xsuaa'}}).xsuaa;
const config2 = xsenv.getServices({xsuaa:{tag:'xsuaaB'}}).xsuaaB;

passport.use(new JWTStrategy([config, config2]));

app.use(passport.initialize());

//and so on
```
