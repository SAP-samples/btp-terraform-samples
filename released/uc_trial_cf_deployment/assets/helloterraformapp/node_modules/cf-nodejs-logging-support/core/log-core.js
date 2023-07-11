const util = require("util");
const os = require("os");
const { v4: uuid } = require('uuid');
const jwt = require("jsonwebtoken");
const stringifySafe = require('json-stringify-safe');

const ENV_DYN_LOG_HEADER = "DYN_LOG_HEADER";
const ENV_DYN_LOG_KEY = "DYN_LOG_LEVEL_KEY";
const DEFAULT_DYN_LOG_LEVEL_HEADER = "SAP-LOG-LEVEL";

const REDUCED_PLACEHOLDER = "redacted";

const NS_PER_MS = 1e6;

const MAX_STACKTRACE_SIZE = 55 * 1024;

const LOG_TYPE = "log";
const LOGGING_LEVELS = {
    "off": -1,
    "error": 0,
    "warn": 1,
    "info": 2,
    "verbose": 3,
    "debug": 4,
    "silly": 5
};

var logLevelInt = 2;
var requestLogLevel = "info";

var initDummy = "{}";

var fixedValues = {};
var globalCustomFields = {};
var registeredCustomFields = [];

var pattern = null;
var patternDivider = /((?:\{\{)([^\}\{]+)(?:\}\}))/g;
var stdout = process.stdout;
var uuidCheck = /[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}/;

var preLogConfig = [];
var postLogConfig = [];
var settableConfig = [];

var dynLogLevelHeader;
var dynLogLevelKey;

var customSinkFunc;

var boundServices;

var convenientLogFunctions = [];
var convenientLevelFunctions = [];

var defaultCustomEnabled = true;
var cfCustomEnabled = false;

var lastTimestamp = 0;

// Initializes the core logger, including setup of environment var defined settings
var init = function () {
    // Read dyn. log level header name from environment var
    var headerName = process.env[ENV_DYN_LOG_HEADER];
    if (headerName != null && headerName != "null" && headerName != "") {
        dynLogLevelHeader = headerName;
    } else {
        dynLogLevelHeader = DEFAULT_DYN_LOG_LEVEL_HEADER;
    }

    // Read dyn log level key from environment var.
    dynLogLevelKey = process.env[ENV_DYN_LOG_KEY];

    // initialize convenient log level functions (e.g. log.info(...))
    for (var key in LOGGING_LEVELS) {
        if (key != "off") {
            convenientLogFunctions[key] = function (bKey) {
                return function () {
                    var args = [bKey, ...arguments];
                    return logMessage.apply(this, args);
                };
            }(key);
        }

        convenientLevelFunctions["is" + capitalize(key)] = function (bKey) {
            return function () {
                var args = [bKey];
                return isLoggingLevel.apply(this, args);
            };
        }(key);
    }

    //Reading bindings from context
    var boundServices = parseJSONSafe(process.env.VCAP_SERVICES);
    if (boundServices["application-logs"]) {
        cfCustomEnabled = true;
        defaultCustomEnabled = false;
    }
    if (boundServices["cloud-logging"]) {
        defaultCustomEnabled = true;
    }
};

var parseJSONSafe = function (value) {
    var tmp = {};
    if (value)
        try {
            tmp = JSON.parse(value);
        } catch (e) {
            tmp = {};
        }
    return tmp;
}

var setConfig = function (config) {
    precompileConfig(config);
};


