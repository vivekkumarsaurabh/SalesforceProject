trigger TriggerOnOpportunity on Opportunity (before insert,before update,before delete, after insert, after update, after delete, after undelete) {
    /** if(Trigger.isBefore && Trigger.isInsert){
CreateUpdateOpportOnStage.createOpporOnStage(Trigger.new);
}
if(Trigger.isBefore && Trigger.isUpdate){
CreateUpdateOpportOnStage.updateOpporOnStage(Trigger.new,Trigger.oldMap);
}**/
    
    // POC
    
    /** if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert || Trigger.isDelete)){
List<ObjectHistory__e> refreshRecordEventList = new List<ObjectHistory__e>();
ObjectHistory__e event = new ObjectHistory__e();
event.isShowTable__c = true;
refreshRecordEventList.add(event);
if(!refreshRecordEventList.isEmpty()) {   
EventBus.publish(refreshRecordEventList);
}
}

if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert || Trigger.isDelete || Trigger.isUndelete)){
List<ObjectHistory__e> refreshRecordEventList = new List<ObjectHistory__e>();
ObjectHistory__e event = new ObjectHistory__e();
event.isShowTable__c = true;
refreshRecordEventList.add(event);
if(!refreshRecordEventList.isEmpty()) {   
EventBus.publish(refreshRecordEventList);
}
}
**/
    
    if(Trigger.isBefore && Trigger.isInsert){
        //OpportunityInsertBehalfOnAmount.beforeInsertmethod(Trigger.New);
    }
    
  /**  if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)){
        if(!Trigger.New.isEmpty()){
            for(Opportunity iterateOrderRecord : Trigger.new){
                if(iterateOrderRecord.Amount == null && iterateOrderRecord.stageName == 'Prospecting'){
                    iterateOrderRecord.Amount  = 1000;
                }
            }
        }
    }**/
        
    if(Trigger.isAfter && Trigger.isUpdate){
        OpportunityScenarioHelper.releaseTCLicenseCheckOnOrder(Trigger.newMap, Trigger.oldMap);
    }
        
        
    }