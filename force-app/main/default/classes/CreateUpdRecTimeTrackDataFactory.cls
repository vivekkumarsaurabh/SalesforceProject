@isTest
public class CreateUpdRecTimeTrackDataFactory {  
    public static List<Time_Tracking__c> inserRecord(Integer noOfRec, String name, Date dateOfTime, Integer hours){
        List<Time_Tracking__c> listOfTimeTrack = new List<Time_Tracking__c>();
        for(Integer i = 1; i <= noOfRec; i++){
            Time_Tracking__c createTimeTrack  = new Time_Tracking__c();
            createTimeTrack.Name = name;
            createTimeTrack.Date__c = dateOfTime; 
            createTimeTrack.Hours__c = hours;
            listOfTimeTrack.add(createTimeTrack);
        }
        return listOfTimeTrack;
    }
    
    public static List<Time_Tracking__c> updateRec(List<Time_Tracking__c> recordList, Date timeDate, Integer hour){
        List<Time_Tracking__c> listOfTimeTrack = new List<Time_Tracking__c>(); 
        for(Time_Tracking__c iterateRec : recordList){
            Time_Tracking__c updateTime = new Time_Tracking__c();
            updateTime.Name = iterateRec.Name;
            updateTime.Id = iterateRec.Id;
            updateTime.Date__c = timeDate;
            updateTime.Hours__c = hour;
            listOfTimeTrack.add(updateTime);           
        } 
        return listOfTimeTrack;
    }
}