// Separate core configuration (processed once, included in network and message logs) and
// pre and post configuration (processed before and after request handling)
var precompileConfig = function (config) {
    var coreConfig = [];
    preLogConfig = [];
    postLogConfig = [];
    settableConfig = [];


    for (var i = 0; i < config.length; i++) {
        var obj = config[i];

        // Check if config field needs a set env var to be enabled. If specified env var does not exist the log field gets omitted. 
        if (obj.envVarSwitch != null) {
            var val = process.env[obj.envVarSwitch];
            var pass = (val == "true" || val == "True" || val == "TRUE");
            if (!pass) {
                continue;
            }
        }

        // Check if config field needs a set env var to be written as is. If specified env var does not exist the resulting log field will set to REDUCED_PLACEHOLDER.
        if (obj.envVarRedact != null) {
            var val = process.env[obj.envVarRedact];
            var pass = (val == "true" || val == "True" || val == "TRUE");
            if (!pass) {
                obj.reduce = true;
            }
        }

        if (obj.core) {
            coreConfig.push(obj);
        } else if (obj.type != null && obj.type == "settable") {
            settableConfig.push(obj.name);
        } else if (obj.source.type == "time") {
            if (obj.source.pre)
                preLogConfig.push(obj);
            if (obj.source.post)
                postLogConfig.push(obj);
            if (!obj.source.pre && !obj.source.post) {
                obj.source.type = "static";
                obj.source.value = -1;
                preLogConfig.push(obj);
            }
        } else if ((obj.source.parent != null && obj.source.parent == "res")) {
            postLogConfig.push(obj);
        } else {
            preLogConfig.push(obj);
        }
    }

    var logObject = prepareInitDummy(coreConfig);
    initDummy = JSON.stringify(logObject);
};

// Configuration values, which result in log fields (processed before request handling)
var getPreLogConfig = function () {
    return preLogConfig;
};

// Configuration values, which result in log fields (processed after request handling)
var getPostLogConfig = function () {
    return postLogConfig;
};

var getBoundServices = function () {
    return boundServices;
}

// Assigns default values to empty fields, if defined, OR adds a reference to a configured fallback
// method otherwise.
var handleConfigDefaults = function (configEntry, logObject, fallbacks) {
    if (configEntry.mandatory && logObject[configEntry.name] == null) {
        if (configEntry.default != null) {
            logObject[configEntry.name] = configEntry.default;
        } else {
            fallbacks[configEntry.name] = configEntry.fallback;
        }
    }
};

// Replaces all fields, which are marked to be reduced and do not equal to their default value, empty or "-", to REDUCED_PLACEHOLDER.
var reduceFields = function (config, logObject) {
    for (var i = 0; i < config.length; i++) {
        var configEntry = config[i];

        if (configEntry.reduce) {
            var value = logObject[configEntry.name];
            var defaultValue = configEntry.default != null ? configEntry.default : "-";
            if (value == null || value == "" || value == defaultValue) {
                continue;
            }
            logObject[configEntry.name] = REDUCED_PLACEHOLDER;
        }
    }
};

// Stringifies and logs given object to console. If a custom pattern is set, the referenced object fields are used to replace the references.
var writeLogToConsole = function (logObject) {
    var output = "";
    var level = "";
    if (pattern != null) {
        if (logObject !== undefined && logObject != null) {
            output = "";
            level = logObject.level;

            var rest = pattern.split(patternDivider);
            var value;
            //iterates over split custom pattern, where n%3=0 is text outside the marked fields and n%3=2 are the fields to be replaced (inside {{}}), n elem rest.
            for (var i = 0; i < (rest.length - 1) / 3; i++) {
                output += rest[i * 3];
                value = logObject[rest[2 + i * 3]];
                if (value != null) {
                    if (typeof value == "string") {
                        output += value;
                    } else {
                        output += JSON.stringify(value);
                    }
                }

            }
            output += rest[rest.length - 1];
        }
    } else {
        if (logObject !== undefined && isValidObject(logObject)) {
            output = JSON.stringify(logObject);
            level = logObject.level;
        }
    }

    if (customSinkFunc) {
        // call custom sink function
        customSinkFunc(level, output);
    } else {
        // default to stdout
        stdout.write(output + os.EOL);
    }
};

// Sets the minimum logging level of current logger or global. The logging level of child loggers
// can be set to null in order to use ancestors logging level again.
// (Levels: error, warn, info, verbose, debug, silly)
var setLoggingLevel = function (level) {
    var logger = this;
    var levelInt = getLogLevelFromName(level);

    // reject unsupported level name
    if (level != null && levelInt == null) {
        return false;
    }

    // decide if logger is child logger or global
    if (logger.logObject != null) {
        // set to null is valid => use ancestor logging level again
        logger.dynamicLogLevelInt = levelInt
        return true;
    } else if (level != null) {
        // set global logging level
        logLevelInt = levelInt;
        return true;
    } else {
        // global logging level cannot be set to null
        return false;
    }
};

