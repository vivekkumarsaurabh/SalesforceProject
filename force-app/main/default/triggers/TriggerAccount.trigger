trigger TriggerAccount on Account (after update, after insert, before insert, before update ,after delete,before delete, After Undelete) {

      
  /** if(trigger.isAfter && trigger.isInsert){
        System.debug('---isAfter isInsert operationType---- '+trigger.operationType);
        system.debug('---isAfter isInsert Trigger.new---- '+trigger.new); 
        system.debug('---isAfter isInsert newMap---- '+trigger.newMap);
        system.debug('---isAfter isInsert old---- '+trigger.old);
        system.debug('---isAfter isInsert oldMap---- '+trigger.oldMap);
    }if(trigger.isBefore && trigger.isInsert){
        System.debug('---isBefore isInsert operationType---- '+trigger.operationType);
        system.debug('---isBefore isInsert Trigger.new---- '+trigger.new); 
        system.debug('---isBefore isInsert newMap---- '+trigger.newMap);
        system.debug('---isBefore isInsert old---- '+trigger.old);
        system.debug('---isBefore isInsert oldMap---- '+trigger.oldMap);
    }if(trigger.isAfter && trigger.isUpdate){
        System.debug('---isAfter isUpdate operationType---- '+trigger.operationType);
        system.debug('---isAfter isUpdate Trigger.new---- '+trigger.new); 
        system.debug('---isAfter isUpdate newMap---- '+trigger.newMap);
        system.debug('---isAfter isUpdate old---- '+trigger.old);
        system.debug('---isAfter isUpdate oldMap---- '+trigger.oldMap); 
    }if(trigger.isBefore && trigger.isUpdate){
        System.debug('---isBefore isUpdate operationType---- '+trigger.operationType);
        system.debug('---isBefore isUpdate Trigger.new---- '+trigger.new); 
        system.debug('---isBefore isUpdate newMap---- '+trigger.newMap);
        system.debug('---isBefore isUpdate old---- '+trigger.old);
        system.debug('---isBefore isUpdate oldMap---- '+trigger.oldMap);
        System.debug('---isBefore isUpdate Size---- '+trigger.Size);        
    }if(trigger.isAfter && trigger.isDelete){
        System.debug('---isAfter isDelete operationType---- '+trigger.operationType);
        system.debug('---isAfter isDelete Trigger.new---- '+trigger.new); 
        system.debug('---isAfter isDelete newMap---- '+trigger.newMap);
        system.debug('---isAfter isDelete old---- '+trigger.old);
        system.debug('---isAfter isDelete oldMap---- '+trigger.oldMap);        
    }if(trigger.isBefore && trigger.isDelete){
        System.debug('---isBefore isDelete operationType---- '+trigger.operationType);
        system.debug('---isBefore isDelete Trigger.new---- '+trigger.new); 
        system.debug('---isBefore isDelete newMap---- '+trigger.newMap);
        system.debug('---isBefore isDelete old---- '+trigger.old);
        system.debug('---isBefore isDelete oldMap---- '+trigger.oldMap);
    }if(trigger.isAfter && trigger.isUndelete){
        System.debug('---isAfter isUndelete operationType---- '+trigger.operationType);
        system.debug('---isAfter isDelete Trigger.new---- '+trigger.new); 
        system.debug('---isAfter isDelete newMap---- '+trigger.newMap);
        system.debug('---isAfter isDelete old---- '+trigger.old);
        system.debug('---isAfter isDelete oldMap---- '+trigger.oldMap);
    }**/
    
     /**  for (Account a : Trigger.new) {
           System.debug(a);
        
    }
     Contact[] cons = [SELECT LastName FROM Contact WHERE AccountId IN :Trigger.new];
    System.debug(cons);**/
    
    /**if(Trigger.isAfter && Trigger.isInsert){
        for(Account acc: Trigger.new){
            System.debug('Account Id =>'+acc.Id);
            System.debug('Account Id'+acc.Name);
        } 
     }**/
    
    // if(Trigger.isAfter && Trigger.isUpdate){
    //     for(Account acc: Trigger.New){
    //         System.debug('Account Details :=> '+Trigger.newMap.get(acc.id).Name);
    //         // Map<Id,Account> v1 = Trigger.oldMap;
    //         // System.debug('Account Old Details : ==>'+v1);
    //         System.debug('Account Old Details==>'+Trigger.oldMap.get(acc.id).Name);
    //     }
    // }

  /**  if(Trigger.isAfter && Trigger.isUpdate){
        FillBillAddOfConReWIthAccAfterUpdate.fillBillAddOfcon(Trigger.new);
    }**/
   
  /**  if(Trigger.isBefore && Trigger.isInsert){
        AssignManagerZoneOnCity.beforeInsertUpdateAssignManager(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        AssignManagerZoneOnCity.beforeInsertUpdateAssignManager(Trigger.new);
    }**/
    
 /**   if(Trigger.isAfter && Trigger.isInsert){
        CreateCSVfileOnInsertAcc.createCSVfileInsertAfterInsert(Trigger.new);        
    }
     if(Trigger.isAfter && Trigger.isUpdate){
        CreateCSVfileOnInsertAcc.updateCSVfileAfterUpdate(Trigger.new);
    }**/
    
    /*if(Trigger.isAfter && Trigger.isInsert){
        IntegrationTargetOrgTriggerHelper.afterInsertRecord(Trigger.new);      
    }  
    if(Trigger.isBefore && Trigger.isDelete){
        IntegrationOrgTrigerHlperOnDelete.afterDeleteRecord(Trigger.old);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        IntgrationOrgTriggerHlprOnUpdate.afterUpdateRecord(Trigger.new);
        IntgrationOrgTriggerOnUpsert.afterUpdateRecordUpsert(Trigger.new);
    }*/
    
   /*** if(Trigger.isBefore && Trigger.isDelete){
        TriggerOnAccHaveOpp.deleteAccHandler(Trigger.oldMap);
    }**/
    
    
   // TriggerHandler handler = new TriggerHandler();
     if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)){
        ObjectHistoryTracking.trackObjectHistory();
        //handler.afterUpdateHandler();
    }
   
    
}