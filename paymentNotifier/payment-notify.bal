// A system package containing protocol access constructs
// Package objects referenced with 'http:' in code
import ballerina/config;
import ballerina/log;
import ballerina/io;
import ballerina/time;
import ballerina/runtime;

documentation {
   A service endpoint represents a listener.
}

int currentMonth = 8;
boolean notified = false;
//string sheetName = "payment-members";

function main(string... args) {
    worker checker{
        while(true){
            checkEveryThing();
            runtime:sleep(3600*24*1000);
        }
    }
}

documentation{
    Send notification to the customers.
}

function checkEveryThing(){
    int rawCount = getRawCount();
    io:println("Count : "+<string>rawCount);
    if(checkForMonth()){
        if(rawCount>1){
            int lastUsedRaw = 0;
            string[][] values = getCustomerDetailsFromGSheet("G2","G"+<string> rawCount);
            foreach value in values{
                if(value[0]!=""){
                    lastUsedRaw++;
                }
            }
            resetPayment(lastUsedRaw);
            notified = false;
        }
    }else if(checkForNotification()){
        string[][] members = getUnpaidMembers(rawCount);
        if(sendNotification(members)){
            notified = true;
        }
    }
}

function sendNotification(string[][] members) returns (boolean){
    foreach member in members {
        string[] payload = [];
        //var response = twilioService->post("/sendsms",{"sender":"+18503973832","receiver":"+94"+member[3],"message":"Hey "+member[1]+", Hope you are doing great at the gym. Seems like you have missed the payments for this month."});
        boolean status = sendASMS("+18503973832","+94"+member[3],"Hey "+member[1]+", Hope you are doing great at the gym. Seems like you have missed the payments for this month.");
        if(!status){
            return false;
        }
    }
    return true;
}

function checkForMonth() returns (boolean){
    time:Time time = time:currentTime();
    if(time.month()!=currentMonth){
        currentMonth = time.month();
        return true;
    }
    return false;
}

function checkForNotification() returns (boolean){
    time:Time time = time:currentTime();
    if(time.day()>3 && (!notified)){
        notified = true;
        return true;
    }
    return false;
}

function resetPayment(int noOfRaws){
    string[][] outValues = [];
    int i=0;
    while(i<noOfRaws){
        outValues[i]=["0"];
        i++;
    }
    boolean response = setCustomerDetailsToGSheet(noOfRaws,outValues);
}

function getUnpaidMembers(int rowCount) returns (string[][]){
    string[][] response = getCustomerDetailsFromGSheet("A2","G"+<string>rowCount);
    string[][] members = [];
    int i = 0;
    foreach member in response{
        if(member[6]=="0" && member[5]!=""){
            members[i] = [member[0],member[1],member[2],member[5]];
            i++;
        }
    }
    return members;
}