var setRequestLogLevel = function (level) {
    levelInt = getLogLevelFromName(level);
    if (levelInt != null) {
        requestLogLevel = level;
        return true;
    }
    return false;
}

// Gets the minimum logging level of current logger or global. (Levels: error, warn, info, verbose, debug, silly)
var getLoggingLevel = function () {
    var level = extractLoggingLevelFromLogger(this)

    for (var key in LOGGING_LEVELS) {
        if (LOGGING_LEVELS[key] == level) {
            return key;
        }
    }

    return null;
};

// Sets the given function as log sink. Following arguments will be passed to the sink function: level, output
var setSinkFunction = function (f) {
    if (f && typeof f === "function") {
        customSinkFunc = f;
    } else {
        customSinkFunc = null;
    }
};

// Initializes an empty log object
var initLog = function () {
    var logObject = JSON.parse(initDummy);

    var now = new Date();
    logObject.written_at = now.toJSON();

    var lower = process.hrtime()[1] % NS_PER_MS
    var higher = now.getTime() * NS_PER_MS

    logObject.written_ts = higher + lower;
    //This reorders written_ts, if the new timestamp seems to be smaller
    // due to different rollover times for process.hrtime and now.getTime
    if (logObject.written_ts < lastTimestamp)
        logObject.written_ts += NS_PER_MS;
    lastTimestamp = logObject.written_ts;
    return logObject;
};

//Initializes requestLog with requestLogLevel
var initRequestLog = function () {
    var logObject = initLog();
    logObject.level = requestLogLevel;
    return logObject;
}

// Creates a base log object, which contains all static and env var based fields.
var prepareInitDummy = function (coreConfig) {
    var obj = {};
    var fallbacks = [];
    var selfReferences = [];
    var configEntry;

    for (var i = 0; i < coreConfig.length; i++) {
        configEntry = coreConfig[i];
        switch (configEntry.source.type) {
            case "env":
                obj[configEntry.name] = process.env[configEntry.source.name];
                break;
            case "nested-env":
                obj[configEntry.name] = resolveNestedVariable(process.env, configEntry.source.path.slice());
                break;
            case "static":
                obj[configEntry.name] = configEntry.source.value;
                break;
            case "self":
                selfReferences[configEntry.name] = configEntry.source.name;
                break;
        }
        handleConfigDefaults(configEntry, obj, fallbacks);
    }

    for (var kFallback in fallbacks) {
        obj[kFallback] = fallbacks[kFallback](obj);
    }

    for (var kSelfReference in selfReferences) {
        obj[kSelfReference] = obj[selfReferences[kSelfReference]];
    }

    reduceFields(coreConfig, obj);
    return obj;
};

// Resolves a path to a variable in a structure of objects to its value. Parts of the object hierarchy that are represented as strings will be parsed.
var resolveNestedVariable = function (root, path) {

    // return, if path is empty.
    if (path == null || path.length == 0) {
        return null;
    }

    var rootObj;

    // if root is a string => parse it to an object. Otherwise => use it directly as object.
    if (typeof root === "string") {
        rootObj = JSON.parse(root);
    } else if (typeof root === "object") {
        rootObj = root;
    } else {
        return null;
    }

    // get value from root object
    var value = rootObj[path[0]];

    // cut first entry of the object path
    path.shift();

    // if the path is not empty, recursively resolve the remaining waypoints.
    if (path.length >= 1) {
        return resolveNestedVariable(value, path);
    }

    // return the resolved value, if path is empty.
    return value;
};

// Writes the given log file to stdout/sink
var sendLog = function (logObject) {
    writeLogToConsole(logObject);
};

// Sets a pattern, which is used to format the log output
var setLogPattern = function (p) {
    pattern = p;
};

