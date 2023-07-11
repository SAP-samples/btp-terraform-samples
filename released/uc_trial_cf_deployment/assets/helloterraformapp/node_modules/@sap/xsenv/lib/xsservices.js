'use strict';

var assert = require('assert');
var VError = require('verror');
var debug = require('debug')('xsenv');
var fs = require('fs');
var serviceFilter = require('./filter');
const readCFServices = require('./cfservice').readCFServices;
const readK8SServices = require('./k8sservice').readK8SServices;
const readServiceBindingServices = require('./serviceBindingService').readServiceBindingServices;


exports.getServices = getServices;
exports.filterServices = filterServices;
exports.serviceCredentials = serviceCredentials;
exports.readServices = readServices;

/**
 * Looks up and returns bound Cloud Foundry or K8S services.
 * If a service is not found - returns default service configuration loaded from a JSON file. The order of lookup is VCAP_SERVICES ->
 * mounted secrets path in K8S -> default service configuration.
 *
 * @param path {string} A string containing the mount path where the secrets are located in K8S. By default is "/etc/secrets/sapcp".
 * @param query {object} describes requested Cloud Foundry services, each property value is a filter
 *  as described in filterCFServices.
 * @param servicesFile {string} path to JSON file to load default service configuration (default is default-services.json).
 *  If null, do not load default service configuration.
 *
 * @returns {object} with the same properties as in query argument where the value of each
 *  property is the respective service credentials object.
 * @throws Error, if for some of the requested services no or multiple instances are found; Error, if query parameter is not provided
 */
function getServices(arg1, arg2, arg3) {
  const path = typeof arg1 === 'string' ? arg1 : undefined;
  const query =  typeof arg1 === 'string' ? arg2 : arg1;
  const servicesFile = typeof arg1 === 'string' ? arg3 : arg2;

  assert(query && typeof query === 'object', 'Missing mandatory query parameter');
  var defaultServices = loadDefaultServices(servicesFile);

  var result = {};
  for (var key in query) {
    var matches = filterServices(path, query[key]);
    if (matches.length === 1) {
      result[key] = matches[0].credentials;
    } else if (matches.length > 1) {
      throw new VError('Found %d services matching %s', matches.length, key);
    } else {
      // not found in VCAP_SERVICES or K8S => check servicesFile
      if (!defaultServices[key]) {
        throw new VError('No service matches %s', key);
      }
      debug('No service in VCAP_SERVICES matches %s. Returning default configuration from %s', key, servicesFile);
      result[key] = defaultServices[key];
    }
  }
  return result;
}

function loadDefaultServices(servicesFile) {
  var defaultServices = {};
  if (servicesFile !== null) {
    servicesFile = servicesFile || 'default-services.json';
    if (fs.existsSync(servicesFile)) {
      debug('Loading default service configuration from %s', servicesFile);
      try {
        defaultServices = JSON.parse(fs.readFileSync(servicesFile, 'utf8'));
      } catch (err) {
        throw new VError(err, 'Could not parse %s', servicesFile);
      }
    }
  }
  return defaultServices;
}

/**
 * Filters for service in service configuration from CloudFoundry (environment variable <code>VCAP_SERVICES</code>)
 * or mounted K8S secrets if no results found in <code>VCAP_SERVICES</code>.
 *
 * @param path {string} A string containing the mount path where the secrets are located in K8S.
 * @param filter Filter used to find a bound service, see filterCFServices
 * @return Array of objects representing all found service instances (credentials and its meta data)
 * @throws Error in case no or multiple matching services are found
 */
function filterServices(arg1, arg2) {
  const path = (arguments.length === 1) ? undefined : arg1;
  const filter = (arguments.length === 1) ? arg1 : arg2;

  let filterResults = serviceFilter.apply(readCFServices(), filter);
  debug('CF Service filter with filter: %s, returned: %s.', filter, filterResults);
  if (!filterResults || (filterResults && Array.isArray(filterResults) && !filterResults.length)) {
    filterResults = serviceFilter.apply(readServiceBindingServices(path), filter);
    debug('Service Binding Services filter with filter: %s and path: %s, returned: %s.', filter, (path ? path : 'default'), filterResults);
  }
  if (!filterResults || (filterResults && Array.isArray(filterResults) && !filterResults.length)) {
    filterResults = serviceFilter.apply(readK8SServices(path), filter);
    debug('K8s Service filter with filter: %s and path: %s, returned: %s.', filter, (path ? path : 'default'), filterResults);
  }

  return filterResults;
}

/**
 * Reads service credentials configuration from CloudFoundry environment variable <code>VCAP_SERVICES</code>
 * or mounted K8S secrets.
 *
 * @param path {string} A string containing the mount path where the secrets are mounted in K8S environment.
 * @param filter Filter used to find a bound Cloud Foundry service, see filterCFServices
 * @return Credentials property of found service
 * @throws Error in case no or multiple matching services are found
 */
function serviceCredentials(arg1, arg2) {
  const path = (arguments.length === 1) ? undefined : arg1;
  const filter = (arguments.length === 1) ? arg1 : arg2;

  var matches = path
      ? filterServices(path, filter)
      : filterServices(filter);

  if (matches.length !== 1) {
    throw new VError('Found %d matching services', matches.length);
  }
  return matches[0].credentials;
}

/**
 * Reads service configuration from CloudFoundry environment variable <code>VCAP_SERVICES</code>
 * or mounted K8S secrets if <code>VCAP_SERVICES</code> is empty.
 *
 * @param path {string} A string containing the mount path where the secrets are mounted in K8S environment.
 * @param options {object} An object with options to customize behavior. Currently allows only to disable K8s secrets caching.
 * @return Object with appropriate services or empty object if no CF or K8S services found.
 * @throws Error in case bad CF json or bad path.
 */
function readServices(path, options) {
  let cfServices = readCFServices();
  if (cfServices && Object.keys(cfServices).length > 0) {
    debug('Found VCAP_SERVICES, returning: %s', cfServices);
    return cfServices;
  }

  let serviceBindingServices = readServiceBindingServices(path);
  if (serviceBindingServices && Object.keys(serviceBindingServices).length > 0) {
    debug('Found Service Bindings, returning: %s', serviceBindingServices);
    return serviceBindingServices;
  }

  let k8sServices = readK8SServices(path, options && options.disableCache);
  debug('Empty VCAP_SERVICES, returning K8s services: %s.', JSON.stringify(k8sServices));
  return k8sServices || {};
}
