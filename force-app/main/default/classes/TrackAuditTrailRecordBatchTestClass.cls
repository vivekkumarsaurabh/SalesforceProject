/*
* @Description : this class is test class of TrackAuditTrailRecordsBatch where testing different positive scenario and negative scenario.
* @Author      : Vivek Kumar Saurabh
* @Created Date: 04/06/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 05/06/2024
*/
@isTest
private class TrackAuditTrailRecordBatchTestClass {    
    /*
	* @description : This method is create permission set in database to change our setupAuditTrail then we track SetupAuditTrail Records.
	* @param : N/A.
	* @return : N/A.
	*/   
     @isTest(SeeAllData=true)
     static void testSetupMethod(){
        PermissionSet createPermisionSetRecord = TestDataFactory.createPermissionSetInstance('test_permission_set_5', 'Test Permission Set', 'This is used for Test purposes'); // You can't use DataFactory name for testRecord Creation.
        if(createPermisionSetRecord != NULL){
        Database.insert(createPermisionSetRecord, false); // Don't make any DML without null check
        }
    }
    
    /*
	* @description : This method is used for positive test cases.
	* @param : N/A.
	* @return : N/A.
    */
    @isTest
    static void testPositiveCases(){  
       Test.startTest();  
       TrackAuditTrailRecordsBatch batch = new TrackAuditTrailRecordsBatch();
       Database.executeBatch(batch, 500);
       Test.stopTest();
       List<Object_sHistory__c> newObjectHistoryRecordList = [SELECT Id, New_Value__c  From Object_sHistory__c  WHERE New_Value__c LIKE '%permission set%' AND Id != NULL ORDER BY CreatedDate DESC LIMIT 1];
       Assert.areEqual(newObjectHistoryRecordList.size(), 1, 'Testing positive cases'); 
    }
    
    /*
	* @description : This method is used for negative Test cases.
	* @param : N/A.
	* @return : N/A.
    */
    @isTest
    static void testNegativeCases(){  
       Test.startTest();  
       TrackAuditTrailRecordsBatch batch = new TrackAuditTrailRecordsBatch();
       Database.executeBatch(batch, 500);
       Test.stopTest();
       List<Object_sHistory__c> newObjectHistoryRecordList = [SELECT Id, New_Value__c  From Object_sHistory__c WHERE NOT (New_Value__c LIKE '%permission set%') ORDER BY CreatedDate DESC LIMIT 1];     
       Assert.areEqual(newObjectHistoryRecordList.size(), 0, 'Testing Negative cases'); 
    }
}