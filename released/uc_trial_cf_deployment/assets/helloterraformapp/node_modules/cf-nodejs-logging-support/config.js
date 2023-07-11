const { v4: uuid } = require('uuid');

/* FIELD CONFIGURATION 
 *  
 * Config description:
 * 
 * name:            The name of the field in log output
 * mandatory:       If true: Use default value OR fallback function result if value is null. If false: omit field, if value is null.
 * core: If true:   Add field also to message logs
 * envVarRedact:    If set: 
 *                      Only log this field, if specified environment variable is set to "true". 
 *                      If specified environment variable is not set to "true" or not present, field gets omitted. This is also affects 
 *                      fields marked as mandatory.
 * envVarRedact:    If set: 
 *                      Only log this field, if specified environment variable is set to "true". 
 *                      If specified environment variable is not set to "true" or not present, field gets set to "redacted" if it is not 
 *                      set to its default value or null.
 * source:          Source of the field value.
 *   type:          One of
 *                     "static": use value from value field.
 *                     "env": read value from environment variable.
 *                     "nested-env": read value from environment variable with json object. Select variable and field by specifying a path.
 *                     "self": copy value from another configured field.
 *                     "header": read value from request/response header.
 *                     "field": read value from request/response object.
 *                     "time": intended to be used for time/duration calculations.
 *                          calls method pre(req, res, logObject) when a request arrives. The log field gets set to the returned value.
 *                          calls method post(req, res, logObject) when the response got sent. The log field gets set to the returned value.
 *                     "special": calls the fallback(req, res, logObject) directly and sets the log field to the returned value.
 *   name:          Key name for "env", "self", "header" and "field" sources.
 *   path:          Path for "nested-env" source.
 *   value:         Value for "static" source.
 *   parent:        Parent for "header" and "field" source: Can be "req" to access the request and "res" to access the response.
 *   pre:           Define a pre(req, res, logObject) function for time source.
 *   post:          Define a post(req, res, logObject) function for time source.
 */

