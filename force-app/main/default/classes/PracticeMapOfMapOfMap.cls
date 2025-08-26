/**


public class PracticeMapOfMapOfMap {

    public static void methdOfAccountWithContactWithStageOfCountOpportunity(){
        
        Map<Id,Map<Id,Map<String,Integer>>> MapOfAcWthConWthStageOfCountOpportunity =new Map<Id,Map<Id,Map<String,Integer>>>();
        
        for(Opportunity oppor:[SELECT id, AccountId, ContactId, StageName  FROM Opportunity WHERE AccountId!=NULL AND ContactId!=NULL AND StageName!=NULL]){
                 Integer Count=0;
                Map<Id,Map<String,Integer>> mapOfContactIdofStageCount= new  Map<Id,Map<String,Integer>>(); 
                Map<String,Integer> mapOfCountOfStage =new Map<String,Integer>();
                 if(MapOfAcWthConWthStageOfCountOpportunity.containsKey(oppor.AccountId)){
                     mapOfContactIdofStageCount=MapOfAcWthConWthStageOfCountOpportunity.get(oppor.AccountId);
                     if(mapOfContactIdofStageCount.containsKey(oppor.ContactId)){
                         mapOfCountOfStage=mapOfContactIdofStageCount.get(oppor.ContactId);
                         if(mapOfCountOfStage.containsKey(oppor.StageName)){
                             Count=mapOfCountOfStage.get(oppor.StageName);
                              mapOfCountOfStage.put(oppor.StageName,Count+1);
                         }else{
                               mapOfCountOfStage.put(oppor.StageName,1);
                         }
                          
                       mapOfContactIdofStageCount.put(oppor.ContactId,mapOfCountOfStage);
                         
                     }else{
                         mapOfContactIdofStageCount.put(oppor.ContactId,mapOfCountOfStage);
                     }
                        
                    }else{
                        mapOfCountOfStage.put(oppor.StageName,Count+1);
                        mapOfContactIdofStageCount.put(oppor.ContactId,mapOfCountOfStage);                        
                        MapOfAcWthConWthStageOfCountOpportunity.put(oppor.AccountId,mapOfContactIdofStageCount);
                    }
            
        
               }
        
        for(Id Key : MapOfAcWthConWthStageOfCountOpportunity.keySet()){
            System.debug(key+'----->'+MapOfAcWthConWthStageOfCountOpportunity.get(Key));
        }
           }
    
}
 * **/


public class PracticeMapOfMapOfMap {

    public static void methdOfAccountWithContactWithStageOfCountOpportunity(){
        
        Map<Id,Map<Id,Map<String,Double>>> MapOfAcWthConWthStageOfCountOpportunity =new Map<Id,Map<Id,Map<String,Double>>>();
        
        for(Opportunity oppor:[SELECT id, AccountId, ContactId, StageName,Amount  FROM Opportunity WHERE AccountId!=NULL AND ContactId!=NULL AND Amount!=NULL AND StageName='Closed Won']){
                 Double Count=oppor.Amount;
                Map<Id,Map<String,Double>> mapOfContactIdofStageCount= new  Map<Id,Map<String,Double>>(); 
                Map<String,Double> mapOfCountOfStage =new Map<String,Double>();
                 if(MapOfAcWthConWthStageOfCountOpportunity.containsKey(oppor.AccountId)){
                     mapOfContactIdofStageCount=MapOfAcWthConWthStageOfCountOpportunity.get(oppor.AccountId);
                     if(mapOfContactIdofStageCount.containsKey(oppor.ContactId)){
                         mapOfCountOfStage=mapOfContactIdofStageCount.get(oppor.ContactId);
                         if(mapOfCountOfStage.containsKey(oppor.StageName)){
                             Count+=mapOfCountOfStage.get(oppor.StageName);                           
                         }
                            mapOfCountOfStage.put(oppor.StageName,Count);                 
                      }
                        mapOfContactIdofStageCount.put(oppor.ContactId,mapOfCountOfStage);
                    }
                        mapOfCountOfStage.put(oppor.StageName,Count);
                        mapOfContactIdofStageCount.put(oppor.ContactId,mapOfCountOfStage);                        
                        MapOfAcWthConWthStageOfCountOpportunity.put(oppor.AccountId,mapOfContactIdofStageCount);
                            
        
               }
        
        for(Id Key : MapOfAcWthConWthStageOfCountOpportunity.keySet()){
            System.debug(key+'----->'+MapOfAcWthConWthStageOfCountOpportunity.get(Key));
        }
           }
    
}