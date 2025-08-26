/*
* @Description : This class is test class of ShareObjectRecordWithLWC where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 29/05/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 05/06/2024 
*/
@isTest
public class ShareObjectRecordWithLWCTestClass {
    
    /*
* @description : This method is test setup method for creating test Records.
* @param : N/A.
* @return : N/A.
*/
    @testSetup
    static void testSetupMethod(){
        Account createAccountRecord = TestDataFactory.createAccountRecordInstance('Test Account');         
        if(createAccountRecord != NULL){
            Database.insert(createAccountRecord, false); 
        }
        
        /**User createUserRecord = TestDataFactory.createUserInstance();
        if(createUserRecord != NULL){
            Database.insert(createUserRecord, false); 
        }**/
        
    }
    /*
	* @description : This method is test method for positive test cases.
	* @param : N/A.
	* @return : N/A.
	*/     
    @isTest
    static void testPositiveCases(){        
        Account accountRecord = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];       
        Test.startTest();  
        ShareObjectRecordWithLWC.manualShareRead(accountRecord.Id, '', 'Account');
        Test.stopTest(); 
    }
    
}