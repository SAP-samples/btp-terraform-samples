'use strict';

const path = require('path');
const tracer = require('./utils/logger').getTracer(__filename);
const fsUtils = require('./utils/fs-utils');


module.exports = {
  getPort: function (port) {
    // port 0 is valid
    return (port !== undefined) ? port : (process.env.PORT || '5000');
  },

  getWorkingDirectory: function (workingDir, xsappConfig) {
    let wdir = workingDir || process.cwd();
    let xsappFile = path.join(wdir, 'xs-app.json');
    tracer.info('Checking file existence: ' + xsappFile);
    if (!xsappConfig && !fsUtils.isFile(xsappFile)) {
      throw new Error(`Neither xsappConfig nor ${xsappFile} files were found`);
    }
    tracer.info('Using working directory: ' + wdir);
    return wdir;
  }
};
