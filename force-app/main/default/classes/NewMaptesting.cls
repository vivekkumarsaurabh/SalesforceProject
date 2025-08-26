public class NewMaptesting {
    public static void method(){
           Map<Id, List<PT__c>> mapOfAhjListOfpt = new Map<Id, List<PT__c>>();
            for(PT__c iteratePt :[SELECT PT__c.RP__r.AHJ__r.Id, Name, Start_Date__c, End_Date__c FROM PT__c ]){
            List<PT__c> listOfPt = new List<PT__c>();
            if(mapOfAhjListOfpt.containsKey(iteratePt.RP__r.AHJ__r.Id)){
                listOfPt = mapOfAhjListOfpt.get(iteratePt.RP__r.AHJ__r.Id);
            }
            listOfPt.add(iteratePt);
            mapOfAhjListOfpt.put(iteratePt.RP__r.AHJ__r.Id, listOfPt);   
        }
        
        for(Id key : mapOfAhjListOfpt.keySet()){
         System.debug(key+'===>'+mapOfAhjListOfpt.get(key));   
        }
    }
}