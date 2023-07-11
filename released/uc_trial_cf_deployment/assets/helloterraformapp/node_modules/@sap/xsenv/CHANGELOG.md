# Change Log
All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org/).

The format is based on [Keep a Changelog](http://keepachangelog.com/).

## 3.4.0 - 2022-10-27

### Added
- Support Node.js 18.x


## 3.3.2 - 2022-06-17

### Fixed
- service bindings for Kubernetes: bindings were not read because of symlinks

## 3.3.1 - 2022-06-08

### Fixed
- change node plugin version for xmake to 10.15.0

## 3.3.0 - 2022-06-06

### Added
- Service bindings for Kubernetes

## 3.2.2 - 2022-04-11

### Removed
- Removed node 8.x support and tests

### Changed
- Changed istanbul test framework with c8

## 3.2.1 - 2022-02-28

### Added
- Reading K8s services now caches the results to decrease file system calls.
- Documentation on how to disable caching for K8s Services if needed.

## 3.2.0 - 2022-01-24

### Added
- Support Node.js 16.x

### Updated
- `debug` dependency to 4.3.3.

## 3.1.1 - 2021-07-01

### Fixed
- Reading services will now properly check for K8s services when VCAP_SERVICES is defined but contains no services.
- Getting a service will now properly check in K8s services if VCAP_SERVICES does not have the service.

### Updated
- `debug` dependency to 4.2.0.
- `lodash` dependency to 4.17.21.

## 3.1.0 - 2020-11-20

### Added
- Support Node.js 14.x

## 3.0.0 - 2020-06-05

### Removed
- Node.js 6 support

### Changed
- K8S case: nested objects in credentials are now automatically parsed (does not apply to arrays)

## 2.2.0 - 2019-11-28

### Added
- Support Node.js 12.x

## 2.1.0 - 2019-10-15

### Added
- Support for K8S secrets mounted as volumes.

## 2.0.0 - 2019-04-22

### Removed
- Node.js 4 support
- Remove deprecated loadCaCert function

## 1.3.0 - 2018-12-18

### Added
- Node.js 10 support

### Fixed
- Update `lodash` to 4.17.11

## 1.2.9 - 2018-01-18
### Added
- Release with npm-shrinkwrap.json


## 1.2.8 - 2017-10-09
### Security
- Updated debug package to fix a security issue https://snyk.io/vuln/npm:debug:20170905
