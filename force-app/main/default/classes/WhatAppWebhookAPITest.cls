/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 06/05/2024
* @Description : Test Class of WhatAppWebhookAPI.
******************************************************************/
@isTest
public class WhatAppWebhookAPITest {
    /**************************************************************************************************************************
	* @description : This method is test setup method.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @testSetup
    static void createWhatsAppContact(){
        WhatsApp_Contact__c createUser =  DataFactory.createWhatsAppUser();
        Database.insert(createUser, false);
        WhatsApp_Message__c createMsg = DataFactory.createWhatsAppMsg();
        Database.insert(createMsg, false);
    }
    
    /**************************************************************************************************************************
	* @description : This method is for get Method.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void getData(){        
        String getBody = '{"hub" :{"verify_token", "WHATSAPPTOKEN"}}';
        RestContext.request =  ReturnRestContextFramework.returnRestReq('/whatsapp/webhooks/v1/', 'GET', getBody);
        Test.startTest();
        String getResponse = WhatsAppWebhookAPI.doGet();
        Test.stopTest();
    }
    
    /**************************************************************************************************************************
	* @description : This method is for post Data Msg
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void postDataUpdateMsg(){
        String bodyRes = '{"object": "whatsapp_business_account","entry": [{"id": "309222345601612","changes": [{"value": {"messaging_product": "whatsapp","metadata": {"display_phone_number": "15556154904","phone_number_id": "319481387908362"},"statuses":[{"id": "wamid.HBgMOTE4MjUyMjk1OTE5FQIAERgSMEQ2OUE1OTEzNDVCQTA3ODJEAA==","status": "read","timestamp": "1714484859","recipient_id": "918252295919"}]},"field": "messages"}]}]}';
        RestContext.request =  ReturnRestContextFramework.returnRestReq('/whatsapp/webhooks/v1/', 'POST', bodyRes); 
        Test.startTest();
        List<WhatsApp_Message__c> msgList = [SELECT Id, Name, Send__c, BusinessPhoneNumber__c, MessageContent__c, CustomerPhone__c, WhatsApp_Contact__c, CreatedDate FROM WhatsApp_Message__c WHERE CustomerPhone__c = '918252295919' ORDER BY CreatedDate DESC LIMIT 1];
        System.debug('dataa===>'+msgList);
        String postResponseUpdate = WhatsAppWebhookAPI.doPost();
        Test.stopTest();            
        System.assert(postResponseUpdate != null);
    }
    
    /**************************************************************************************************************************
	* @description : This method is post data.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void postData(){       
        String body = '{"object": "whatsapp_business_account","entry": [{"id": "309222345601612","changes": [{"value": {"messaging_product": "whatsapp","metadata": {"display_phone_number": "15556154904","phone_number_id": "319481387908362"},"contacts": [{"profile": {"name": "Tech Brothers"},"wa_id": "918252295919"}],"messages": [{"from": "918252295919","id": "wamid.HBgMOTE4MjUyMjk1OTE5FQIAEhggQjIyOENCOEZFNjIxNzJFQURGNEEzMzZEQjY0QjlGNjEA","timestamp": "1714486484","text":{"body": "Hiiiii"},"type": "text"}]},"field": "messages"}]}]}';
        RestContext.request =  ReturnRestContextFramework.returnRestReq('/whatsapp/webhooks/v1/', 'POST', body);         
        Test.startTest();
        String postResponse = WhatsAppWebhookAPI.doPost();
        Test.stopTest();        
        System.assert(postResponse != null);        
    }
    
    @isTest
    static void postDataNeg(){
        String body = '{"object": "whatsapp_business_account","entry": [{"id": "309222345601612","changes": [{"value": {"messaging_product": "whatsapp","metadata": {"display_phone_number": "15556154904","phone_number_id": "319481387908362"},"contacts": [{"profile": {"name": "Tech Brothers"},"wa_id": "918252295919"}],"messages": [{"from": "918252295919","id": "","timestamp": "1714486484","text":{"body": "Hiiiii"},"type": "text"}]},"field": "messages"}]}]}';
        RestContext.request =  ReturnRestContextFramework.returnRestReq('/whatsapp/webhooks/v1/', 'POST', body);         
        Test.startTest();
        String postResponse = WhatsAppWebhookAPI.doPost();
        Test.stopTest();        
    }
    
}