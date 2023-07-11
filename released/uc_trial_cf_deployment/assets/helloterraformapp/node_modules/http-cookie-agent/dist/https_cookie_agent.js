"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.HttpsCookieAgent = void 0;
const https_1 = __importDefault(require("https"));
const create_cookie_agent_1 = require("./create_cookie_agent");
exports.HttpsCookieAgent = (0, create_cookie_agent_1.createCookieAgent)(https_1.default.Agent);