var config = [
    {
        name: "component_type",
        mandatory: true,
        core: true,
        source: {
            type: "static",
            value: "application"
        }
    }, {
        name: "component_id",
        mandatory: true,
        core: true,
        source: {
            type: "nested-env",
            path: ["VCAP_APPLICATION", "application_id"]
        },
        default: "-"
    }, {
        name: "component_name",
        mandatory: true,
        core: true,
        source: {
            type: "nested-env",
            path: ["VCAP_APPLICATION", "application_name"]
        },
        default: "-"
    }, {
        name: "component_instance",
        mandatory: true,
        core: true,
        source: {
            type: "nested-env",
            path: ["VCAP_APPLICATION", "instance_index"]
        },
        default: "0"
    }, {
        name: "source_instance",
        mandatory: false,
        core: true,
        source: {
            type: "self",
            name: "component_instance"
        }
    }, {
        name: "layer",
        mandatory: true,
        core: true,
        source: {
            type: "static",
            value: "[NODEJS]"
        }
    }, {
        name: "organization_name",
        mandatory: true,
        core: true,
        source: {
            type: "nested-env",
            path: ["VCAP_APPLICATION", "organization_name"]
        },
        default: "-"
    }, {
        name: "organization_id",
        mandatory: true,
        core: true,
        source: {
            type: "nested-env",
            path: ["VCAP_APPLICATION", "organization_id"]
        },
        default: "-"
    }, {
        name: "space_name",
        mandatory: true,
        core: true,
        source: {
            type: "nested-env",
            path: ["VCAP_APPLICATION", "space_name"]
        },
        default: "-"
    }, {
        name: "space_id",
        mandatory: true,
        core: true,
        source: {
            type: "nested-env",
            path: ["VCAP_APPLICATION", "space_id"]
        },
        default: "-"
    }, {
        name: "container_id",
        mandatory: true,
        core: true,
        source: {
            type: "env",
            name: "CF_INSTANCE_IP"
        },
        default: "-"
    }, {
        name: "logger",
        mandatory: true,
        core: true,
        source: {
            type: "static",
            value: "nodejs-logger"
        }
    }, {
        name: "request_id",
        mandatory: true,
        source: {
            type: "header",
            name: "x-vcap-request-id"
        },
        default: "-"
    }, {
        name: "request_size_b",
        mandatory: true,
        source: {
            type: "header",
            name: "content-length"
        },
        default: -1
    }, {
        name: "type",
        mandatory: true,
        source: {
            type: "static",
            value: "request"
        }
    }, {
        name: "request",
        mandatory: true,
        source: {
            type: "field",
            name: "originalUrl"
        },
        default: "-"
    }, {
        name: "response_status",
        mandatory: true,
        source: {
            type: "field",
            parent: "res",
            name: "statusCode"
        },
        default: 200
    }, {
        name: "method",
        mandatory: true,
        source: {
            type: "field",
            name: "method"
        },
        default: "-"
    }, {
        name: "response_size_b",
        mandatory: true,
        source: {
            type: "header",
            parent: "res",
            name: "content-length"
        },
        default: -1
    }, {
        name: "response_content_type",
        mandatory: true,
        source: {
            type: "header",
            parent: "res",
            name: "content-type"
        },
        default: "-"

    }, {
        name: "remote_host",
        mandatory: true,
        envVarRedact: "LOG_SENSITIVE_CONNECTION_DATA",
        source: {
            type: "special"
        },
        fallback: (req, res, logObj) => {
            return req.connection.remoteAddress == null ? "-" : req.connection.remoteAddress;
        }
    }, {
        name: "remote_port",
        mandatory: true,
        envVarRedact : "LOG_SENSITIVE_CONNECTION_DATA",
        source: {
            type: "special"
        },
        fallback: (req, res, logObj) => {
            return req.connection.remotePort == null ? "-" : req.connection.remotePort.toString();
        }
    }, {
        name: "remote_user",
        mandatory: true,
        envVarRedact: "LOG_REMOTE_USER",
        source: {
            type: "special",
            parent: "res", // use "res" to force late evaluation
        },
        fallback: (req, res, logObj) => {
            if (req.user && req.user.id) {
                return req.user.id;
            }
            return "-"
        }
    }, {
        name: "direction",
        mandatory: true,
        source: {
            type: "static",
            value: "IN"
        }
    }, {
        name: "remote_ip",
        mandatory: false,
        envVarRedact: "LOG_SENSITIVE_CONNECTION_DATA",
        source: {
            type: "self",
            name: "remote_host"
        }
    }, {
        name: "request_received_at",
        mandatory: false,
        source: {
            type: "self",
            name: "written_at"
        }
    }, {
        name: "protocol",
        mandatory: true,
        source: {
            type: "special"
        },
        fallback: (req, res, logObj) => {
            return "HTTP" + (req.httpVersion == null ? "" : "/" + req.httpVersion);
        }
    }, {
        name: "response_time_ms",
        mandatory: true,
        source: {
            type: "time",
            pre: () => {
                return Date.now();
            },
            post: (req, res, logObj) => {
                return Date.now() - logObj.response_time_ms;
            }
        }
    }, {
        name: "response_sent_at",
        mandatory: true,
        source: {
            type: "time",
            post: (req, res, logObj) => {
                return (new Date()).toJSON();
            }
        }
    }, {
        name: "referer",
        mandatory: true,
        envVarRedact: "LOG_REFERER",
        source: {
            type: "header",
            name: "referer"
        },
        default: "-"
    }, {
        name: "correlation_id",
        mandatory: true,
        source: {
            type: "header",
            name: "x-correlationid"
        },
        fallback: (req, res, logObject) => {
            return (logObject.request_id != null && logObject.request_id != "-") ? logObject.request_id : uuid();
        }
    }, {
        name: "tenant_id",
        mandatory: true,
        source: {
            type: "header",
            name: "tenantid"
        },
        default: "-"
    }, {
        name: "tenant_subdomain",
        mandatory: true,
        source: {
            type: "static",
        },
        default: "-"
    }, {
        name: "x_forwarded_for",
        mandatory: false,
        envVarRedact: "LOG_SENSITIVE_CONNECTION_DATA",
        source: {
            type: "header",
            name: "x-forwarded-for"
        }
    }, {
        name: "x_custom_host",
        mandatory: false,
        envVarRedact: "LOG_SENSITIVE_CONNECTION_DATA",
        source: {
            type: "header",
            name: "x-custom-host"
        }
    }, {
        name: "x_forwarded_host",
        mandatory: false,
        envVarRedact: "LOG_SENSITIVE_CONNECTION_DATA",
        source: {
            type: "header",
            name: "x-forwarded-host"
        }
    }, {
        name: "x_forwarded_proto",
        mandatory: false,
        envVarRedact: "LOG_SENSITIVE_CONNECTION_DATA",
        source: {
            type: "header",
            name: "x-forwarded-proto"
        }
    }, {
        name: "x_ssl_client",
        mandatory: true,
        envVarSwitch: "LOG_SSL_HEADERS",
        source: {
            type: "header",
            name: "x-ssl-client"
        },
        default: "-"
    }, {
        name: "x_ssl_client_verify",
        mandatory: true,
        envVarSwitch: "LOG_SSL_HEADERS",
        source: {
            type: "header",
            name: "x-ssl-client-verify"
        },
        default: "-"
    }, {
        name: "x_ssl_client_subject_dn",
        mandatory: true,
        envVarSwitch: "LOG_SSL_HEADERS",
        source: {
            type: "header",
            name: "x-ssl-client-subject-dn"
        },
        default: "-"
    }, {
        name: "x_ssl_client_subject_cn",
        mandatory: true,
        envVarSwitch: "LOG_SSL_HEADERS",
        source: {
            type: "header",
            name: "x-ssl-client-subject-cn"
        },
        default: "-"
    }, {
        name: "x_ssl_client_issuer_dn",
        mandatory: true,
        envVarSwitch: "LOG_SSL_HEADERS",
        source: {
            type: "header",
            name: "x-ssl-client-issuer-dn"
        },
        default: "-"
    }, {
        name: "x_ssl_client_notbefore",
        mandatory: true,
        envVarSwitch: "LOG_SSL_HEADERS",
        source: {
            type: "header",
            name: "x-ssl-client-notbefore"
        },
        default: "-"
    }, {
        name: "x_ssl_client_notafter",
        mandatory: true,
        envVarSwitch: "LOG_SSL_HEADERS",
        source: {
            type: "header",
            name: "x-ssl-client-notafter"
        },
        default: "-"
    }, {
        name: "x_ssl_client_session_id",
        mandatory: true,
        envVarSwitch: "LOG_SSL_HEADERS",
        source: {
            type: "header",
            name: "x-ssl-client-session-id"
        },
        default: "-"
    }
];


exports.config = config;
