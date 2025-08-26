public class AssignManagerZoneOnCity {
    public static void beforeInsertUpdateAssignManager(List<Account> newAccList){
        Map<String, Account_Manager__mdt> storeMdtData = new Map<String, Account_Manager__mdt>();
        for(Account_Manager__mdt  iterateData : [SELECT MasterLabel, Sales_Manager__c, 	Zone__c FROM Account_Manager__mdt]){
            storeMdtData.put(iterateData.MasterLabel, iterateData);
        }
            for(Account iterateAccRec : newAccList){
                if(storeMdtData.containsKey(iterateAccRec.City__c)){
                    iterateAccRec.Sales_Manager__c = storeMdtData.get(iterateAccRec.City__c).Sales_Manager__c;
                    iterateAccRec.Zone__c = storeMdtData.get(iterateAccRec.City__c).Zone__c;
                }
            }
    }    
}