// Logs message and custom fields
//
// Simple
// logMessage("info", "Hello World"); >> ... "msg":"Hello World" ...
//
// With additional numeric value
// logMessage("info", "Listening on port %d", 5000); >> ... "msg":"Listening on port 5000" ...
//
// With additional string values
// logMessage("info", "This %s a %s", "is", "test"); >> ... "msg":"This is a test" ...
//
// With custom fields (Added to custom_fields field) 
// logMessage("info", "Test data %j", {"field" :"value"}); >> ... "msg":"Test data %j" ... "custom_fields": {"field": "value"} ...
//
// With json object embedded in the message (nothing will be added to custom_fields)
// logMessage("info", "Test data %j", {"field" :"value"}, null); >> ... "msg":"Test data {\"field\": \"value\"}" ...
var logMessage = function () {
    var args = Array.prototype.slice.call(arguments);

    var logger = this;
    var logObject;
    var level = args[0];

    if (!checkLoggingLevel(level, logger) || level == "off") { // it is not allowed to log with level 'off'
        return false;
    } else {
        logObject = initLog();
        logObject.level = level;
    }

    args.shift();

    var customFieldsFromArgs = {};
    var lastArg = args[args.length - 1];
    if (typeof lastArg === "object") {
        if (isErrorWithStacktrace(lastArg)) {
            logObject.stacktrace = prepareStacktrace(lastArg.stack);
        } else if (isValidObject(lastArg)) {
            if (isErrorWithStacktrace(lastArg._error)) {
                logObject.stacktrace = prepareStacktrace(lastArg._error.stack);
                delete lastArg._error;
            }
            customFieldsFromArgs = lastArg;
        }
        args.pop();
    }

    var msg = util.format.apply(util, args);

    if (logger.logObject != null) {
        logObject.correlation_id = logger.logObject.correlation_id;
        if (logger.logObject.tenant_id != null) {
            logObject.tenant_id = logger.logObject.tenant_id;
        }
        if (logger.logObject.tenant_subdomain != null) {
            logObject.tenant_subdomain = logger.logObject.tenant_subdomain;
        }
        if (logger.logObject.request_id != null) {
            logObject.request_id = logger.logObject.request_id;
        }
    }


    logObject.msg = msg;
    logObject.type = LOG_TYPE;

    writeCustomFields(logObject, logger, customFieldsFromArgs);

    sendLog(logObject);
    return true;
};

var isLoggingLevel = function (level) {
    return checkLoggingLevel(level, this);
}

//setCorrelationId sets the Correlation_id for the logger this is called on. Checks i the id is a correct uuid-v4. Returns true if set, false otherwise
var setCorrelationId = function (correlationId) {
    var logger = this;
    if (logger.logObject != null) {
        if (uuidCheck.exec(correlationId)) {
            logger.logObject.correlation_id = correlationId;
            return true;
        }
    }
    return false;
};

//getCorrelationId returns the current correlation id for the logger this is called on
var getCorrelationId = function () {
    var logger = this;
    if (logger.logObject != null) {
        if (logger.logObject.correlation_id != null) {
            return logger.logObject.correlation_id;
        }
    }
    return null;
};

//setTenantId sets the tenant_id for the logger this is called on. Returns true if set, false otherwise
var setTenantId = function (tenantId) {
    var logger = this;
    if (logger.logObject != null) {
        logger.logObject.tenant_id = tenantId;
        return true;
    }
    return false;
};

//getTenantId returns the current tenant id for the logger this is called on
var getTenantId = function () {
    var logger = this;
    if (logger.logObject != null) {
        if (logger.logObject.tenant_id != null) {
            return logger.logObject.tenant_id;
        }
    }
    return null;
};

//setTenantSubdomain sets the tenant_subdomain for the logger this is called on. Returns true if set, false otherwise
var setTenantSubdomain = function (tenantSubdomain) {
    var logger = this;
    if (logger.logObject != null) {
        logger.logObject.tenant_subdomain = tenantSubdomain;
        return true;
    }
    return false;
};

//getTenantSubdomain returns the current tenant subdomain for the logger this is called on
var getTenantSubdomain = function () {
    var logger = this;
    if (logger.logObject != null) {
        if (logger.logObject.tenant_subdomain != null) {
            return logger.logObject.tenant_subdomain;
        }
    }
    return null;
};

