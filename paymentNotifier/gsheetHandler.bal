import wso2/gsheets4;

documentation{
    This handler handles the communication between application and the google sheets service.
}

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
    // Return the data of requested cells of the google sheet
    
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
    // Write given data into the cells in payment_done column in the requested raws
    
    var spreadsheetRes = spreadsheetClient->setSheetValues(spreadsheetId, "member-details", "G2", "G"+<string>(noOfRaws+1),outValues);
    match spreadsheetRes {
        boolean vals => return vals;
        gsheets4:SpreadsheetError e => return false;
    }
}

function setOneCustomerDetailsToGSheet(int noOfRaws, string[][] outValues) returns (boolean) {
    // Write given data into the cell in payment_done column and requested raw
    
    var spreadsheetRes = spreadsheetClient->setSheetValues(spreadsheetId, "member-details", "G"+<string>(noOfRaws+1), "G"+<string>(noOfRaws+1),outValues);
    match spreadsheetRes {
        boolean vals => return vals;
        gsheets4:SpreadsheetError e => return false;
    }
}

function getRawCount() returns (int){
    // Return the number of raws available in the google sheet
    
    var response = spreadsheetClient->openSpreadsheetById(spreadsheetId);
    match response {
        gsheets4:Spreadsheet spreadsheetRes => return spreadsheetRes.sheets[0].properties.gridProperties.rowCount;
        gsheets4:SpreadsheetError err => return 0;
    }
}
