# Change Log
All notable changes to this project will be documented in this file.


## 3.2.15 - 2023-01-09
- hotfix: upgrade to newest jsonwebtoken version ^9.0.0 because of security issue complainings. But the library was never affected

## 3.2.14 - 2022-10-11
- allow IAS issuer without https protocol prefix
- fix for additionalAttributes
- allow setting timeout without having credentials object provided

## 3.2.13 - 2022-02-15
- hofix in keycache implementation if you turn off to use the cache
- upgrade to newer axios library

## 3.2.12 - 2022-01-19
- add support for UAA system plan 
- upgrade to newer axios library

## 3.2.11 - 2021-11-30
- add support for timeout setting for all requests-calls 
- support for password token flow in requests module
- support for setting scopes for all requests to XSUAA
## 3.2.10 - 2021-11-02
- fix correlationID header names to "x-vcap-request-id" or "x-correlationid"

## 3.2.9 - 2021-10-22
- custom domain support for IAS
- support for "x-correlation-id" header to be set for createSecurityContext and tokenexchange-calls
- support to turn off the internal cache for a createSecurityContext call

## 3.2.8 - 2021-10-18
- add additional getter for user properties on XSUAA context
- remove deed and unneeded code for IAS context
- fix token flows in requests if subdomain is provided using certificate

## 3.2.7 - 2021-09-15
- replace got with axios library because of a bug in got lib during https get

## 3.2.5 - 2021-09-07
- fix to be backward-compatible for tokenFlow-APIs

## 3.2.4 - 2021-09-03
- fix an issue with IAS multitenancy support
- remove the deprecated request library with got library

## 3.2.3 - 2021-08-23
- add checkFollowingInstanceScope to SecurityContext to retrieve instance specific scope without need to build scope string on your own
- fix a reference error in key verification
- support for multitenance IAS applications using 'x-zone_uuid' Header in jwks call

## 3.2.2 - 2021-06-16
- Support for tokenexchanges with X.509 certificates managed by XSUAA
- Support for tokenexchanges with manually managed X.509 certificates
- support for configuration objects that does not provide a clientsecret (but a certificate)

## 3.2.1 - 2021-06-01
- Add some more error and tracing information

## 3.2.0 - 2021-04-20
- Support for IAS token validation. ([more details](doc/IAS.md))

## 3.1.2 - 2021-03-01
- Feature: Support for IAS to XSUAA token exchange ([more details](doc/IAStoXSUAA.md))
- Feature: Support for ZoneID enabled token flows ([more details](doc/TokenFlows.md))


