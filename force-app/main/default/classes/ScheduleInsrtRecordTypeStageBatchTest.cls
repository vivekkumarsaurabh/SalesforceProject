@isTest
public class ScheduleInsrtRecordTypeStageBatchTest {
    @isTest static void ScheduleInsrtRecordTypeBatchTest(){
        Test.startTest();
        Class__c  creteateClassRec = ScheduleInsrtRecordTypeStageDataFactory.insertClass('New Class 2');
        insert creteateClassRec;       
        Schedule__c createSchedule = ScheduleInsrtRecordTypeStageDataFactory.insertSchedule('Schedule 2', creteateClassRec.Id, '01I5j000002KRGI');
        insert createSchedule;
        Lead_file__c createLeadFile = ScheduleInsrtRecordTypeStageDataFactory.insertLeadFile('Lead File 2', creteateClassRec.Id, 'Complete'); 
        insert createLeadFile;
       ScheduleClassInsertOnRecodTypeStage obj = new ScheduleClassInsertOnRecodTypeStage();
       Database.executeBatch(obj);
                
        Test.stopTest();
    }
}