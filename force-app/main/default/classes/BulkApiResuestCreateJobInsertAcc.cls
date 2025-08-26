/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 06/12/2023
* @Description : Class of Bulk Api Create Job and Insert Account Record in Target Org.
******************************************************************/
public class BulkApiResuestCreateJobInsertAcc {
    
    /**************************************************************************************************************************
	* @description : This method is for Create Job.
	* @param : String operation, String objectName, String contentType, String lineEnding.
	* @return : String JobId.
	***************************************************************************************************************************/     
    public static String createJob(String operation, String objectName, String contentType, String lineEnding){
        HttpResponse response = new HttpResponse();
        HttpRequest request = new HttpRequest();        
        Http http = new Http();        
        String body = '{"operation":"'+operation+'","object":"'+objectName+'","contentType":"'+contentType+'","lineEnding":"'+lineEnding+'"}';
        String endPoint = 'callout:CredentialFirst/services/data/v59.0/jobs/ingest';
        request = CreateHttpResuest.returnHttpRequest(endPoint, 'POST', 'Content-Type', 'application/json', body);       
        response = http.send(request);
        System.debug('Response createJob==>> ' +response);
        System.debug('ResponseBody CreateJob====>'+response.getBody());
        Map<String, object> jsonMap = (Map<String, object>)Json.deserializeUntyped(String.valueOf(response.getBody()));
        String jobId = String.valueOf(jsonMap.get('id'));
        System.debug('jobId==>'+jobId);
        return jobId;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for Put Upload Job.
	* @param : String operation, String objectName, String contentType, String lineEnding.
	* @return : N/A.
	***************************************************************************************************************************/  
    
    public static void putUploadJob(String operation, String objectName, String contentType, String lineEnding, String contentVerData){
        HttpResponse response = new HttpResponse();
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        String jobId = createJob(operation, objectName, contentType, lineEnding);  
        //ContentVersion contentVersionData = contentVerData;         
        String bodyPart = contentVerData;
        //String body = '"Name"\n"Account Test ONE"\n"Account Test TWO"';
        String endPoint = 'callout:CredentialFirst/services/data/v59.0/jobs/ingest/'+jobId+'/batches';
        request = CreateHttpResuest.returnHttpRequest(endPoint, 'PUT', 'Content-Type', 'text/csv', bodyPart);       
        response = http.send(request);
        System.debug('Response putUploadJob===>'+response);
        System.debug('ResponseBody putUploadBody==>'+response.getBody());
        patchAbortJob(jobId);
    }
    
    /**************************************************************************************************************************
	* @description : This method is for Patch Abort Job.
	* @param : String JobId.
	* @return : N/A.
	***************************************************************************************************************************/
    @future(callout = true)
    public static void patchAbortJob(String jobId){
        HttpResponse response = new HttpResponse();
        HttpRequest request = new HttpRequest();
        Http http = new Http();        
        String body = '{"state":"UploadComplete"}';
        String endPoint = 'callout:CredentialFirst/services/data/v59.0/jobs/ingest/'+jobId;  
        request = CreateHttpResuest.returnHttpRequest(endPoint, 'PATCH', 'Content-Type', 'application/json', body); 
        response = http.send(request);
        System.debug('Response patchUploadJob===>'+response);
        System.debug('Response Body patchUploadJob==>'+response.getBody());
    }
    

    
}