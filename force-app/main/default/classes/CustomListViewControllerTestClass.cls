/*
* @Description : This class is test class of CustomListViewController where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 20/06/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 20/06/2024 
*/
@isTest
public class CustomListViewControllerTestClass {

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
        Account accountRecord = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        PageReference testPageRefference = new PageReference('/'+accountRecord.Id);
        Test.startTest();  
        ApexPages.StandardController sc = new ApexPages.StandardController(accountRecord);
        CustomListViewController testAccountRecord = new CustomListViewController(sc);
        PageReference pageRef = testAccountRecord.saveAccount();
        testAccountRecord.validate();
        PageReference pageRefferce = testAccountRecord.backtoPage();
        Boolean setResult = testAccountRecord.getResult();
        System.debug('pageRefferce===>'+pageRefferce);
        Test.stopTest(); 
        Assert.areEqual(pageRef, NULL, 'Testing for retrive null if validate my Profile and they do not match');
        Assert.areEqual(pageRefferce, testPageRefference, 'Testing for back to main Page where you have perform action');
        Assert.areEqual(setResult, false, 'Testing for retrive null if validate my Profile and they do not match');
    }
    
    /*
	* @description : This method is test method for negative test cases.
	* @param : N/A.
	* @return : N/A.
	*/
    @isTest
    static void testNegativeCases(){
        Account accountRecord = [SELECT Id, Name, Industry, Type FROM Account WHERE Name = 'Test Account' LIMIT 1];
        PageReference testPageRefference = new PageReference('/'+accountRecord.Id);
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(accountRecord);        
        CustomListViewController testAccountRecordNeg = new CustomListViewController(sc);
        PageReference pageRef = testAccountRecordNeg.saveAccount();        
        testAccountRecordNeg.validate();
        PageReference pageRefferce = testAccountRecordNeg.backtoPage();
        Boolean setResult = testAccountRecordNeg.getResult();
        Test.stopTest();
         Assert.areEqual(pageRef, NULL, 'Testing for retrive null if validate my Profile and they do not match');
        Assert.areEqual(pageRefferce, testPageRefference, 'Testing for back to main Page where you have perform action');
        Assert.areEqual(setResult, false, 'Testing for retrive null if validate my Profile and they do not match');
    }
}