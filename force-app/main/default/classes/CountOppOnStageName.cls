public class CountOppOnStageName {
    public static void countOppOnStage(){
        Map<Id, Map<String, Integer>> mapOfAccIdWithOpp = new Map<Id, Map<String, Integer>>();
        for(Opportunity iterateOpp :[SELECT AccountId, StageName FROM Opportunity WHERE AccountId != NULL AND StageName != NULL]){
            Map<String, Integer> mapOfstageNameCountOpp = new Map<String, Integer>(); 
            Integer count = 0; 
            if(mapOfAccIdWithOpp.containsKey(iterateOpp.AccountId)){                
                 mapOfstageNameCountOpp = mapOfAccIdWithOpp.get(iterateOpp.AccountId);
                if(mapOfstageNameCountOpp.containsKey(iterateOpp.StageName)){
                    count = mapOfstageNameCountOpp.get(iterateOpp.StageName);
                }
            }
            mapOfstageNameCountOpp.put(iterateOpp.StageName, count+1); 
            mapOfAccIdWithOpp.put(iterateOpp.AccountId, mapOfstageNameCountOpp);            
            System.debug(' map ===>'+mapOfAccIdWithOpp);
        }
         System.debug('mapOfAccIdWithOpp====>'+mapOfAccIdWithOpp);
      /**  for(Id key : mapOfAccIdWithOpp.keySet()){
            System.debug(key+'===>'+mapOfAccIdWithOpp.get(key));
        }**/
   
    }
}