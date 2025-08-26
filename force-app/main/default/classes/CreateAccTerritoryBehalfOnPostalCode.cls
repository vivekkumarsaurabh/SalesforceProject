/******************************************************************
    * @author      : Vivek Kumar Saurabh
    * @date        : 23/11/2023
    * @Description : Class to create Account Territory behalf of Territory Mapping Postal Code and Business Segment with Batch Apex.
******************************************************************/
public class CreateAccTerritoryBehalfOnPostalCode implements Database.Batchable<sObject>, Database.stateful{  
    
    public List<Account> listOfAcc = [SELECT Id, ShippingPostalCode, Business_Segment__c FROM Account WHERE ShippingPostalCode != NULL AND Business_Segment__c != NULL]; //Account Record List
    
    /**************************************************************************************************************************
    * @description : This method is start method use for filter active Effective Period and return Territory Mapping List .
    * @param : database.BatchableContext.
    * @return : List<Territory_Mapping__c>.
	***************************************************************************************************************************/
    public Database.QueryLocator start(Database.BatchableContext batchContext){
        List<String> EffePeriodList = new List<String>();
        for(Effective_Period__mdt effecPeriodRec : [SELECT MasterLabel FROM Effective_Period__mdt WHERE Active__c = true]){
            EffePeriodList.add(effecPeriodRec.MasterLabel);
        }
        String territoryMapRec = 'SELECT Id, Territory_Mapping__c.Catelog__r.Id, Business_Segment__c, Effective_Period__c, Postal_Code__c  FROM Territory_Mapping__c WHERE Effective_Period__c IN : EffePeriodList AND Territory_Mapping__c.Catelog__r.Id != NULL AND Business_Segment__c != NULL AND Effective_Period__c != NULL AND Postal_Code__c != NULL';
        return Database.getQueryLocator(territoryMapRec);
    }
    
    /**************************************************************************************************************************
    * @description : This method is execute method use for create Territory Mapping .
    * @param : Database.BatchableContext, List<Territory_Mapping__c>.
    * @return : N/A.
	***************************************************************************************************************************/
    public void execute(Database.BatchableContext batchContext, List<Territory_Mapping__c> territoryMapList){    
        List<Account_Territory__c> accTerritoryList = new List<Account_Territory__c>();     
        for(Territory_Mapping__c iterateTerritoryMap : territoryMapList){
            List<String> postalCodeList = iterateTerritoryMap.Postal_Code__c.split(',');
            for(Account iterateAcc : listOfAcc){
                if(postalCodeList.contains(iterateAcc.ShippingPostalCode) && iterateTerritoryMap.Business_Segment__c == iterateAcc.Business_Segment__c){                
                     Account_Territory__c createRec = new Account_Territory__c(Account__c = iterateAcc.Id, Catelog__c = iterateTerritoryMap.Catelog__c, Effective_Period__c = iterateTerritoryMap.Effective_Period__c, 	Active__c = true);
                     accTerritoryList.add(createRec);
                }
            }
        }
        try { 
            if(accTerritoryList != NULL){
            insert accTerritoryList;
        }
       } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
      }       
    }
    
    /**************************************************************************************************************************
    * @description : This method is finish method used to know about our Batch execution are finish.
    * @param : Database.BatchableContext.
    * @return : N/A.
	***************************************************************************************************************************/
    public void finish(Database.BatchableContext b){
        System.debug('Finish Job');
    }
    
}