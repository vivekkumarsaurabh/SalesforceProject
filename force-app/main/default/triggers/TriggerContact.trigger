trigger TriggerContact on Contact (Before insert,Before Update,After Update, After Delete, After Insert) {
 /**   if(Trigger.isBefore && Trigger.isInsert){
        PrimaryContactInsertIfAccHaveNoPmryCon.primaryContactInsert(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){        
        PrimaryContactInsertIfAccHaveNoPmryCon.primaryContactUpdateMethod(Trigger.new);          
    }
    if(Trigger.isAfter && Trigger.isDelete){
        PrimaryContactInsertIfAccHaveNoPmryCon.primaryContactDeleteMethod(Trigger.old);
    }**/
    /**  if(Trigger.isBefore && Trigger.isInsert){
// AssignAddressContactTriggerHelper.beforeInsertUpdateAssignAddress(Trigger.new);

}
if(Trigger.isBefore && Trigger.isUpdate){
//AssignAddressContactTriggerHelper.beforeInsertUpdateAssignAddress(Trigger.new);

}**/
    
    /**   if(Trigger.isBefore && Trigger.isInsert){      
AssignAddressContactTriggerHelper.beforeInsertAreaCodeInPhone(Trigger.new);
}
if(Trigger.isBefore && Trigger.isUpdate){
AssignAddressContactTriggerHelper.beforeInsertAreaCodeInPhone(Trigger.new);        
}**/
    
    /**  if(Trigger.isBefore && Trigger.isInsert){
AssignAddressContactTriggerHelper.beforeInsertUpdateTotalAmtDsc(Trigger.new);        
}
if(Trigger.isBefore && Trigger.isUpdate){
AssignAddressContactTriggerHelper.beforeInsertUpdateTotalAmtDsc(Trigger.new);        
}**/    
       
    
     if(Trigger.isAfter && Trigger.isUpdate){
      //  handler.afterUpdateHandler();
      ObjectHistoryTracking.trackObjectHistory();

    } 
    
}