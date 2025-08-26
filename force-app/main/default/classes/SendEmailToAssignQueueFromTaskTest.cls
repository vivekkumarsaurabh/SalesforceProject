/*
* @Description : This class is test class of SendEmailToAssignQueueFromTask where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 16/01/2025
*@modified by  : Vivek Kumar Saurabh
*@modified date: 16/01/2025 
*/
@isTest
public class SendEmailToAssignQueueFromTaskTest {
    /*
* @description : This method is test setup method for creating test Records.
* @param : N/A.
* @return : N/A.
*/
    @testSetup
    static void testSetupMethod(){
        Group createGroupRecord = TestDataFactory.createGroupsInstance('TestDummyGroup', 'Queue');         
        if(createGroupRecord != NULL){
            insert createGroupRecord;
        }       
        QueueSobject createQueueSobjectRecord = TestDataFactory.createQueueSobjectInstance(createGroupRecord.Id, 'Task');
        if(createQueueSobjectRecord != NULL){
            Database.insert(createQueueSobjectRecord, false);    
        }        
    }
    /*
* @description : This method is test method for positive test cases.
* @param : N/A.
* @return : N/A.
*/     
    @isTest
    static void testPositiveCases(){
        Group groupRecord = [SELECT Id FROM GROUP WHERE Name = 'TestDummyGroup' AND Type='Queue' LIMIT 1];        
        Test.startTest();
        if(groupRecord != NULL){
            Task createTaskRecord = TestDataFactory.createTaskInstance(groupRecord.Id);
            if(createTaskRecord != NULL){
                Database.insert(createTaskRecord, false); 
            }  
        }
        Test.stopTest();
        
    }
    
}