/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 30/11/2023
* @Description : Class of Integration for test method .
******************************************************************/
public class CreateInntegrationExample {
    
    /**************************************************************************************************************************
	* @description : This method is get Data from Targeted Org.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    public static void getDataIntegrate(){
        HttpRequest feedRequest = new HttpRequest();
        String query = 'SELECT+Id,Name,+Rating+FROM+Account';
        feedRequest.setEndpoint('callout:CredentialFirst/services/data/v58.0/query?q='+ query);
        feedRequest.setMethod('GET');
        Http http = new Http();
        HTTPResponse feedResponse = http.send(feedRequest);        
        System.debug('Body  => '+(feedResponse.getBody()));
        System.debug('feedResponse  => '+feedResponse);        
    }
    
      /**************************************************************************************************************************
	* @description : This method is get Details from Targeted Org.
	* @param : recordId, ObjectName.
	* @return : N/A.
	***************************************************************************************************************************/
    public static void getDetails(String recId, String objectName){
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        httpReq.setMethod('GET');
        httpReq.setEndpoint('callout:CredentialFirst/services/data/v36.0/sobjects/'+objectName+'/' +recId);
        httpRes = http.send(httpReq);
        String str = JSON.serializePretty(httpRes.getBody());
        System.debug(str);
        System.debug(httpRes);
    }
    
     /**************************************************************************************************************************
	* @description : This method is post record in Targeted Org.(Insert Record)
	* @param : objectName.
	* @return : N/A.
	***************************************************************************************************************************/
    public static void postRecord(String objectName){
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();        
        httpReq.setEndpoint('callout:CreadencialAjay/services/data/v58.0/sobjects/'+objectName+'/');        
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type','application/Json');
        httpReq.setHeader('accepted','application/Json');
        String body = '{"Name" : "Account from Vivek","phone" : "1111111111"}';        
        httpReq.setBody(body); 
        httpRes = http.send(httpReq);
        System.debug(httpRes);
        System.debug(httpRes.getBody());       
    }
    
   /**************************************************************************************************************************
	* @description : This method is patch record in Targeted Org.(Upsert Record)
	* @param : recordId, objectName.
	* @return : N/A.
	***************************************************************************************************************************/
    public static void patchAccRec(String recId, String objName){
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        httpReq.setEndPoint('callout:CredentialFirst/services/data/v58.0/sobjects/'+objName+'/'+recId);
        httpReq.setMethod('PATCH');
        httpReq.setHeader('Content-Type','application/Json');
        httpReq.setHeader('accepted','application/Json');
        String body = '{"Name" : "Account Updated","phone" : "1111111111"}';        
        httpReq.setBody(body); 
        httpRes = http.send(httpReq);
        System.debug(httpRes);
        System.debug(httpRes.getBody()); 
    }
    
    /**************************************************************************************************************************
	* @description : This method is delete record in Targeted Org.(delete Record)
	* @param : objectName, recordId.
	* @return : N/A.
	***************************************************************************************************************************/
    public static void deleteAccRec(String recId, String objName){
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        httpReq.setEndPoint('callout:CredentialFirst/services/data/v58.0/sobjects/'+objName+'/'+recId);
        httpReq.setMethod('DELETE');
        httpRes = http.send(httpReq);
        System.debug(httpRes);
        System.debug(httpRes.getBody()); 
    }
    
      /**************************************************************************************************************************
	* @description : This method is insert in other Org.
	* @param : objectName, recordId.
	* @return : N/A.
	***************************************************************************************************************************/
    @future(callout=true)
    public static void postRecordBulk(){
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        httpReq.setEndpoint('callout:CredentialFirst/services/apexrest/TargetOrg');    
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type','application/json');
        httpReq.setHeader('accepted','application/json');
        httpReq.setBody(JSON.serialize(CreateWrapperClassOnAccContact.returnAccWrapper())); 
        httpRes = new http().send(httpReq);
        System.debug(httpRes);
    }
}