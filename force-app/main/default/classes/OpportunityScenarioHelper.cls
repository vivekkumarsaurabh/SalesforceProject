public class OpportunityScenarioHelper {
    
    public static void releaseTCLicenseCheckOnOrder(Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap){
        List<Id> accountIds = new List<Id>();
        for(Id opportunityId : oldMap.KeySet()){
             System.debug('TL_Hold_Status oldStatus--->'+oldMap.get(opportunityId).TL_Hold_status__c);
			 System.debug('TL_Hold_Status newStatus--->'+newMap.get(opportunityId).TL_Hold_status__c);
            if(oldMap.get(opportunityId).TL_Hold_status__c != newMap.get(opportunityId).TL_Hold_status__c && newMap.get(opportunityId).TL_Hold_status__c =='Passed'){
                accountIds.add(newMap.get(opportunityId).AccountId);
            }
        }
        for(Account accountRecord : [SELECT Id, TL_Line_Level_Hold_Status__c FROM Account WHERE Id = :accountIds]){
           System.debug('TL_Line_Level_Hold_Status__c==>'+accountRecord.TL_Line_Level_Hold_Status__c);
            if(accountRecord.TL_Line_Level_Hold_Status__c == 0){
                System.debug('Inner Condition...');
            }
        }        
    }
    
}