// Registers a (white)list of allowed custom field names
var registerCustomFields = function (fieldNames) {

    registeredCustomFields = [];

    if (!Array.isArray(fieldNames)) return false;

    var list = [];
    for (var name of fieldNames) {
        if (typeof name != "string") {
            return false;
        } else {
            list.push(name);
        }
    }

    // copy without references
    registeredCustomFields = JSON.parse(JSON.stringify(list));
    return true;
};

// Sets custom fields, which will be added to each message logged using the corresponding context.
var setCustomFields = function (customFields) {
    var logger = this;
    if (isValidObject(customFields, true)) {
        if (logger.logObject != null) {
            logger.customFields = customFields;
        } else {
            globalCustomFields = customFields;
        }
        return true;
    }
    return false;
};

// Create a new logger for message logs
var createLogger = function (customFields) {
    var logger = {};

    // Check if the method was call on a logger instance
    if (this.logObject != null) {
        logger.customFields = {};

        // assign reference to logObject of parent logger
        logger.logObject = this.logObject;

        // assign parent (required to inherit custom fields)
        logger.parent = this;
    } else {
        logger.customFields = {};

        // create a new logObject including a correlation id and assign
        // it to the logger.
        logger.logObject = {
            correlation_id: uuid()
        };
    }

    // bind api functions
    bindConvenienceMethods(logger);
    bindLogFunctions(logger);

    // assign custom fields, if provided
    if (customFields) {
        logger.setCustomFields(customFields);
    }

    return logger;
};

// Read custom fields from provided logger and add them to the provided logObject.
// If additionalFields contains fields, that already exist, these fields will be overwritten.
var writeCustomFields = function (logObject, logger, additionalFields) {
    var providedFields = Object.assign({}, extractCustomFieldsFromLogger(logger), additionalFields);

    var customFields = {};
    var value;
    for (var key in providedFields) {
        value = providedFields[key];

        // Stringify, if necessary.
        if ((typeof value) != "string") {
            value = stringifySafe(value);
        }

        if (defaultCustomEnabled || logObject[key] != null || isSettable(key))
            logObject[key] = value;

        if (cfCustomEnabled)
            customFields[key] = value;
    }

    //writes custom fields in the correct order and correlates i to the place in registeredCustomFields
    Object.keys(customFields).length
    if (Object.keys(customFields).length > 0) {
        var res = {};
        res.string = [];
        counter = 0;
        var key;
        for (var i = 0; i < registeredCustomFields.length; i++) {
            key = registeredCustomFields[i]
            if (customFields[key])
                res.string.push({
                    "k": key,
                    "v": customFields[key],
                    "i": i
                })
        }
        if (res.string.length > 0)
            logObject["#cf"] = res;
    }
}

var isSettable = function (key) {
    if (settableConfig.length == 0) return false;
    for (var i = 0; i < settableConfig.length; i++) {
        if (settableConfig[i] == key) return true;
    }
    return false;
}

// Checks wether the given level passes the logging level threshold extracted from the given logger or its 
// ancestors.
var checkLoggingLevel = function (level, logger) {
    var threshold = extractLoggingLevelFromLogger(logger);
    return (threshold >= LOGGING_LEVELS[level]);
};

// Recursive method, which reads the logging level threshold from the given logger or the closest ancestor 
// having a logging level threshold set. If there is not ancestor and no threshold available, the global logging 
// level threshold is returned.
var extractLoggingLevelFromLogger = function (logger) {
    if (logger && logger.dynamicLogLevelInt != null) {
        return logger.dynamicLogLevelInt;
    } else if (logger && logger.parent && logger.parent !== logger) {
        return extractLoggingLevelFromLogger(logger.parent);
    } else {
        return logLevelInt;
    }
};

// Recursive method, which reads provided custom fields from the given logger, its parent loggers
// and global custom fields variable, with descending priority
var extractCustomFieldsFromLogger = function (logger) {
    var fields = {};

    if (logger.parent && logger.parent !== logger) {
        fields = extractCustomFieldsFromLogger(logger.parent);
    } else {
        fields = Object.assign(fields, globalCustomFields);
    }

    if (isValidObject(logger.customFields)) {
        fields = Object.assign(fields, logger.customFields);
    }

    return fields;
};

