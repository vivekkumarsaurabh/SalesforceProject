trigger TriggerAHJ on AHJ__c (after update) {
    TriggerHandler handler = new TriggerHandler();
     if(Trigger.isAfter && Trigger.isUpdate){
        handler.afterUpdateHandler();
    }
   
}