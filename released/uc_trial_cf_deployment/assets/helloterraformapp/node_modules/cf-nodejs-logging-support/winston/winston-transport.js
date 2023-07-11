const Transport = require("winston-transport");
const { SPLAT } = require("triple-beam");

const CfNodejsLoggingSupportLogger = class CfNodejsLoggingSupportLogger extends Transport {
    constructor(options) {
        super(options);
        this.name = "CfNodejsLoggingSupportLogger";
        this.level = options.level || "info";
        this.logMessage = options.logMessage;
    }

    log(info, callback) {
        setImmediate(() => {
            this.emit('logged',info);
        });
        
        if (info[SPLAT]) {
            this.logMessage.apply(this, [info.level, info.message, ...info[SPLAT]]);
        } else {
            this.logMessage(info.level, info.message);
        }

        callback();
    }
};

exports.createTransport = function (options) {
    return new CfNodejsLoggingSupportLogger(options);
};