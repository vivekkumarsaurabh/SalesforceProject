/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 26/04/2024
* @Description : Integration with WhatsApp RestResource Class;
******************************************************************/
@RestResource(urlMapping='/whatsapp/webhooks/v1/*')
global class WhatsAppWebhookAPI {
    
    private static Final String SIGNATURE_VALID_MESSAGE = 'Signature Verified';
    private static Final String SIGNATURE_NOT_VALID_MESSAGE = 'Signature could not be verified';
    
    /**************************************************************************************************************************
	* @description : This method is for get RestResponse.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @HttpGet
    global static String doGet(){
        RestResponse response = RestContext.response;
        RestRequest request = RestContext.request;
        System.debug('response========>'+response);
        System.debug('request =======>'+request);
        if(request.params.get('hub.verify_token') == 'WHATSAPPTOKEN'){
            response.responseBody = Blob.valueOf(request.params.get('hub.challenge'));
        }
        return String.valueOf(response);
    }    
    
    /**************************************************************************************************************************
	* @description : This method is post method.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @HttpPost
    global static String doPost() {
        RestResponse response = RestContext.response;
       // RestRequest request = RestContext.request;
        //String bod = request.requestBody.toString();
        //System.debug('request==Pos=>b'+bod);
       // response.addHeader('Content-type','application/json');
        String responseString = RestContext.request.requestBody.toString();
        Map<String, String> headers = RestContext.request.headers;
         String responseValid = validateWhatsAppSignature(RestContext.request, responseString);
        // if(responseValid == SIGNATURE_VALID_MESSAGE){
        System.debug(System.LoggingLevel.DEBUG, ' Headers Response From WhatsApp \n '+JSON.serialize(headers));
        System.debug(System.LoggingLevel.DEBUG, ' Response From WhatsApp \n '+responseString);
        String finalResponseString = responseString;//.replace('type', 'typex');       
        finalResponseString = finalResponseString.replace('from', 'fromNumber');
        if(finalResponseString.contains('statuses')){
           WhatsAppMessageGetStatus getStatuses = (WhatsAppMessageGetStatus)JSON.deserialize(finalResponseString, WhatsAppMessageGetStatus.class);
            System.debug('Get Statuses =====>'+getStatuses);
            List<WhatsAppMessageGetStatus.entry> messageEntries = getStatuses.entry;
            if(messageEntries != null && messageEntries.size() > 0){
                WhatsAppMessageGetStatus.entry entryMessage = messageEntries.get(0);
                List<WhatsAppMessageGetStatus.changes> changeMessages = entryMessage.changes;
                if(changeMessages != null && changeMessages.size() > 0){
                  WhatsAppMessageGetStatus.changes changeMessage = changeMessages.get(0);
                  List<WhatsAppMessageGetStatus.statuses> messagesStatuses = changeMessage.value.statuses;
                  WhatsAppMessageGetStatus.metadata metadata = changeMessage.value.metadata;
                    if(messagesStatuses != null && messagesStatuses.size() > 0){
                     WhatsAppMessageGetStatus.statuses status = messagesStatuses.get(0);  
                     updateWhatsAppContactMsgHandler(status.recipient_id, status.status, status.id);
                    }
                }
            }
            
        }else{
        WhatsAppMessage parentMessage = (WhatsAppMessage)JSON.deserialize(finalResponseString, WhatsAppMessage.class);
        System.debug(System.LoggingLevel.DEBUG, ' parentMessage---\n '+ parentMessage);
        List<WhatsAppMessage.entry> messageEntries = parentMessage.entry;
        if(messageEntries != null && messageEntries.size() > 0){            
            WhatsAppMessage.entry entryMessage = messageEntries.get(0);
            List<WhatsAppMessage.changes> changeMessages = entryMessage.changes;
            if(changeMessages != null && changeMessages.size() > 0){
                WhatsAppMessage.changes changeMessage = changeMessages.get(0);
                List<WhatsAppMessage.contacts> contactList = changeMessage.value.contacts;
                List<WhatsAppMessage.messages> messageList = changeMessage.value.messages;
                WhatsAppMessage.metadata metadata = changeMessage.value.metadata;
                // Create record
                WhatsApp_Message__c salesforceMessage = new WhatsApp_Message__c();
                salesforceMessage.BusinessPhoneNumber__c = metadata != null ? metadata.display_phone_number : null;
                if(contactList != null && contactList.size() > 0){                 
                    WhatsAppMessage.contacts contact = contactList.get(0);
                    Id whatsAppContactId =  returnWhatsAppContactHandler(String.valueOf(contact.wa_id));
                    System.debug('whatsAppContactId===>'+whatsAppContactId);
                    salesforceMessage.WhatsApp_Contact__c = whatsAppContactId;
                    salesforceMessage.CustomerPhone__c = contact.wa_id;
                    // salesforceMessage.CustomerName__c = contact.profile.name;
                }
                if(messageList != null && messageList.size() > 0){
                    // Simple Message
                    WhatsAppMessage.messages message = messageList.get(0);
                    System.debug(System.LoggingLevel.DEBUG, 'message---'+ message);
                    salesforceMessage.MessageID__c = message.id;
                    salesforceMessage.MessageType__c = message.type;
                    // System.debug(System.LoggingLevel.DEBUG, 'message.type'+message.type);
                     // salesforceMessage.MessageSentTime__c = String.valueOf(System.now());
                      String msg = (message?.button?.text != null) ? message?.button?.text : message?.text?.body;
                      System.debug('msg=====>'+msg);
                      salesforceMessage.MessageContent__c = msg;
                   if(message.context != null){
                        System.debug('context====>'+message.context);
                       salesforceMessage.ReplyMsgId__c =  message.context.id;
                     }
                     // salesforceMessage.ReplyMsgId__c = message.context.id != null?message.context.id : null;
                    if(message.context != NULL){    
                         WhatsApp_Message__c replyMsg = returnReplyMsg(message.context.id);
                         salesforceMessage.ReplyMsg__c = replyMsg.MessageContent__c;
                         if(message.context.fromNumber == '15556154904'){
                           salesforceMessage.ReplyLabel__c = 'You';  
                         }else{
                          salesforceMessage.ReplyLabel__c = replyMsg.WhatsApp_Contact__r.Name;   
                         }                         
                     }
                     if(message.type == 'text'){
                        salesforceMessage.MessageContent__c = message.text != null?message.text.body : null;
                    }
                    /**else if(message.type == 'button'){
                        salesforceMessage.MessageContent__c = message.button.text;
                        System.debug(System.LoggingLevel.DEBUG,'salesforceMessage.MessageContent__c'+ salesforceMessage.MessageContent__c);
                    }**/
                    /* If message is reaction */
                     //salesforceMessage.Reaction__c = message.reaction != null ?message.reaction.emoji : null;
                     //salesforceMessage.ParentMessageID__c = message.reaction != null ?message.reaction.message_id : null;
                    /* If message is Image */
                     //  salesforceMessage.ImageID__c = message.image != null ?message.image.id : null;
                     // salesforceMessage.ImageType__c = message.image != null ?message.image.mime_type : null;
                    // salesforceMessage.ImageSHA256__c = message.image != null ?message.image.sha256 : null;
                    /* If message is Video */
                     //salesforceMessage.VideoId__c = message.video != null ?message.video.id : null;
                     //salesforceMessage.VideoType__c = message.video != null ?message.video.mime_type : null;
                     //salesforceMessage.VideoSHA256__c = message.video != null ?message.video.sha256 : null;
                    /* If message is Document */
                    /* If the message is reply to another message */
                    // salesforceMessage.ParentMessageID__c = message.context != null ?message.context.id : null;
                    System.debug('obj=====>'+salesforceMessage);
                    try{
                        upsert salesforceMessage MessageID__c;
                    }
                    catch(Exception exp){
                        System.debug('error-->'+exp);
                    }                    
                }
            }
          }           
       }
       return responseString;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for upsert whatsapp Msg for update msg Status.
	* @param : String phoneNumber, String stats, String msgId.
	* @return : N/A.
	***************************************************************************************************************************/
    public static void updateWhatsAppContactMsgHandler(String phoneNumber, String stats, String msgId){
        WhatsApp_Message__c msg = [SELECT Id, Name, Send__c, BusinessPhoneNumber__c, MessageContent__c, CustomerPhone__c, WhatsApp_Contact__c, CreatedDate FROM WhatsApp_Message__c WHERE CustomerPhone__c = :phoneNumber ORDER BY CreatedDate DESC LIMIT 1];
        WhatsApp_Message__c updateMsg = new WhatsApp_Message__c();
        updateMsg.Id = msg.Id;
        updateMsg.status__c = stats;
        updateMsg.MessageId__c = msgId;
        upsert updateMsg;
    }
    
    /**************************************************************************************************************************
	* @description : This method is return WhatsApp Contact.
	* @param : String name, String email.
	* @return : List<AlgoTyping_User__c>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Id returnWhatsAppContactHandler(String phone){
        return [SELECT ID FROM WhatsApp_Contact__c WHERE Phone__c = :phone LIMIT 1].ID;
    }
    
    @AuraEnabled 
    public static WhatsApp_Message__c returnReplyMsg(String replyId){ 
        WhatsApp_Message__c replyMsg = new WhatsApp_Message__c();
        if(String.isNotBlank(replyId) && replyId != NULL && replyId.length() != 0){
          replyMsg = [SELECT BusinessPhoneNumber__c, MessageContent__c, WhatsApp_Contact__r.Name FROM WhatsApp_Message__c WHERE MessageId__c = :replyId LIMIT 1];
        }
        return replyMsg;
    }    
    
    /**************************************************************************************************************************
	* @description : This method is validate WhatsApp Signature.
	* @param : RestRequest request, String responseString.
	* @return : String .
	***************************************************************************************************************************/
    private static String validateWhatsAppSignature(RestRequest request, String responseString)
    {
        // Validate Stripe signature Start
        Map<String, String> headers = request.headers;
        String whatsAppSignature = headers.get('X-Hub-Signature-256');
        String whatsAppPayload = RestContext.request.requestBody.toString();
        // Verify the signature using 'hmacSHA256'. I have the Webhook key stored in a Custom Label
        String whatsAppSecret = System.Label.WHATSAPPSECRET; // Facebook Application Secret Key
        Blob signedPayload = Crypto.generateMac('hmacSHA256', Blob.valueOf(whatsAppPayload),Blob.valueOf( whatsAppSecret ));
        String encodedPayload = 'sha256='+EncodingUtil.convertToHex(signedPayload);
        //Return status code based on whether signed payload matches or not
        String response = (encodedPayload == whatsAppSignature)? SIGNATURE_VALID_MESSAGE : SIGNATURE_NOT_VALID_MESSAGE;
        return response;
        // Validate Stripe signature End
    }


}