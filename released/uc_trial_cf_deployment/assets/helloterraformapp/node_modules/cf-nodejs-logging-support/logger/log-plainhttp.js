// Log network activity for express applications

var core;

var setCoreLogger = function (coreLogger) {
    core = coreLogger;
};

// Logs requests and responses
var logNetwork = function (req, res) {
    var logSent = false;

    var logObject = core.initRequestLog();

    //rendering the given arguments failsafe against missing fields
    if (req.connection == null) {
        req.connection = {};
    }
    if (req.headers == null) {
        req.headers = {};
    }

    req.originalUrl = req.originalUrl || req.url;
    
    if (typeof req.getHeader != "function") {
        req.getHeader = function (header) {
            return this.headers[header.toLocaleLowerCase()]; 
        };
    }

    var fallbacks = [];
    var selfReferences = [];
    var configEntry;
    var preConfig = core.getPreLogConfig();
    for (var i = 0; i < preConfig.length; i++) {
        configEntry = preConfig[i];

        switch (configEntry.source.type) {
            case "header":
                logObject[configEntry.name] = req.getHeader(configEntry.source.name);
                break;
            case "static":
                logObject[configEntry.name] = configEntry.source.value;
                break;
            case "field":
                logObject[configEntry.name] = req[configEntry.source.name];
                break;
            case "self":
                selfReferences[configEntry.name] = configEntry.source.name;
                break;
            case "time":
                logObject[configEntry.name] = configEntry.source.pre(req, res, logObject);
                break;
            case "special":
                fallbacks[configEntry.name] = configEntry.fallback;
                break;
        }

        core.handleConfigDefaults(configEntry, logObject, fallbacks);
    }

    for (var kFallback in fallbacks) {
        logObject[kFallback] = fallbacks[kFallback](req, res, logObject);
    }

    for (var kSelfReference in selfReferences) {
        logObject[kSelfReference] = logObject[selfReferences[kSelfReference]];
    }


    // Replace all set fields, which are marked to be reduced, with a placeholder (defined in log-core.js)
    core.reduceFields(preConfig, logObject);

    core.bindLoggerToRequest(req, logObject);

    var token = req.headers[core.getDynLogLevelHeaderName()];
    core.bindDynLogLevel(token, req.logger);

    res.on("finish", function () {
        finishLog();
    });

    res.on("header", function () {
        finishLog();
    });

    var finishLog = function () {
        if (!logSent) {
            var postConfig = core.getPostLogConfig();
            var fallbacks = [];
            var selfReferences = [];
            for (var i = 0; i < postConfig.length; i++) {
                configEntry = postConfig[i];

                switch (configEntry.source.type) {
                    case "header":
                        if (res.getHeader)
                            logObject[configEntry.name] = res.getHeader(configEntry.source.name);
                        break;
                    case "field":
                        logObject[configEntry.name] = res[configEntry.source.name];
                        break;
                    case "self":
                        selfReferences[configEntry.name] = configEntry.source.name;
                        break;
                    case "time":
                        logObject[configEntry.name] = configEntry.source.post(req, res, logObject);
                        break;
                    case "special":
                        fallbacks[configEntry.name] = configEntry.fallback;
                        break;
                }

                core.handleConfigDefaults(configEntry, logObject, fallbacks);
            }

            for (var kFallback in fallbacks) {
                logObject[kFallback] = fallbacks[kFallback](req, res, logObject);
            }

            for (var kSelfReference in selfReferences) {
                logObject[kSelfReference] = logObject[selfReferences[kSelfReference]];
            }

          // write custom fields (from context and global context)
            core.writeCustomFields(logObject, req.logger, {});

            //override values with predefined values
            core.writeStaticFields(logObject);

            // Replace all set fields, which are marked to be reduced, with a placeholder (defined in log-core.js)
            core.reduceFields(postConfig, logObject);

            if (core.checkLoggingLevel(logObject.level, req.logger))
                core.sendLog(logObject);
            logSent = true;
        }
    };
};

exports.setCoreLogger = setCoreLogger;
exports.logNetwork = logNetwork;