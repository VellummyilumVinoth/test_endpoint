import ballerina/http;
import ballerina/log;
import ballerinax/ai.wso2.integration;
import ballerina/ai;

listener integration:CloudVoiceListener voiceListener = check new (9092);

listener http:Listener httpListener = check new (9090, httpVersion = "1.1");
listener ai:Listener chatAgentListener = new (listenOn = httpListener);

service /voiceAgent on voiceListener {
    isolated remote function onChatMessage(integration:ChatMessage message) returns string|error {
        log:printInfo("Message: ", input = message);
        string response = check mathTutorAgent.run(message.message, message.sessionId);
        log:printInfo("Response: ", output = response);
        return response;
    }
}

service /greeting on new http:Listener(9091) {

    resource function get sayHello(string name) returns string {
        return string `Hello, ${name}`;
    }

    resource function post greetings(@http:Payload json payload) returns json|error {
        // process payload
        return payload;
    }
}

service /mathTutor on chatAgentListener {
    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string stringResult = check mathTutorAgent.run(request.message, request.sessionId);
        return {message: stringResult};
    }
}