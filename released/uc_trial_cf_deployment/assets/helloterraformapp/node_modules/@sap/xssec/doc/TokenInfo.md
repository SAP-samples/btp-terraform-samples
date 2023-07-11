# TokenInfo

Since version 3.0.4 we have the TokenInfo object in the xssec library.
This is a wrapper around all the information the token contains.

## Security Note

Do not simply rely on the information within the token!
The webapplication normally receives the token with the HTTP Request from "outside" the application.
So there is a deep parameter validation needed! 

*Also if the token is signed, it may also contain dangerous information.*

### How to get the TokenInfo object
There are several ways to get the TokenInfo.
If an error occurs NO security context is created. But the [TokenInfo](doc/TokenInfo.md) object is available, so you can do some logging.

#### If you create the SecurityContext on your own
```js
xssec.createSecurityContext(access_token, config, function(error, securityContext, tokenInfo) {
    if (error) {
        console.log('tokenInfo is also available if you have an error', tokenInfo.getPayload())
        return;
    }
    console.log('Security Context created successfully', tokenInfo.getPayload());
    console.log('You can also retrieve it from the SecurityContext', securityContext.getTokenInfo());
});
```

#### If you use the passport library. 
The ``tokenInfo`` object is attached to the ``request`` object in the JWTStrategy middleware. ([more here](../README.md#api-description))
Only if the middleware could not find a bearer token in the HTTP header, there is no ``tokenInfo`` object created.

The documentation for a default error handler in express you find [here](https://expressjs.com/en/guide/error-handling.html)

```js
passport.use(new JWTStrategy(config));

app.use(passport.initialize());

//don't forget to set failWithError to true.
//Otherwise the errorHandler will not be called
app.use(passport.authenticate('JWT', { session: false, failWithError: true })); 

// simple express Error Handler
app.use(function(err, req, res, next) {
  //be aware that the error handler is not only for the passport errors!
  var tokenInfo = req.tokenInfo;
  if(tokenInfo) {
    //err is exception thrown but not the error of the tokenValidation
    //to get the errorObject from xsuaa
    var xserror = tokenInfo.getErrorObject()  
    
    //to the logging
    console.error(xserr, tokenInfo.getPayload());
  }
  
  res.status(err.status);
  res.send(err.message);
});
```

## API Description

### TokenInfo(encoded_token)

Code says more than words :-)

```js
var tokenInfo = new TokenInfo(encodedTokenAsString);

///// Get the Token-information as a whole
var payload = tokenInfo.getPayload(); //Get the token payload
var header = tokenInfo.getHeader();   //Get the token header
var encoded = tokenInfo.getTokenValue(); //returns the encoded token string

var exp = tokenInfo.getExpirationDate(); //returns a Date object or null if not available
var iat = tokenInfo.getIssuedAt(); //returns a Date object or null if not available
var iss = tokenInfo.getIssuer(); //returns a string or null if not available

var is_xsuaa = tokenInfo.isTokenIssuedByXSUAA(); //returns true, if the token is a XSUAA token

///// Error Handling
tokenInfo.isDecoded(); //returns true, if a token could be decoded
tokenInfo.isValid();    //returns true, if no error object is attached

tokenInfo.getErrorObject(); //return the error object if there is one


///// Verification of an encoded token

//you can pass a key Callback to retrieve the key asyncronously
function getKeyCB(header, callback) {
  client.getSigningKey(header.kid, function(err, key) {
    var signingKey = key.publicKey || key.rsaPublicKey;
    callback(null, signingKey);
  });
}

tokenInfo.verify(getKeyCB, function(err, tokenInfo) {
    if(err) {
        console.error(err.errorCode, err.message);
        console.error(err.stack);

        //tokenInfo is also available, if there was a verification error.
        console.log(tokenInfo.getPayload());
    } else {
        //yeah, it was verified
        ...
    }
});

//instead of a callback you can directly give the verification key to the function
tokenInfo.verify("123456", function(err, tokenInfo) {
    ...
});

```

### Future Plans
We have plans to provide some more functionality here in the future:

* provide not only verify, but also sign functionality
* easy create tokens for unittesting