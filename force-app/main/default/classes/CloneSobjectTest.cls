/*
* @Description : This class is test class of CloneSobject where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 10/12/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 10/12/2024 
*/
@isTest
public class CloneSobjectTest {
    
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
    }
    
    /*
* @description : This method is test method for positive test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testPositiveCases(){
        List<Object> sObjectfieldWrapperValue;
        String sObjectRecord;
        String sObjectLabelName;
        Account accountRecord = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        String jsonWrapper = '[{"key":"Name","value":"Testing Acccount"}]';
        List<CloneSobject.NewCloneRecord> wrapperList = (List<CloneSobject.NewCloneRecord>)JSON.deserialize(jsonWrapper, List<CloneSobject.NewCloneRecord>.class);
        Test.startTest();
        if(accountRecord != NULL){
            sObjectfieldWrapperValue = CloneSobject.getsObjectFieldsValues(accountRecord.Id);
            sObjectRecord = CloneSobject.createRecord('Account', wrapperList);
            sObjectLabelName = CloneSobject.sObjectLabelName('Account');
        }
        Test.stopTest();
        // Assert.areEqual(sObjectRecord, 'Account:{Name=Testing Acccount, Id=001J400000O8niCIAR}','testing positive cases for getting all group list');
            Assert.areEqual(sObjectfieldWrapperValue.size(), 12,'testing positive cases for getting all sObjectWrapper value');   
            Assert.areEqual(sObjectLabelName, 'Account','testing positive cases for getting label name of sObject');   

    }
     /*
* @description : This method is test method for negative test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testNegativeCases(){ 
          Test.startTest();
           List<Object> sObjectfieldWrapperNegValue = CloneSobject.getsObjectFieldsValues(NULL);
           String sObjectRecordNeg = CloneSobject.createRecord(NULL, NULL);
           String sObjectLabelNameNeg = CloneSobject.sObjectLabelName(NULL);      
        Test.stopTest();
          Assert.areEqual(sObjectfieldWrapperNegValue.size(), 0,'testing Negative cases for getting all wrapper list');
         Assert.areEqual(sObjectLabelNameNeg, NULL,'testing Negative cases for getting label name of sObject'); 
    }
}