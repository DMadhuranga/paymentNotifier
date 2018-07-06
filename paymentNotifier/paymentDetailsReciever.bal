import ballerina/config;
import ballerina/log;
import ballerina/io;
import ballerina/http;

documentation{
   This service handles incoming requests that contain payment data and write to google sheet.
}

endpoint http:Listener listener {
    port:9092
};

@http:ServiceConfig {
    basePath: "/"
}

service<http:Service> hello bind listener {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/memberPaid"
    }

    sayHello (endpoint caller, http:Request request) {

        http:Response response = new;
        string memberId = check request.getTextPayload();
        int rawCount = getRawCount();
        if(rawCount>1){
            int rawNumber = 0;
            boolean notFound = false;
            string[][] members = getCustomerDetailsFromGSheet("A2","G"+<string> rawCount);
            rawCount = lengthof members;
            while((rawNumber<rawCount) && (!notFound)){
                if(members[rawNumber][0]==memberId){
                    notFound = true;
                }else{
                    rawNumber++;
                }
            }
            if(notFound){
                string[][] data = [["1"]];
                boolean status = setOneCustomerDetailsToGSheet(rawNumber+1,data);
                if(status){
                    response.setTextPayload("Done\n");
                }else{
                    response.setTextPayload("Invalid member\n");
                }
            }else{
                response.setTextPayload("Invalid member\n");
            }
        }else{
            response.setTextPayload("Invalid member\n");
        }
        _ = caller -> respond(response);



    }
}
