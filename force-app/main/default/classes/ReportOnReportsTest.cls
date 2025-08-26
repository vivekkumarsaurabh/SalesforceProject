/*
* @Description : This class is test class of ReportsOfReport where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 26/08/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 26/08/2024 
*/
@isTest(SeeAllData='true')
public class ReportOnReportsTest {    
    /*
	* @description : This method is test method for positive test cases.
	* @param : N/A.
	* @return : N/A.
	*/
    @isTest
    static void testPositiveCases(){        
        String filter = '[{"fieldName" : "Owner.Name", "value" : "Vivek Kumar Saurabh"}, {"fieldName" : "Format", "value" : "Matrix"}]';
        Test.startTest();  
        List<Object> allReportsWrapperList = ReportOnReports.getAllReports(NULL, '');       
        Test.stopTest();    
        Assert.areEqual(allReportsWrapperList.size(), 2, 'Testing for retriving all reports in positive test');
    }
    
    /*
	* @description : This method is test method for negative test cases.
	* @param : N/A.
	* @return : N/A.
	*/      
    @isTest
    static void testNegativeCases(){ //Comment :Alignment is not right.
        Test.startTest();  
        List<Object> allReportsWrapperListNeg = ReportOnReports.getAllReports(NULL, NULL);      
        Test.stopTest();   
        Assert.areEqual(allReportsWrapperListNeg.size(), 0, 'Testing for retriving all reports in negative test');        
    } 
}