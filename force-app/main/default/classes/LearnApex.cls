public class LearnApex {
    
    public static void  getAccContactOpportunity(){
        Map<Id, Map<Id, List<Opportunity>>> accountContactOpportunityListMap = new  Map<Id, Map<Id, List<Opportunity>>>();
        for(Opportunity iterateOpportunity :  [SELECT ID, AccountId, ContactId FROM Opportunity WHERE AccountId != NULL AND ContactId != NULL]){          
            if(accountContactOpportunityListMap.containsKey(iterateOpportunity.AccountId)){
                
            }
        }
    }
    
    public static void getAccountContact(){
        Map<Id, List<Id>> accountContactListMap = new  Map<Id, List<Id>>();
        for(Contact iterateContact : [SELECT Id, AccountId FROM Contact WHERE AccountId != NULL AND Id != NULL]){
            List<Id> contactList = new List<Id>();
            if(accountContactListMap.containsKey(iterateContact.AccountId)){
                contactList = accountContactListMap.get(iterateContact.AccountId);
            }
            contactList.add(iterateContact.Id);
            accountContactListMap.put(iterateContact.AccountId, contactList);
        }
        System.debug('accountContactListMap===>'+accountContactListMap);
    }
    
    public static void getMapOfMap(){
        Map<Id, Map<String, Integer>> accountIdStangeNameCountOfOppMap = new Map<Id, Map<String, Integer>>();
        for(AggregateResult iterateResult :  [SELECT AccountId, StageName, COUNT(Id) cnt FROM Opportunity GROUP BY StageName, AccountId Having AccountId != NULL AND StageName != NULL]){
            Integer count = 0;  
            Map<String, Integer> stageNameOppCount = new Map<String, Integer>();
            if(accountIdStangeNameCountOfOppMap.containsKey(String.valueOf(iterateResult.get('AccountId')))){
                stageNameOppCount =  accountIdStangeNameCountOfOppMap.get(String.valueOf(iterateResult.get('AccountId')));
                if(stageNameOppCount.containsKey(String.valueOf(iterateResult.get('StageName')))){
                    count = stageNameOppCount.get(String.valueOf(iterateResult.get('StageName')));
                }                
            }
            stageNameOppCount.put(String.valueOf(iterateResult.get('StageName')), count+1);
            accountIdStangeNameCountOfOppMap.put(String.valueOf(iterateResult.get('AccountId')), stageNameOppCount);          
            
        }
    }
}