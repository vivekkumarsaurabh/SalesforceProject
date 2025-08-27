trigger TriggerEvent on Event (before insert, after Update) {
 if(Trigger.isAfter && Trigger.isUpdate){
        ObjectHistoryTracking.trackObjectHistory();
        //handler.afterUpdateHandler();
    }
}