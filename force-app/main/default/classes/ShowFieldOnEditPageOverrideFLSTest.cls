/*
* @Description : This class is test class of ShowFieldOnEditPageOverrideFLS where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 08/10/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 08/10/2024 
*/
@isTest
public class ShowFieldOnEditPageOverrideFLSTest {

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
        Account accTestRecord = [SELECT Id, Name FROM Account WHERE Name = 'Test Account'];
        List<String> fieldList = new List<String>();
        Test.startTest();
        List<String> fieldConfigrationList = ShowFieldOnEditPageOverrideFLS.fieldConfigrationList();
        List<Object> layoutList = ShowFieldOnEditPageOverrideFLS.getLayoutName(accTestRecord.Id);
        List<Object> sectionList = ShowFieldOnEditPageOverrideFLS.returnlayout('Account-Account Layout');
        List<sObject> recordTypeList = ShowFieldOnEditPageOverrideFLS.getRecordType('Account', accTestRecord.Id);
        List<MetadataService.SaveResult> saveResultList = ShowFieldOnEditPageOverrideFLS.updateFieldLevelSecurity(fieldList, 'Account', 'Admin', true, true);
        Test.stopTest();
        System.debug('saveResultList---->'+saveResultList.size());
        Assert.areEqual(layoutList.size(), 1, 'layout list');  
        Assert.areEqual(sectionList.size(), 7, 'sections available into layout');
        Assert.areEqual(recordTypeList.size(), 1, 'record type list in ');  
        Assert.areEqual(saveResultList.size(), 0, 'update FLS save results');  
    }
    
    
     /*
* @description : This method is test method for negative test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testNegativeCases(){ 
        Test.startTest(); 
        List<String> fieldConfigrationList = ShowFieldOnEditPageOverrideFLS.fieldConfigrationList();
        List<Object> layoutList = ShowFieldOnEditPageOverrideFLS.getLayoutName(NULL);
        List<Object> sectionList = ShowFieldOnEditPageOverrideFLS.returnlayout('');
        List<sObject> recordTypeList = ShowFieldOnEditPageOverrideFLS.getRecordType(' ', NULL);
        List<MetadataService.SaveResult> saveResultList = ShowFieldOnEditPageOverrideFLS.updateFieldLevelSecurity(new List<String>{}, ' ', ' ', NULL, NULL);
        Test.stopTest();        
        
    }
    
}