## 3.1.1 - 2021-02-11
- Bugfix: Tokenexchange with additional attributes may result in a wrong formatted url
- Feature: The passport middleware allows to provide scopes to be validated at authentication time. Details [here](http://www.passportjs.org/docs/oauth/#scope)

## 3.1.0 - 2021-02-10
- Support for multiple configurations for one security context ([more details here](doc/MultiConfiguration.md))
- Bugfix: support for additional attributes in token exchange
- Bugfix: authorization now in payload for better XSUAA support
- correct support for azp (clientid) in token payload
- method to identify an XSUAA token

## 3.0.10 - 2021-10-01
- The requests to the XSUAA are now available using the requests module also if you do not have a securityContext

## 3.0.9 - 2020-08-06
- Set request library to version 2.88.2 because of security vulnerability

## 3.0.8 - 2020-08-06
- Increase timeout for jwt-bearer token flow to reduce of timeouts with very big tokens.

## 3.0.7 - 2020-07-24
- Move the token to the request body for jwt-bearer token flow, because of problems with very big tokens

## 3.0.6 - 2020-07-01
- Audience Validation validates to true when the derived client_id of broker-clone token matches the trusted client. This is relevant to support tokens of grant type user_token that contains no scopes.

## 3.0.5 - 2020-06-26
- Audience Validation accepts tokens of grant type user_token that does not provide aud claim. In that case the audience is derived from the audiences from the scopes.
- Audience Validation is skipped when cid of token matches the trusted client.
- Use getSubaccountId() method only to fetch the subaccount id, e.g. for calling the metering API for user-based pricing.
- In case you are interested in the customers tenant GUID make use of getZoneId method instead!
- A new [TokenInfo](/doc/TokenInfo.md) class is introduced for better logging capabilities.

## 3.0.3 - 2020-05-25

- Fix jwt-bearer flow to take the right token as uri parameter.

## 3.0.2 - 2020-05-20

- Fix get verification key from keycache.

## 3.0.1 - 2020-05-19

- HotFix missing debugTrace in verification key
- Fix RetryStrategy

## 3.0.0 - 2020-05-15

- Replace grant type user_token in method requestToken (TYPE_USER_TOKEN) in favor of urn:ietf:params:oauth:grant-type:jwt-bearer
- Remove obsolete method getToken (use getHdbToken or getAppToken))
- Remove obsolete method requestTokenForClient (use requestToken)
- Remove obsolete method getIdentityZone (use getZoneId() instead, or getSubaccountId() for metering purposes) 
- Support for audience validation in token
- remove of SAP_JWT_TRUST_ACL environment variable support (functionality now comes with audience validation); see also [here](https://jam4.sapjam.com/blogs/show/oEdyQO183plBoQdrvcPw2w).
- remove depencency to node-jwt (ALPINE support)
- restructure internal code for better maintainability

## 2.2.5 - 2020-02-28

- Update to node-jwt version 1.6.6

## 2.2.4 - 2019-08-14

- Support for API methods getUserName and getUniquePrincipalName
 
## 2.2.3 - 2019-08-07

- Add retry for recieving keys

## 2.2.2 - 2019-06-24

- Use verification key from binding as backup if online key retrieval fails

## 2.2.1 - 2019-06-17

- Fix uaaDomain comparison in key cache

## 2.2.0 - 2019-06-17

- Align key cache implementation with other container security libraries

## 2.1.17 - 2019-05-17

- Introduce http timeout of two seconds
- Update version of module debug, lru-cache and @sap/xsenv
- Fix token verification for broker master instance subscriptions

## 2.1.16 - 2019-01-28

- Fix token parser: switch ASCII to Utf8 decode

## 2.1.15 - 2018-08-13

- Update version of module request

## 2.1.14 - 2018-07-24

- Evaluate SAP_JWT_TRUST_ACL if trustedclientidsuffix is present but not matching

## 2.1.13 - 2018-07-18

- Update version of module request

## 2.1.12 - 2018-06-01

- Support for API methods getSubaccountId and getOrigin
- Mark API method getIdentityZone as deprecated

## 2.1.11 - 2018-05-18

- Update version of module request

## 2.1.10 - 2018-04-20

- Fixes for keycache

## 2.1.9 - 2018-04-18

- Update version of module @sap/node-jwt (1.4.8)
- Fixes for keycache
- Update version of module request

## 2.1.8 - 2018-03-14

- Support for API method getAppToken

## 2.1.7 - 2018-03-05

- Support for API method requestToken

## 2.1.6 - 2018-02-19

- Update version of module @sap/node-jwt

## 2.1.5 - 2018-02-07

- Update version of module request

## 2.1.4 - 2017-12-04

- Support new JWT structure (attribute location ext_cxt)
- First implementation for keycache

## 2.1.3 - 2017-11-29

- Support for API method getClientId

## 2.1.2 - 2017-10-23

- Support for API method getSubdomain

## 2.1.1 - 2017-10-09

- Update version of modules @sap/node-jwt, @sap/xsenv and debug

## 2.1.0 - 2017-07-06

- Support of API method requestTokenForClient
- Update version of module @sap/node-jwt

## 2.0.0 - 2017-06-26

- Removal of deprecated constructor method createSecurityContextCc
- Removal of API method method getUserInfo

## 1.3.0 - 2017-06-23

- Revert removal of API method method getUserInfo

## 1.2.0 - 2017-06-22

- Support for API methods getLogonName, getGivenName, getFamilyName, getEmail
- Removal of API method method getUserInfo
- Fix identity zone validation (only relevant for tenants created with SAP Cloud Cockpit)

## 1.1.1 - 2017-05-30
- Update version of dependent modules

## 1.1.0 - 2017-05-22
- Mark API method createSecurityContextCC as deprecated

## 1.0.4 - 2017-05-17

- Support for validation of XSUAA broker plan tokens
- Support for API methods getCloneServiceInstanceId and getAdditionalAuthAttribute
- Support for validation of XSUAA application plan tokens in arbitrary identity zones

## 1.0.3 - 2017-03-29

- Update version of dependent modules

## 1.0.2 - 2017-02-22

- Support for validation of SAML Bearer tokens

## 1.0.1 - 2017-02-02

- Support for client credentials tokens in JWT strategy

## 1.0.0 - 2017-01-25

- Introduction of scopeing, module name changed to @sap/xssec
