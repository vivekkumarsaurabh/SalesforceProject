public class ScheduleClassInsertOnRecodTypeStage implements Database.Batchable<sObject>, Database.Stateful{ 
    public Map<Id, List<Lead_file__c>> mapOfLeadfile = new Map<Id, List<Lead_file__c>>();     
        public Database.QueryLocator start(Database.BatchableContext bc){
        String queryOfSchedule = 'SELECT Id, RecordType.Name, Schedule__c.Class__r.Id FROM Schedule__c';  
        for(Lead_file__c iterateLeadFileRec : [SELECT Id, Stage__c, Class__c FROM Lead_file__c WHERE Class__c != NULL]){             
            List<Lead_file__c> listOfLeadFile = new List<Lead_file__c>();
            if(mapOfLeadfile.containsKey(iterateLeadFileRec.Class__c)){
                listOfLeadFile = mapOfLeadfile.get(iterateLeadFileRec.Class__c);
            }	
            listOfLeadFile.add(iterateLeadFileRec);
            mapOfLeadfile.put(iterateLeadFileRec.Class__c, listOfLeadFile);                    
        }
        return Database.getQueryLocator(queryOfSchedule);     
    }
    
    public void execute(Database.BatchableContext b, List<Schedule__c> listOfScheduleObj){       
        List<Schedule_class__c> listOfScheduleClasRec = new List<Schedule_class__c>();            
        for(Schedule__c iterateRec  : listOfScheduleObj){         
            if(mapOfLeadfile.containsKey(iterateRec.Class__c)){                
                List<Lead_file__c> listOfLeadfile = mapOfLeadfile.get(iterateRec.Class__c);
                for(Lead_file__c iterateLeadfile : listOfLeadfile){
                     Schedule_class__c  createSchedulClass = new Schedule_class__c();
                  if((iterateRec.RecordType.Name == 'On Boarding' && iterateLeadfile.Stage__c == 'In Progress') || (iterateRec.RecordType.Name == 'Off Boarding' && iterateLeadfile.Stage__c == 'complete')){
                        createSchedulClass.Name = 'Schedule-'+iterateRec.RecordType.Name+'-'+iterateLeadfile.Stage__c;
                        createSchedulClass.Lead_file__c = iterateLeadfile.Id;
                        createSchedulClass.Schedule__c = iterateRec.Id;
                        listOfScheduleClasRec.add(createSchedulClass);
                    }
                }            
            } 
        }
        if(!listOfScheduleClasRec.isEmpty()){
             insert listOfScheduleClasRec;
        }
      
    }
    
    public static void finish(Database.BatchableContext b){
        System.debug('Fisnish Task');
    }
}