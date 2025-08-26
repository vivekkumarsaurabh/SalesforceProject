/*
* @Description : This class is test class of DynamicPhoneInputWithCountryCode where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 11/11/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 11/11/2024 
*/
@isTest
public class DynamicPhoneInputWithCountryCodeTest {
    
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
        String jsonData;
        sObject testRecord;
        List<ContriesConfiguration__mdt> metaDataRecordList = new List<ContriesConfiguration__mdt>(); 
        Account accountRecord = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];        
        Test.startTest(); 
        if(accountRecord != NULL){
        jsonData = DynamicPhoneInputWithCountryCode.getAllCountryInfo();
        testRecord = DynamicPhoneInputWithCountryCode.updateRecord('Account', accountRecord.Id, '+919999999999');
        metaDataRecordList = DynamicPhoneInputWithCountryCode.getAllCountryConfiguration();
        }
        Test.stopTest();
        Assert.areNotEqual(jsonData, NULL, 'test possitive case because of actualldata comes multiple line then we use assertnotequals');       
    }
}