//loading core logger functionality
var coreLogger = require("./core/log-core");
var effectiveLogger = null;

coreLogger.init();

effectiveLogger = require("./logger/log-express");
var defaultConfig = require("./config");
effectiveLogger.setCoreLogger(coreLogger);

coreLogger.setConfig(defaultConfig.config);

// Set the minimum logging level. Messages with a lower level, will not be forwarded. (Levels: error, warn, info, verbose, debug, silly)
exports.setLoggingLevel = function (level) {
    return coreLogger.setLoggingLevel(level);
};

// Set the  log level of request logs. Logs with a lower level than the current log level will not be forwarded. (Levels: error, warn, info, verbose, debug, silly)
exports.setRequestLogLevel = function (level) {
    return coreLogger.setRequestLogLevel(level);
};

exports.getLoggingLevel = function() {
    return coreLogger.getLoggingLevel();
}

exports.getBoundServices = function() {
    return coreLogger.getBoundServices();
}

// Sets the given function as log sink. Following arguments will be passed to the sink function: level, output
exports.setSinkFunction = function (func) {
    coreLogger.setSinkFunction(func);
};

exports.forceLogger = function (name) {
    switch (name) {
        //insert your custom framework logger here
        case "restify":
            effectiveLogger = require("./logger/log-restify");
            break;
        case "plainhttp":
            effectiveLogger = require("./logger/log-plainhttp");
            break;
        case "connect":
            effectiveLogger = require("./logger/log-connect");
            break;
        default:
            effectiveLogger = require("./logger/log-express");
    }
    effectiveLogger.setCoreLogger(coreLogger);
};

exports.enableTracing = function (input) {
    names = [];
    if (typeof input == "string")
        names.push(input);
    else
        names = input;
    var config = defaultConfig.config;
    for(var i in names) {
        switch (names[i].toLowerCase()) {
            case "sap_passport":
                config.push(...require("./trace/sap_passport").config);
                break;
            default:
        }
    }
    coreLogger.setConfig(config);
    return config;
}


exports.logNetwork = function (req, res, next) {
    effectiveLogger.logNetwork(req, res, next);
};


exports.logMessage = function () {
    coreLogger.logMessage.apply(this, arguments);
};

exports.isLoggingLevel = function (level) {
    return coreLogger.isLoggingLevel(level);
};

coreLogger.bindConvenienceMethods(exports);

exports.createWinstonTransport = function (options) {
    if (!options) {
        options = {
            level: 'info'
        };
    }
    options.logMessage = coreLogger.logMessage;
    return require("./winston/winston-transport").createTransport(options);
};

exports.createLogger = function (customFields) {
    return coreLogger.createLogger(customFields);
};

exports.registerCustomFields = function(fieldNames) {
    return coreLogger.registerCustomFields(fieldNames)
};

exports.setCustomFields = function (customFields) {
    return coreLogger.setCustomFields(customFields);
};

exports.setLogPattern = function (args) {
    coreLogger.setLogPattern.apply(this, arguments);
};

exports.overrideNetworkField = function (field, value) {
    return coreLogger.overrideField(field, value);
};

exports.overrideCustomFieldFormat = function (value) {
    return coreLogger.overrideCustomFieldFormat(value);
};
