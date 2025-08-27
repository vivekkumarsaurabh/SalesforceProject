trigger PopulateSalesTaxOnProduct on Product__c (Before insert) {
 
  /**  if(Trigger.isBefore &&  Trigger.isInsert){
            PopulateSalesTaxBehalfOfProduct.populateSalesTaxes(Trigger.New);
        //System.debug(Trigger.New.get(0).Sales_Tax__c);
    }**/
}