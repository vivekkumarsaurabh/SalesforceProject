/*
* @Description : This class is test class of ListViewController where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 17/06/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 17/06/2024 
*/
@isTest
public class ListViewControllerTestClass {

    /*
	* @description : This method is test method for positive test cases.
	* @param : N/A.
	* @return : N/A.
    */
    @isTest
    static void testPositiveCases(){  
        String objectName = 'Account';
        List<ListView> listviewApiList = [SELECT id, Name, DeveloperName FROM ListView WHERE sObjectType = : objectName];
        Test.startTest();         
        List<Object> listViewWrapperList = ListViewController.retriveListValueApiName(objectName);
        Test.stopTest(); 
        Assert.areEqual(listViewWrapperList.size(), listviewApiList.size(), 'Testing for retrive listView List');
    }
    
     /*
	* @description : This method is test method for negative test cases.
	* @param : N/A.
	* @return : N/A.
	*/
    @isTest
    static void testNegativeCases(){
        Test.startTest();
        List<Object> listViewWrapperList = ListViewController.retriveListValueApiName('');        
        Test.stopTest();
        Assert.areEqual(listViewWrapperList.size(), 0, 'Testing negative for retrive listView List when objectName given blank');

        
    }
}