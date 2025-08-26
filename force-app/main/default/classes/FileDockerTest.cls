/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 04/01/2023
* @Description : LWC Apex Code of File Docker Test Class.
******************************************************************/
@isTest
private class FileDockerTest {
      /**************************************************************************************************************************
	* @description : This method is test setup method .
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @testSetup
    static void createRecord(){
        Account accRec = DataFactory.returnAcc('new Account');
        Database.insert(accRec, false);     
        ContentVersion conVer = DataFactory.returnContentVersion(accRec.Id, '.xlsx');
        Database.insert(conVer, false);
        ContentVersion conVerSec = DataFactory.returnContentVersion(accRec.Id, '.jpg');
        Database.insert(conVerSec, false);
        ContentVersion conVerThird = DataFactory.returnContentVersion(accRec.Id, '.docx');
        Database.insert(conVerThird, false);
        ContentVersion conVerFourth = DataFactory.returnContentVersion(accRec.Id, '.txt');
        Database.insert(conVerFourth, false);
    }
      /**************************************************************************************************************************
	* @description : This method is check test methods.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void returnFilesTest(){
        Test.startTest();       
        Account acc = [SELECT Id FROM Account WHERE Name = 'new Account' LIMIT 1];
        List<Object> objectList = FileDocker.returnFiles(acc.Id);
        System.assertEquals(4, objectList.size()); //positive testing
        List<Object> objectListNull = FileDocker.returnFiles('');
        System.assertEquals(0, objectListNull.size()); //negative testing
        List<Id> docIdList = new List<Id>();
        for(ContentVersion iterateRec : [SELECT ContentDocumentId, Title, FileExtension FROM ContentVersion WHERE FirstPublishLocationId = :acc.Id]){
            docIdList.add(iterateRec.ContentDocumentId);
        }
        ContentVersion conDoc = [SELECT ContentDocumentId, Title, FileExtension FROM ContentVersion WHERE FirstPublishLocationId = :acc.Id LIMIT 1];
        FileDocker.editfile(conDoc.ContentDocumentId, 'new Title', 'ok');
        List<Object> objectOtherList = FileDocker.searchKey('new', acc.Id);
        System.assertEquals(4, objectOtherList.size()); //positive testing
        Object obj = FileDocker.returnfiledetails(conDoc.ContentDocumentId);
        List<Object> objList = new List<Object>();
        objList.add(obj);
        System.assertEquals(1, objList.size()); //positive testing
        Object objNeg = FileDocker.returnfiledetails('');
        List<Object> objListNeg = new List<Object>();
        objList.add(objNeg);
        System.assertEquals(0, objListNeg.size()); //Negative tesing
        FileDocker.deleteFile(conDoc.ContentDocumentId);
        List<Object> objectListafterDelete = FileDocker.returnFiles(acc.Id);        
        System.assertEquals(3, objectListafterDelete.size());        
        FileDocker.deletefileAll(docIdList);
        List<Object> objListafterDeleteAll = FileDocker.returnFiles(acc.Id);
        System.assertEquals(0, objListafterDeleteAll.size());
        Test.stopTest();
    }
    
}