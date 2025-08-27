trigger TriggerOnTask on Task (before insert, after insert, after update) {
   /** if((Trigger.isAfter && Trigger.isUpdate) || (Trigger.isAfter && Trigger.isInsert)){
       SendEmailToAssignQueueFromTask.sendMailToQueue(Trigger.New);
    }**/
     if(Trigger.isAfter && Trigger.isUpdate){
        ObjectHistoryTracking.trackObjectHistory();
        //handler.afterUpdateHandler();
    }
}