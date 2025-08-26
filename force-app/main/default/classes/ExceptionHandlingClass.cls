/**
@description : This class is used to capture the error logs record in salesforce .
@author : Vivek Kumar Saurabh
@cerated date : 27th May 2024
@modified by : Vivek Kumar Saurabh
@modified date : 27th May 2024
*/

public class ExceptionHandlingClass {
    /** 
    * @description : Method is used to create exception logs records in salesforce for errorHandling.
    * @param : String ClassName, String methodName, String errorMessage, String stackTrace.
    * @return : NA
    */ 
    public static void exceptionLogRecords(String className, String methodName, String errorMsg, String stackTrace, Integer lineNumber){
        try{
            Exception_Logs__c debugLogs = new Exception_Logs__c();
            debugLogs.Class_Name__c = className;
            debugLogs.Method_Name__c = methodName;
            debugLogs.Error_Message__c = errorMsg;
            debugLogs.Stack_Trace__c = stackTrace;
            debugLogs.Line_Number__c = lineNumber;
            if(debugLogs != null){
                insert debugLogs;
            }
        }
        catch(dmlException ex){
            system.debug('===ex==='+ex);
        }
    }
    
    /** 
    * @description : Method is used insert Http Log for errorHandling.
    * @param : String getResponseBody, String requestBody - Contains getResponseBody and requestBody.
    * @return : NA
    */ 
    public static void calloutExceptionLogRecordCreation(String getResponseBody, String requestBody, String status, String recordId){
        Http_Log__c httpLogRecord = new Http_Log__c();
        if(!String.isBlank(getResponseBody) && !String.isBlank(requestBody)){
            httpLogRecord.Status__c = status ;
            httpLogRecord.Response__c = getResponseBody;
            httpLogRecord.Request__c = requestBody;
            httpLogRecord.Record_Id__c = recordId ;

        }
        if(httpLogRecord != null){
            insert httpLogRecord;
        }
    }
}