"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.HttpCookieAgent = void 0;
const http_1 = __importDefault(require("http"));
const create_cookie_agent_1 = require("./create_cookie_agent");
exports.HttpCookieAgent = (0, create_cookie_agent_1.createCookieAgent)(http_1.default.Agent);
