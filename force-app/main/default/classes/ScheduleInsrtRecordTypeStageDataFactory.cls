@isTest
public class ScheduleInsrtRecordTypeStageDataFactory {
    
    public static Class__c insertClass(String Name){
        Class__c createClassRec = new Class__c(Name = Name );
        return createClassRec;
    }
    
    public static Schedule__c insertSchedule(String Name, Id idOfClass, Id RecordTypeId){
        Schedule__c createScheduleRec = new Schedule__c(Name = Name, Class__c = idOfClass, RecordTypeId = RecordTypeId);
        return createScheduleRec;
    }
    
    public static Lead_file__c insertLeadFile(String Name, Id idOfClass, String stageFieldName){
     Lead_file__c createLeadFile = new Lead_file__c(Name = Name, Class__c = idOfClass, Stage__c = stageFieldName);
        return createLeadFile;
    }
    
    public static Schedule_class__c scheduleClassInsert(String Name, Id idOfLeadFile, Id idOfSchedule){
        Schedule_class__c createScheduleClassRec = new Schedule_class__c(Name = Name, Lead_file__c = idOfLeadFile, Schedule__c = idOfSchedule);
        return createScheduleClassRec;
    }
}