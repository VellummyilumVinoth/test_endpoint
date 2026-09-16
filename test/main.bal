import ballerina/http;
import ballerinax/ai.wso2.integration;

listener integration:CloudVoiceListener voiceListener = check new (9099);

service /agent on voiceListener {
    isolated remote function onChatMessage(integration:ChatMessage message) returns string|error {
        return "echo:" + message.message;
    }
}

service /greeting on new http:Listener(9090) {

    resource function get sayHello(string name) returns string {
        return string `Hello, ${name}`;
    }

    resource function post greetings(@http:Payload json payload) returns json|error {
        // process payload
        return payload;
    }
}
