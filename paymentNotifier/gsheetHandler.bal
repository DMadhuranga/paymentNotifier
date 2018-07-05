documentation{
    This handler handles the communication between application and the google sheets service.
}

import wso2/gsheets4;

string spreadsheetId = config:getAsString("gsheets.SPREADSHEET");

endpoint gsheets4:Client spreadsheetClient {
    clientConfig: {
        auth: {
            accessToken: config:getAsString("gsheets.ACCESS_TOKEN"),
            refreshToken: config:getAsString("gsheets.REFRESH_TOKEN"),
            clientId: config:getAsString("gsheets.CLIENT_ID"),
            clientSecret: config:getAsString("gsheets.CLIENT_SECRET")
        }
    }
};

function getCustomerDetailsFromGSheet(string leftCell, string rightCell) returns (string[][]) {
    string[][] values;
    var spreadsheetRes =  spreadsheetClient->getSheetValues(spreadsheetId, "member-details", leftCell, rightCell);
    match spreadsheetRes {
        string[][] vals => {
            log:printInfo("Retrieved customer details from spreadsheet id:" + spreadsheetId + " ; sheet name: "
                    + "");
            return vals;
        }
        gsheets4:SpreadsheetError e => return values;
    }
}

function setCustomerDetailsToGSheet(int noOfRaws, string[][] outValues) returns (boolean) {
    var spreadsheetRes = spreadsheetClient->setSheetValues(spreadsheetId, "member-details", "G2", "G"+<string>(noOfRaws+1),outValues);
    match spreadsheetRes {
        boolean vals => return vals;
        gsheets4:SpreadsheetError e => return false;
    }
}

function setOneCustomerDetailsToGSheet(int noOfRaws, string[][] outValues) returns (boolean) {
    var spreadsheetRes = spreadsheetClient->setSheetValues(spreadsheetId, "member-details", "G"+<string>(noOfRaws+1), "G"+<string>(noOfRaws+1),outValues);
    match spreadsheetRes {
        boolean vals => return vals;
        gsheets4:SpreadsheetError e => return false;
    }
}

function getRawCount() returns (int){
    var response = spreadsheetClient->openSpreadsheetById(spreadsheetId);
    match response {
        gsheets4:Spreadsheet spreadsheetRes => return spreadsheetRes.sheets[0].properties.gridProperties.rowCount;
        gsheets4:SpreadsheetError err => return 0;
    }
}
