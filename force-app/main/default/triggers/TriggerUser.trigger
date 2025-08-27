trigger TriggerUser on User (after update) {
//TriggerHandler handler  = new TriggerHandler();
    if(Trigger.isAfter && Trigger.isUpdate){
        System.debug('Trigger.New----->'+Trigger.New);
      //  handler.afterUpdateHandler();
      ObjectHistoryTracking.trackObjectHistory();

    }        
}