// Adds a logger instance to the provided request and assigns all required fields and api methods
var bindLoggerToRequest = function (req, logObject) {
    req.logger = {
        logObject: logObject,
        customFields: {}
    };

    bindLogFunctions(req.logger);
    bindConvenienceMethods(req.logger);

    req.getLogger = function () {
        return this.logger;
    };

    req.createLogger = function (customFields) {
        return this.logger.createLogger(customFields)
    };
};

// Add api methods to logger object
var bindLogFunctions = function (logger) {
    logger.logMessage = logMessage;
    logger.isLoggingLevel = isLoggingLevel;
    logger.getCorrelationId = getCorrelationId;
    logger.setCorrelationId = setCorrelationId;
    logger.setTenantId = setTenantId;
    logger.getTenantId = getTenantId;
    logger.setTenantSubdomain = setTenantSubdomain;
    logger.getTenantSubdomain = getTenantSubdomain;
    logger.setDynamicLoggingLevel = setLoggingLevel; // deprecated
    logger.setLoggingLevel = setLoggingLevel;
    logger.getLoggingLevel = getLoggingLevel;
    logger.setCustomFields = setCustomFields;
    logger.createLogger = createLogger;
};

// Add convenience methods to logger object
var bindConvenienceMethods = function (logger) {
    for (var key in convenientLogFunctions) {
        logger[key] = convenientLogFunctions[key];
    }

    for (var key in convenientLevelFunctions) {
        logger[key] = convenientLevelFunctions[key];
    }
};


// checks if the given argument is a non-empty instance of Object
var isValidObject = function (obj, canBeEmpty) {
    if (obj === null || obj === undefined) {
        return false;
    } else if (typeof obj !== "object") {
        return false;
    } else if (!canBeEmpty && Object.keys(obj).length === 0) {
        return false;
    }
    return true;
};

// check if the given object is an Error with stacktrace using duck typing
var isErrorWithStacktrace = function (obj) {
    if (obj && obj.stack && obj.message && typeof obj.stack === "string" && typeof obj.message === "string") {
        return true;
    }
    return false;
}

// Split stacktrace into string array and truncate lines if required by size limitation
// Truncation strategy: Take one line from the top and two lines from the bottom of the stacktrace until limit is reached.
var prepareStacktrace = function (stacktraceStr) {
    var fullStacktrace = stacktraceStr.split('\n');
    var totalLineLength = fullStacktrace.reduce((acc, line) => acc + line.length, 0);

    if (totalLineLength > MAX_STACKTRACE_SIZE) {
        var truncatedStacktrace = [];
        var stackA = [];
        var stackB = [];
        var indexA = 0;
        var indexB = fullStacktrace.length - 1;
        var currentLength = 73; // set to approx. character count for "truncated" and "omitted" labels

        for (let i = 0; i < fullStacktrace.length; i++) {
            if (i % 3 == 0) {
                let line = fullStacktrace[indexA++];
                if (currentLength + line.length > MAX_STACKTRACE_SIZE) {
                    break;
                }
                currentLength += line.length;
                stackA.push(line);
            } else {
                let line = fullStacktrace[indexB--];
                if (currentLength + line.length > MAX_STACKTRACE_SIZE) {
                    break;
                }
                currentLength += line.length;
                stackB.push(line);
            }
        }

        truncatedStacktrace.push("-------- STACK TRACE TRUNCATED --------");
        truncatedStacktrace = [...truncatedStacktrace, ...stackA];
        truncatedStacktrace.push(`-------- OMITTED ${fullStacktrace.length - (stackA.length + stackB.length)} LINES --------`);
        truncatedStacktrace = [...truncatedStacktrace, ...stackB.reverse()];
        return truncatedStacktrace;
    }
    return fullStacktrace;
}

// writes static field values to the given logObject
var writeStaticFields = function (logObject) {
    for (var key in fixedValues) {
        logObject[key] = fixedValues[key];
    }
};

