trigger TriggerOnWhatAppMsg on WhatsApp_Message__c (after insert, after	update) {
   if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        system.debug('daaata==>'+Trigger.new);
        SendMsgWithWhatsapp.insertMsgTriggerHandler(Trigger.new);      
    }
}