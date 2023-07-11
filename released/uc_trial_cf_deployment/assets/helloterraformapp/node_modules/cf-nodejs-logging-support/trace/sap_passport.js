var config = [
    {
        name: "sap_passport",
        mandatory: false,
        source: {
            type: "header",
            name: "sap-passport"
        }
    }, {
        name: "sap_passport_Action",
        type: "settable"
    }, {
        name: "sap_passport_ActionType",
        type: "settable"
    }, {
        name: "sap_passport_ClientNumber",
        type: "settable"
    }, {
        name: "sap_passport_ConnectionCounter",
        type: "settable"
    }, {
        name: "sap_passport_ConnectionId",
        type: "settable"
    }, {
        name: "sap_passport_ComponentName",
        type: "settable"
    }, {
        name: "sap_passport_ComponentType",
        type: "settable"
    }, {
        name: "sap_passport_PreviousComponentName",
        type: "settable"
    }, {
        name: "sap_passport_TraceFlags",
        type: "settable"
    }, {
        name: "sap_passport_TransactionId",
        type: "settable"
    }, {
        name: "sap_passport_RootContextId",
        type: "settable"
    }, {
        name: "sap_passport_UserId",
        type: "settable"
    }
];


exports.config = config;

