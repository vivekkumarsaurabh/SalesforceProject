trigger TriggerBook on Book__c (before insert, after Update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        ObjectHistoryTracking.trackObjectHistory();
        //handler.afterUpdateHandler();
    }
}