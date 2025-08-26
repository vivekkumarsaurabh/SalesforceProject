/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 06/05/2024
* @Description : Test Class of sendMsgWithWhatsapp (Integration with whatsApp).
******************************************************************/
@isTest
public class sendMsgWithWhatsappTest implements HttpCalloutMock{
     
      /**************************************************************************************************************************
	* @description : This method is check status code.
	* @param : HTTPRequest req.
	* @return : HttpResponse.
	***************************************************************************************************************************/
        public HTTPResponse respond (HTTPRequest req) {    
        HttpResponse res = new HttpResponse();
        res.setHeader('Authorization', 'Bearer '+System.Label.WHATSAPPSECRET);
        res.setHeader('Content-Type', 'application/json');
        String body = '{"messaging_product": "whatsapp","to": "918252295919","type":"text","text": {"preview_url": false,"body": "Hi Test"}}';    
        res.setStatusCode(200);
        return res;
    } 
    
    /**************************************************************************************************************************
	* @description : This method is test setup method.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @testSetup
    static void setupMethod(){
      WhatsApp_Contact__c createUser =  DataFactory.createWhatsAppUser();
      Database.insert(createUser, false);
      WhatsApp_Message__c createMsg = DataFactory.createWhatsAppMsg();
      Database.insert(createMsg, false); 
    }
    
    /**************************************************************************************************************************
	* @description : This method is test method.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void executeTestMethods(){
        Test.startTest();              
        Test.setMock(HttpCalloutMock.class, new sendMsgWithWhatsappTest()); 
        WhatsApp_Message__c msgSend = SendMsgWithWhatsapp.sendMessage('319481387908362', '918252295919', 'Hii Testing', true);
        WhatsApp_Contact__c user = [SELECT ID FROM WhatsApp_Contact__c WHERE ID = :msgSend.WhatsApp_Contact__c];
        WhatsApp_Message__c msgReceive = SendMsgWithWhatsapp.createWhatsAppMsg(String.valueOf(user.Id), '918252295919', 'Hii Testing', false);
        List<Object> userMsg = SendMsgWithWhatsapp.retriveUserHandler();  
        WhatsApp_Contact__c createUser = SendMsgWithWhatsapp.userCreateHandler('Test Uset 2', '8252295919');        
        Map<String, List<Object>> userDataMap = SendMsgWithWhatsapp.returnMap(user.Id);
        List<Object> retrnMsgList = SendMsgWithWhatsapp.returnMessages(user.Id);         
        WhatsApp_Message__c deleteMsg = SendMsgWithWhatsapp.deleteMsg(msgSend.Id);        
        Test.stopTest();
        
        System.assert(msgSend != null);
        System.assert(user != null);
        System.assert(createUser != null);
        System.assert(userMsg != null);
        System.assert(userDataMap != null);
        System.assert(retrnMsgList != null);        
        System.assert(deleteMsg != null);
        System.assert(msgReceive != null);
        
    } 
}