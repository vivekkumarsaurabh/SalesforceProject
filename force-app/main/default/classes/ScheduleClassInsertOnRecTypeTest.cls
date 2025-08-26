@isTest
private class ScheduleClassInsertOnRecTypeTest { 
    
    public static  Id OnBoardRecordTypeID = Schema.getGlobalDescribe().get('Schedule__c').getDescribe().getRecordTypeInfosByName().get('On Boarding').getRecordTypeId();
    public static  Id OffBoardRecordTypeID = Schema.getGlobalDescribe().get('Schedule__c').getDescribe().getRecordTypeInfosByName().get('Off Boarding').getRecordTypeId();
  	
    @testSetup
    static void createRecord(){
        Class__c classRec = DataFactory.returnClassRec('NewClass');
        Database.insert(classRec, false);
    }
    
    @isTest 
    static void checkResultDataforPosTest(){
        Test.startTest();
        List<Class__c> clsRecord = [SELECT Id FROM Class__c WHERE Name = 'NewClass' Limit 1];
        Schedule__c scheduleRec = DataFactory.returnScheduleRec('ScheduleNew', clsRecord[0].Id, OffBoardRecordTypeID);
        Database.insert(scheduleRec, false);
        Lead_file__c leadFileRec = DataFactory.returnLeadFile('LeadFile', clsRecord[0].Id, 'complete');
        Database.insert(leadFileRec, false); 
        
        Schedule__c scheduleRecOther = DataFactory.returnScheduleRec('ScheduleNew1', clsRecord[0].Id, OnBoardRecordTypeID);
        Database.insert(scheduleRecOther, false);
        Lead_file__c leadFileRecOther = DataFactory.returnLeadFile('LeadFile1', clsRecord[0].Id, 'In Progress');
        Database.insert(leadFileRecOther, false); 
        ScheduleClassInsertOnRecodTypeStage obj = new ScheduleClassInsertOnRecodTypeStage();
        Database.executeBatch(obj); 
        Test.stopTest();
        List<Schedule_class__c> listRecods = [SELECT Id FROM Schedule_class__c];       
        System.assertEquals(1, listRecods.size()); //positive testing
        
    }
    
    @isTest 
    static void checkResultDataforNegTest(){
        Test.startTest();
       	List<Class__c> clsRecord = [SELECT Id FROM Class__c WHERE Name = 'NewClass' Limit 1];
        Schedule__c scheduleRec0 = DataFactory.returnScheduleRec('ScheduleNew0', clsRecord[0].Id, OnBoardRecordTypeID);
        Database.insert(scheduleRec0, false);
        Lead_file__c leadFileRec0 = DataFactory.returnLeadFile('LeadFile0', clsRecord[0].Id, 'complete');
        Database.insert(leadFileRec0, false);
        ScheduleClassInsertOnRecodTypeStage obj = new ScheduleClassInsertOnRecodTypeStage();
        Database.executeBatch(obj);    
        Test.stopTest();
        List<Schedule_class__c> listRecods = [SELECT Id FROM Schedule_class__c]; 
        System.assertEquals(0, listRecods.size()); //negative testing
    }
    
    
}