// overrides values in ALL network logs (will impact log parsing, so use with caution!), returns true if field is set.
var overrideField = function (field, value) {
    if (field != null && typeof field == "string") {
        if (value == undefined || value == null) {
            fixedValues[field] = undefined;
            return true;
        } else {
            fixedValues[field] = value;
            return true;
        }
    }
    return false;
};

//Sets the custom field format by hand. Returns true on correct strings.
var overrideCustomFieldFormat = function (value) {
    if (typeof value == "string") {
        switch (value) {
            case "application-logging":
                defaultCustomEnabled = false;
                cfCustomEnabled = true;
                break;
            case "all":
                defaultCustomEnabled = true;
                cfCustomEnabled = true;
                break;
            case "disabled":
                defaultCustomEnabled = false;
                cfCustomEnabled = false;
                break;
            case "default":
            case "cloud-logging":
                defaultCustomEnabled = true;
                cfCustomEnabled = false;
                break;
            default:
                defaultCustomEnabled = true;
                cfCustomEnabled = false;
                return false;
        }
        return true;
    } else {
        defaultCustomEnabled = true;
        cfCustomEnabled = false;
        return false;
    }
}

// Get the name of the dynamic log level header
var getDynLogLevelHeaderName = function () {
    return dynLogLevelHeader;
};

// Gets the log level number from a given level name
var getLogLevelFromName = function (levelName) {
    if (levelName == null) return null;
    return (LOGGING_LEVELS[levelName.toLowerCase()] != undefined) ? LOGGING_LEVELS[levelName.toLowerCase()] : null;
};

// Binds the Loglevel extracted from JWT token to the given request logger
var bindDynLogLevel = function (token, logger) {
    var payload = verifyAndDecodeJWT(token, dynLogLevelKey);

    if (payload) {
        logger.dynamicLogLevelInt = getLogLevelFromName(payload.level);
    }
};

// Verifies the given JWT and returns its payload.
var verifyAndDecodeJWT = function (token, key) {
    if (!token || !key || typeof key !== "string") {
        return null; // no public key or jwt provided
    }

    try {
        if (key.match(/BEGIN PUBLIC KEY/))
            return jwt.verify(token, key, { algorithms: ["RS256", "RS384", "RS512"] });
        else
            return jwt.verify(token, "-----BEGIN PUBLIC KEY-----\n" + key + "\n-----END PUBLIC KEY-----", { algorithms: ["RS256", "RS384", "RS512"] });
    } catch (err) {
        return null; // token expired or invalid
    }
};

// replaces the first character of the given string with its uppercase version
var capitalize = function (text) {
    return text.charAt(0).toUpperCase() + text.slice(1);
};

// internal api methods used by effective loggers
exports.bindConvenienceMethods = bindConvenienceMethods;
exports.bindDynLogLevel = bindDynLogLevel;
exports.bindLoggerToRequest = bindLoggerToRequest;
exports.checkLoggingLevel = checkLoggingLevel;
exports.getDynLogLevelHeaderName = getDynLogLevelHeaderName;
exports.getPostLogConfig = getPostLogConfig;
exports.getPreLogConfig = getPreLogConfig;
exports.handleConfigDefaults = handleConfigDefaults;
exports.isValidObject = isValidObject;
exports.init = init;
exports.initLog = initLog;
exports.initRequestLog = initRequestLog;
exports.reduceFields = reduceFields;
exports.sendLog = sendLog;
exports.writeCustomFields = writeCustomFields;
exports.writeStaticFields = writeStaticFields;
exports.setConfig = setConfig;

// external api methods
exports.createLogger = createLogger;
exports.logMessage = logMessage;
exports.isLoggingLevel = isLoggingLevel;
exports.getLoggingLevel = getLoggingLevel;
exports.registerCustomFields = registerCustomFields;
exports.setCustomFields = setCustomFields;
exports.setLoggingLevel = setLoggingLevel;
exports.setRequestLogLevel = setRequestLogLevel;
exports.setLogPattern = setLogPattern;
exports.setSinkFunction = setSinkFunction;
exports.overrideField = overrideField;
exports.overrideCustomFieldFormat = overrideCustomFieldFormat;
exports.getBoundServices = getBoundServices;
