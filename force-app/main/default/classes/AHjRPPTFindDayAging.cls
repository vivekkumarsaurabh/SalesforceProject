public class AHjRPPTFindDayAging implements Database.Batchable<sObject>, Database.stateful{
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT PT__c.RP__r.AHJ__r.Id, Name, Start_Date__c, End_Date__c FROM PT__c WHERE PT__c.RP__r.Id!= NULL AND PT__c.RP__r.AHJ__r.Id != NULL';
        return  Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext b, List<PT__c> ptRecords){
        Map<Id, List<Integer>> mapOfAhjListOfpt = new Map<Id, List<Integer>>();    
        List<AHJ__c> listOfAhjupdate = new List<AHJ__c>(); 
        for(PT__c iteratePt :ptRecords){
            List<Integer> listOfPt = new List<Integer>();
            if(mapOfAhjListOfpt.containsKey(iteratePt.RP__r.AHJ__r.Id)){
                listOfPt = mapOfAhjListOfpt.get(iteratePt.RP__r.AHJ__r.Id);
            }
            listOfPt.add(iteratePt.Start_Date__c.daysBetween(iteratePt.End_Date__c));
            listOfPt.sort();
            mapOfAhjListOfpt.put(iteratePt.RP__r.AHJ__r.Id, listOfPt);   
        }
        for(Id iterateAhjKey : mapOfAhjListOfpt.keySet()){  
            Integer differenceDay = 0;   
            List<Integer> listOfPt = mapOfAhjListOfpt.get(iterateAhjKey);
            if(listOfPt.size() > 5){
                listOfPt.remove(listOfPt.size() - (listOfPt.size() * 20) / 100);
            }
            for(Integer iterateDiffDay : listOfPt){
                differenceDay += iterateDiffDay;
            }
            AHJ__c updateAhjRec = new AHJ__c(Id = iterateAhjKey, Day_Aging__c = differenceDay / listOfPt.size());
            listOfAhjupdate.add(updateAhjRec);
        }  
        update listOfAhjupdate;
    }
    
    public static void finish(Database.BatchableContext b){
        System.debug('Finish Job');
    }
    
}