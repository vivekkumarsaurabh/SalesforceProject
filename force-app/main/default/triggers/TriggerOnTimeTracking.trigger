trigger TriggerOnTimeTracking on Time_Tracking__c (before insert, after insert, before update) {
 /**  if(Trigger.isBefore && Trigger.isInsert){
       // CreateUpdateRecordAccodinHours.insertRecordsOnTimeTracking(Trigger.new);
         CreateUpdateRecordAccodinHours.updateRecordsOnTimeTracking(Trigger.new, Trigger.oldMap);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        CreateUpdateRecordAccodinHours.updateRecordsOnTimeTracking(Trigger.new, Trigger.oldMap);
    }**/
    
}