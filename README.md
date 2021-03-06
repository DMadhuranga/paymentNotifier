# Payment Notifier

## Why payment notifier

Payment notifier notify members of an organization on their due payments. For an example consider a swimming club which require its members to pay a monthly fee to the swimming club. Managers/Owners of the organization may hesitate to approach members and ask them directly on due payments. And also if the number of members are significantly high, it might be difficult to practically approach each member. Therefore, the proposed system will send an auto-generated SMS to the members who have not paid the monthly fee. In the swimming club, they may have a policy stating that the members need to pay monthly fee before 10th day of the month.  After the 10th day of the month, members who have not paid the monthly fee will get a notification SMS reminding of due payment. There could be multiple iterations such as notification after 15th day and again after 20th day according to the policies of the organization.

## Design

Google Spreadsheets service and Twilio SMS Service have been used for the project. Details of the members such as their mobile phone numbers will be saved in a google spreadsheet and it will be connected through wso2/gsheets4 package. SMS notifications will be sent through twilio sms service and it will be connected through wso2/twilio package.

### Architecture

![Sample googlsheet created to keep trach of product downloads by customers](images/high_architecture.jpg)

### Google sheet

![Sample googlsheet created to keep trach of product downloads by customers](images/gsheet.png)

## Implementation

### Package structure


```
paymentNotifier
  ├── ballerina.conf  
  └── paymentNotifier
      └── gsheetHandler.bal
      └── payment-notify.bal
      └── paymentDetailsReciever.bal
      └── smsHandler.bal
  └── tests    
```

1. gsheetHandler.bal : handles the communication between application and the google sheets service.
2. payment-notify.bal : contain all the business logic. It connects to the smsHandler and gsheetHandler to access services.
3. paymentDetailsReciever.bal : this service handles incoming requests that contain payment data and write to google sheet.
4. smsHandler.bal : handles the communication between application and the twilio sms service.


## Prerequisites

   - [Ballerina Distribution](https://ballerinalang.org/docs/quick-tour/quick-tour/#install-ballerina)
   - Credetials and tokens for both Google Sheets and Twilio APIs.
   
   
## Running the application

1. First download the project and navigate into the project folder. Then intialize the project using following command.
```
    ballerina init
```
2. Then you need to add relevant credentials into the ballerina.conf file.

   For twilio,
```
            accountSId = ""
            authToken = ""  
```
   For Google sheet,
```
            ACCESS_TOKEN = ""
            CLIENT_ID = ""
            CLIENT_SECRET = ""
            REFRESH_TOKEN = ""
            SPREADSHEET = ""
```



3. Running the server.
```
    ballerina run paymentNotifier
```

4. Sending payment details to the server.

```
    curl -d "member_id" -X POST localhost:9092/memberPaid
```
