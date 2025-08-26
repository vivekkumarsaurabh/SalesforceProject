/**
@description : This class is test class of ExceptionHandlingClasss where testing different positive scenario and negative scenario.
@author : Vivek Kumar Saurabh
@cerated date : 05/06/2024
@modified by : Vivek Kumar Saurabh
@modified date : 05/06/2024
*/
@isTest
private class ExceptionHandlingTestClass {
    
    /*
	* @description : This method is test method for positive test cases.
	* @param : N/A.
	* @return : N/A.
	*/
    @isTest
    static void testPositiveCases(){
        Test.startTest();
        ExceptionHandlingClass.exceptionLogRecords('ExceptionHandlingTestClass', 'testPositiveCases', 'NullPointerExceptionError', 'for test purposes', 1);
        Test.stopTest();
        List<Exception_Logs__c> exceptionLogsList = [SELECT ID FROM  Exception_Logs__c WHERE Class_Name__c = 'ExceptionHandlingTestClass' LIMIT 1];
        Assert.areEqual(exceptionLogsList.size(), 1, 'Testing exception log created for positive testing'); 
    }

}