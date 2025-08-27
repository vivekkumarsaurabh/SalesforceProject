trigger SalesOrderTrigger on Sales_Order__c (after insert, before update) {
    if(Trigger.isAfter && Trigger.isInsert){
       OverrideBtnHandler.updateQunatityProductMapHandler(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        OverrideBtnHandler.updateExitedSalesOrderHandler(Trigger.oldMap, Trigger.newMap);
    }
}