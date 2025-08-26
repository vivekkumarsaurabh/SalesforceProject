/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 16/01/2023
* @Description : LWC Apex Code of Mini Gallery Test Class.
******************************************************************/
@isTest
public class MiniGalleryTest { 
    /**************************************************************************************************************************
	* @description : This method is test setup method .
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/    
    @testSetup
    static void createRecord(){
        Account accRec = DataFactory.returnAcc('new Account');
        Database.insert(accRec, false);     
        ContentVersion conVer = DataFactory.returnContentVersion(accRec.Id, '.png');
        Database.insert(conVer, false);
    }
    /**************************************************************************************************************************
	* @description : This method is test runTestMethod.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void runTestMethod(){        
        List<Object> allObj = MiniGallery.getSObjects();
        System.assert(!allObj.isEmpty()); //positive test
        Test.startTest(); 
        List<object> searchRec = MiniGallery.sObjectSearch('Account');
        System.assert(!searchRec.isEmpty()); //positive Test
        List<object> searchRecNeg = MiniGallery.sObjectSearch(' ');
        System.assertEquals(null, searchRecNeg); //negative Test
        List<Object> allRecord = MiniGallery.getAllRecords('Account', 'Name');
        System.assert(!allRecord.isEmpty()); //positive Test
        List<Object> allRecordNeg = MiniGallery.getAllRecords(' ', ' ');
        System.assertEquals(null, allRecordNeg); //Negative Test
        List<Object> searchRecordList = MiniGallery.searchRecord('Account', 'new');
        System.assert(!searchRecordList.isEmpty()); //positive Test                
        List<Object> searchRecordListNeg = MiniGallery.searchRecord(' ', ' ');
        System.assertEquals(null, searchRecordListNeg); //Negative Test  
        Account acc = [SELECT ID FROM Account WHERE Name = 'new Account' LIMIT 1];
        List<Object> allUrl = MiniGallery.getImage(acc.Id);        
        System.assert(!allUrl.isEmpty()); //positive Test  
        List<Object> allUrlNeg = MiniGallery.getImage('');        
        System.assertEquals(null, allUrlNeg); //negative Test
        Test.stopTest(); 
        }
}