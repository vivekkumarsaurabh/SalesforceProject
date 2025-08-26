/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 01/12/2023
* @Description : Class of Integration for  Create Account Record in Targated Org On Trigger after Insert.
******************************************************************/
public class IntegrationTargetOrgTriggerHelper {
    
    /**************************************************************************************************************************
	* @description : This method is for fill the Wrapper and run Our request method.
	* @param : List<Account>.
	* @return : N/A.
	***************************************************************************************************************************/    
    public static void afterInsertRecord(List<Account> newAccList){             
        String newListStr = JSON.serialize(newAccList);
		String jsonStr = newListStr.replace('Email_External_Id__c', 'EmailExId');
        List<WrapperAccount> deserializeData = (List<WrapperAccount>)JSON.deserialize(jsonStr, List<WrapperAccount>.class);
        targetOrgInsertRecord(JSON.serialize(deserializeData));
    }
    
     /**************************************************************************************************************************
	* @description : This method is for insert record into targed Org.
	* @param : JsonString.
	* @return : N/A.
	***************************************************************************************************************************/
    @future(callout = true)
    public static void targetOrgInsertRecord(String jsonString){      
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        httpReq.setEndpoint('callout:CredentialFirst/services/apexrest/TargetOrg');    
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type','application/json');
        httpReq.setHeader('accepted','application/json');
        httpReq.setBody(jsonString); 
        httpRes = http.send(httpReq);
        System.debug('httpRes ==>> ' +httpRes);
        System.debug('httpResBosy ==>> ' +httpReq.getBody());
    }
    
    public class WrapperAccount{
        public String Name;
        public String Rating;
        public String EmailExId;
        
    }
    
}