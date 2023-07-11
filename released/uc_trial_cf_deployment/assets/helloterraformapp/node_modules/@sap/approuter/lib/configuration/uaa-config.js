'use strict';

const _ = require('lodash');
const path = require('path');
const xsenv = require('@sap/xsenv');
const VError = require('verror').VError;
const tracer = require('../utils/logger').getTracer(__filename);

exports.load = function (workingDir) {
  let pathToDefaultServices = path.join(workingDir, 'default-services.json');
  try {
    let xsuaaCredentials = xsenv.getServices({ uaa: matchesUaa }, pathToDefaultServices).uaa;
    if (process.env.XSUAA_PRIVATE_KEY){
      xsuaaCredentials.key = process.env.XSUAA_PRIVATE_KEY;
    }
    return xsuaaCredentials;
  } catch (e) {
    tracer.debug(new VError(e, 'Cannot find service uaa in environment'));
    return {};
  }
};

function matchesUaa(service) {
  let uaaName = process.env.UAA_SERVICE_NAME;
  if (uaaName) {
    return service.name === uaaName;
  }

  if (_.includes(service.tags, 'xsuaa')) {
    return true;
  }
  if (service.label === 'user-provided' && service.credentials && _.includes(service.credentials.tags, 'xsuaa')) {
    return true;
  }
  return false;
}
