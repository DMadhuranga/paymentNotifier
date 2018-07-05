documentation{
    This handler handles the communication between application and the twilio sms service.
}

import ballerina/io;
import wso2/twilio;

endpoint twilio:Client twilio {
    accountSId: config:getAsString("twilio.accountSId"),
    authToken:config:getAsString("twilio.authToken"),
    xAuthyKey:config:getAsString("twilio.xAuthyKey")
};

function sendASMS(string sender,string reciever,string message) returns (boolean){
    //Send sms according to the given details.
    
    var details = twilio->sendSms(sender,reciever,message);
    match details {
        twilio:SmsResponse smsResponse => return true;
        twilio:TwilioError twilioError => return false;
    }
}
