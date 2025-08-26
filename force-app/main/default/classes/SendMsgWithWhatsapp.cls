/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 26/04/2024
* @Description : Integration with WhatsApp;
******************************************************************/
public with sharing class SendMsgWithWhatsapp {
    /**************************************************************************************************************************
* @description : This method is for send msg to the whatsApp through API.
* @param : String phoneNumberId, String phoneNumber, String msgToSend.
* @return : N/A.
***************************************************************************************************************************/
    @AuraEnabled
    public static WhatsApp_Message__c sendMessage(String phoneNumberId, String phoneNumber, String msgToSend, Boolean sendMsg, String replyMsgId){        
        Id contactId = WhatsAppWebhookAPI.returnWhatsAppContactHandler(phoneNumber);
        String version = 'v19.0';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://graph.facebook.com/'+ Version + '/' + phoneNumberId + '/messages');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer '+System.Label.WHATSAPPSECRET);
        request.setHeader('Content-Type', 'application/json');
        String body;
        //String body = '{"messaging_product": "whatsapp","to": "'+phoneNumber+'","type":"template","template": {"name":"testing_template","language": {"code": "en"}}}';
        if(String.isNotBlank(replyMsgId) && replyMsgId != NULL && replyMsgId.length() != 0){
            System.debug('comming...');
            body ='{"messaging_product": "whatsapp","context": {"message_id": "'+replyMsgId+'"},"to": "'+phoneNumber+'","type":"text","text": {"preview_url": false,"body": "'+msgToSend+'"}}'; 
        }else{
            System.debug('not comming...');
            body ='{"messaging_product": "whatsapp","to": "'+phoneNumber+'","type":"text","text": {"preview_url": false,"body": "'+msgToSend+'"}}'; 
        }
        System.debug('body====>'+body);
       // String body = '{"messaging_product": "whatsapp","context": {"message_id": "wamid.HBgMOTE4MjUyMjk1OTE5FQIAEhgWM0VCMDk0OTZGMzk0MEE0MDVBMjk3NgA="},"to": "'+phoneNumber+'","type":"text","text": {"preview_url": false,"body": "'+msgToSend+'"}}';    
       // String body = '{"to": "'+phoneNumber+'","type": "template","template": {"namespace":"26fc6b7f_70ce_4ff5_bcdf_46523e8126ff","name":"testing_template","language": {"code": "en_US","policy":"deterministic"},"components":[{"type":"button","sub_type":"quick_reply","index":"0","parameters":[{"type":"payload","payload":"aGlzIHRoaXMgaXMgY29vZHNhc2phZHdpcXdlMGZoIGFTIEZISUQgV1FEV0RT"}]},{"type":"button","sub_type":"url","index":"1","parameters":[{"type":"text","text":"9rwnB8RbYmPF5t2Mn09x4h"}]}]}}';           
        request.setBody(body);    
        HttpResponse response = http.send(request);
        System.debug('response===>'+response);
        WhatsApp_Message__c msg = new WhatsApp_Message__c();
        if(response.getStatusCode() == 200){           
            msg = createWhatsAppMsg(contactId, phoneNumber, msgToSend, sendMsg, replyMsgId);
        }        
        return msg;    
    }
    
    /**************************************************************************************************************************
* @description : This method is for create Msg.
* @param : N/A.
* @return : List<MsgList>.
***************************************************************************************************************************/
    public static WhatsApp_Message__c createWhatsAppMsg(String contactId, String phoneNumber, String msgToSend, Boolean sendMsg, String replyMsgId){
        WhatsApp_Message__c replyMsg = new WhatsApp_Message__c();
        if(String.isNotBlank(replyMsgId) && replyMsgId != NULL && replyMsgId.length() != 0){
          replyMsg = [SELECT BusinessPhoneNumber__c, MessageContent__c FROM WhatsApp_Message__c WHERE MessageId__c = :replyMsgId LIMIT 1];
        }
        WhatsApp_Message__c salesforceMessage = new WhatsApp_Message__c();
         salesforceMessage.WhatsApp_Contact__c = contactId;
         salesforceMessage.Send__c = sendMsg;
         salesforceMessage.CustomerPhone__c = phoneNumber;
         salesforceMessage.MessageContent__c = msgToSend;
         salesforceMessage.ReplyMsgId__c = replyMsgId;
         salesforceMessage.ReplyMsg__c = replyMsg.MessageContent__c;
         if(sendMsg){
          salesforceMessage.ReplyLabel__c = 'You';  
         }else{
          salesforceMessage.ReplyLabel__c = replyMsg.BusinessPhoneNumber__c; 
         }          
         salesforceMessage.BusinessPhoneNumber__c = '15556154904';  
         insert salesforceMessage;
         return salesforceMessage;
    }
    
    
    /**************************************************************************************************************************
* @description : This method is for retrive user data.
* @param : N/A.
* @return : List<MsgList>.
***************************************************************************************************************************/
    @AuraEnabled
    public static List<MsgList> retriveUserHandler(){
        List<MsgList> userList = new List<MsgList>();
        for(WhatsApp_Contact__c iterateContact : [SELECT Id, Name, Phone__c, (SELECT Id, MessageContent__c, CreatedDate FROM WhatsApp_Messages__r ORDER BY CreatedDate DESC LIMIT 1) FROM WhatsApp_Contact__c]){
            MsgList createWrapper = new MsgList();
            createWrapper.id = iterateContact.Id;
            createWrapper.name = iterateContact.Name;
            createWrapper.phone = iterateContact.Phone__c;
            if(!iterateContact.WhatsApp_Messages__r.isEmpty()){
                createWrapper.msg = String.valueOf(iterateContact.WhatsApp_Messages__r[0].get('MessageContent__c'));
                Datetime msgD = Datetime.valueOf(iterateContact.WhatsApp_Messages__r[0].get('CreatedDate'));
                createWrapper.dt = msgD;
                String msgDt = msgD.format();                 
                createWrapper.msgDate = msgDt.substringBefore(',');
            }
            userList.add(createWrapper);
        }     
        return userList;
    }  
    
    /**************************************************************************************************************************
* @description : This method is for return MsgWrapper Map behalf on date.
* @param : String userId.
* @return : Map<String, List<MsgWrapper>>.
***************************************************************************************************************************/
    @AuraEnabled
    public static Map<String, List<MsgWrapper>> returnMap(String userId){    
        Map<String, List<MsgWrapper>> WrapperMap = new Map<String, List<MsgWrapper>>();       
        for(WhatsApp_Message__c iterateRec : [SELECT Id, Send__c, MessageId__c, ReplyLabel__c, ReplyMsg__c, ReplyMsgId__c, MessageContent__c, CustomerPhone__c, WhatsApp_Contact__c, status__c, CreatedDate FROM WhatsApp_Message__c WHERE WhatsApp_Contact__c = :userId ORDER BY CreatedDate ASC]){            
            String msgTime = iterateRec.CreatedDate.format();
            List<String> dt = String.valueOf(System.today()).split(' ');
            List<String> d = dt[0].split('-');
            String todayDate = d[2]+'/'+d[1]+'/'+d[0]+'-'+String.valueOf(iterateRec.WhatsApp_Contact__c);  
            String key = msgTime.substringBefore(',')+'-'+String.valueOf(iterateRec.WhatsApp_Contact__c);         
            if(key == todayDate){
                key = 'TODAY-'+String.valueOf(iterateRec.WhatsApp_Contact__c);  
            }
            List<MsgWrapper> msgWrpList = new List<MsgWrapper>();
            if(WrapperMap.containsKey(key)){
                msgWrpList = WrapperMap.get(key);
            }
            MsgWrapper createWrp = new MsgWrapper();
            createWrp.msg = iterateRec.MessageContent__c;            
            createWrp.msgTime =  msgTime.substringAfter(',');
            if(iterateRec.Send__c){
                createWrp.sent = 'message sent';
            }else{
                createWrp.sent = 'message received'; 
            }
            if(iterateRec.status__c == 'read'){
                createWrp.showTick = true;
                createWrp.status = 'readMsg';
            }else if(iterateRec.status__c == 'delivered'){
                createWrp.showTick = true;
                createWrp.status = 'deliveredMsg';
            }else if(iterateRec.status__c == 'sent'){
                createWrp.showTick = false;
                createWrp.status = 'sentMsg';
            }
            createWrp.receiver = iterateRec.Send__c;
            createWrp.recUserId = iterateRec.WhatsApp_Contact__c;
            createWrp.msgId = iterateRec.Id;
            createWrp.replyMsgId = iterateRec.ReplyMsgId__c;
            createWrp.replyLabel = iterateRec.ReplyLabel__c;
            createWrp.replyMsg = iterateRec.ReplyMsg__c;
            createWrp.messageId = iterateRec.MessageId__c;
            msgWrpList.add(createWrp);                   
            if(key == todayDate){
                key = 'TODAY-'+String.valueOf(iterateRec.WhatsApp_Contact__c);  
            }
            WrapperMap.put(key, msgWrpList);
        }   
        return WrapperMap;
    }
    
    /**************************************************************************************************************************
* @description : This method is for return Message.
* @param : String userId.
* @return : List<MsgUser>.
***************************************************************************************************************************/
    @AuraEnabled
    public static List<MsgUser> returnMessages(String userId){
        List<MsgUser> msgUserList = new List<MsgUser>();
        Map<String, List<MsgWrapper>> msgMap = returnMap(userId);
        System.debug('data====.'+msgMap);
        for(String iterateKey : msgMap.keySet()){
            MsgUser createWrapper = new MsgUser();
            createWrapper.msgList =  msgMap.get(iterateKey);
            List<String> dtList = iterateKey.split('-');
            createWrapper.dt = iterateKey;
            createWrapper.key = dtList[0];
            msgUserList.add(createWrapper); 
        }
        return  msgUserList;
    }  
    
    /**************************************************************************************************************************
* @description : This method is for create User.
* @param : String name, String phone.
* @return : WhatsApp_Contact__c.
***************************************************************************************************************************/
    @AuraEnabled
    public static WhatsApp_Contact__c userCreateHandler(String name, String phone){
        WhatsApp_Contact__c createuser = new WhatsApp_Contact__c();
        createuser.Name = name;
        createuser.Phone__c = '91'+phone;
        insert createuser;
        return createuser;
    }
    
    /**************************************************************************************************************************
* @description : This method is for delete Msg.
* @param : String msgId.
* @return : N/A.
***************************************************************************************************************************/
    @AuraEnabled
    public static WhatsApp_Message__c deleteMsg(String msgId){
        WhatsApp_Message__c msg = [SELECT Id FROM WhatsApp_Message__c WHERE Id = :msgId];
        delete msg;
        return msg;
    }
    
    /**************************************************************************************************************************
* @description : This method is trigger method for publish platform event.
* @param : List<WhatsApp_Message__c> msgList.
* @return : N/A.
***************************************************************************************************************************/
    public static List<WhatsAppMessage__e> insertMsgTriggerHandler(List<WhatsApp_Message__c> msgList){
        List<WhatsAppMessage__e> events = new List<WhatsAppMessage__e>();
        for(WhatsApp_Message__c iterateRec : msgList){
            WhatsAppMessage__e eventIns = new WhatsAppMessage__e();
            eventIns.RecordId__c = iterateRec.Id;  
            eventIns.msg__c = iterateRec.MessageContent__c;
            eventIns.SenderId__c = iterateRec.WhatsApp_Contact__c;
            eventIns.MsgSentTime__c = iterateRec.CreatedDate.format();
            if(iterateRec.Send__c){
                eventIns.MsgClass__c = 'message sent';
            }else{
                eventIns.MsgClass__c = 'message received';
            }            
            if(iterateRec.status__c == 'read'){
                eventIns.sent__c = true;
                eventIns.delivered__c = 'readMsg';
            }else if(iterateRec.status__c == 'delivered'){
                eventIns.sent__c = true;
                eventIns.delivered__c = 'deliveredMsg';
            }else if(iterateRec.status__c == 'sent'){
                eventIns.sent__c = false;
                eventIns.delivered__c = 'sentMsg';
            }else{
                eventIns.sent__c = false;
                eventIns.delivered__c = 'deliveredMsg';
            }
            eventIns.ReplyId__c = iterateRec.ReplyMsgId__c;
            eventIns.ReplyMsg__c = iterateRec.ReplyMsg__c;
            eventIns.ReplyLabel__c = iterateRec.ReplyLabel__c;
            eventIns.messageId__c = iterateRec.MessageId__c;
            eventIns.SentMsg__c = iterateRec.Send__c;
            events.add(eventIns);
        }    
        if(!events.isEmpty()) {         
            EventBus.publish(events);
        }
        return events;
    }
    
    public class MsgUser{    
        @AuraEnabled public String key;
        @AuraEnabled public String dt;
        @AuraEnabled public List<MsgWrapper> msgList;        
    }
    
    public class MsgList{
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String msg;
        @AuraEnabled public String phone;  
        @AuraEnabled public Datetime dt;
        @AuraEnabled public String msgDate;
    }
    
    public class MsgWrapper{
        @AuraEnabled public String msg;
        @AuraEnabled public String msgTime; 
        @AuraEnabled public Boolean receiver;
        @AuraEnabled public String sent;
        @AuraEnabled public String recUserId;
        @AuraEnabled public String msgId;
        @AuraEnabled public String messageId;
        @AuraEnabled public String replyMsgId;
        @AuraEnabled public String status;
        @AuraEnabled public String replyMsg;
        @AuraEnabled public String replyLabel;
        @AuraEnabled public Boolean showTick;
    }
}