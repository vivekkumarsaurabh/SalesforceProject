public class CreateUpdateRecordAccodinHours {    
    public static void  updateRecordsOnTimeTracking(List<Time_Tracking__c> newTimeTrackRecordList, Map<Id, Time_Tracking__c> oldTimeTrackRecordMap){
        Map<Date, Double> mapOfdateHours = new Map<Date, Double>();        
        for(Time_Tracking__c iteratingRecords : [SELECT Date__c, Hours__c FROM Time_Tracking__c WHERE Date__c != NULL AND Hours__c != NULL]){              
            Double totalHours = 0;            
            if(mapOfdateHours.containsKey(iteratingRecords.Date__c)){
                totalHours = mapOfdateHours.get(iteratingRecords.Date__c);               
            }
            mapOfdateHours.put(iteratingRecords.Date__c, iteratingRecords.Hours__c + totalHours);            
        }        
        for(Time_Tracking__c iterateTimeTraking : newTimeTrackRecordList){
            if(iterateTimeTraking.Hours__c > 24){
                iterateTimeTraking.Hours__c.addError('On this date hour limit is more than 24');
            }
            if(mapOfdateHours.containsKey(iterateTimeTraking.Date__c)){
                Double totalHoursAll = iterateTimeTraking.Hours__c + mapOfdateHours.get(iterateTimeTraking.Date__c);              
                if(iterateTimeTraking.Id != null){
                    if(oldTimeTrackRecordMap != null && iterateTimeTraking.Date__c == oldTimeTrackRecordMap.get(iterateTimeTraking.Id).Date__c){                        
                            totalHoursAll = totalHoursAll - oldTimeTrackRecordMap.get(iterateTimeTraking.Id).Hours__c;                     
                    }
                }               
                if(totalHoursAll>24){
                    iterateTimeTraking.Hours__c.addError('On this date hour limit is more than 24');
                }
            }
        }   
    }
    
}