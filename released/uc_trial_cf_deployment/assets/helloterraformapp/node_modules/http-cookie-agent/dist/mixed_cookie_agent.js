"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MixedCookieAgent = void 0;
const agent_base_1 = __importDefault(require("agent-base"));
const http_cookie_agent_1 = require("./http_cookie_agent");
const https_cookie_agent_1 = require("./https_cookie_agent");
class MixedCookieAgent extends agent_base_1.default.Agent {
    jar;
    _httpAgent;
    _httpsAgent;
    constructor(options) {
        super();
        this._httpAgent = new http_cookie_agent_1.HttpCookieAgent(options);
        this._httpsAgent = new https_cookie_agent_1.HttpsCookieAgent(options);
        this.jar = options.jar;
    }
    callback(_req, options) {
        return options.secureEndpoint ? this._httpsAgent : this._httpAgent;
    }
}
exports.MixedCookieAgent = MixedCookieAgent;
