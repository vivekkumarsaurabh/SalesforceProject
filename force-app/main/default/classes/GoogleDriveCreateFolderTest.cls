/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 11/12/2023
* @Description : Test Class of Google Integration  .
******************************************************************/
@isTest
public class GoogleDriveCreateFolderTest implements HttpCalloutMock{     
   
    public class GoogleDriveNegativeTest implements HttpCalloutMock{
        
    /**************************************************************************************************************************
	* @description : This method is check status code for Negative.
	* @param : HTTPRequest req.
	* @return : HttpResponse.
	***************************************************************************************************************************/
        public HTTPResponse respond (HTTPRequest req) {    
        HttpResponse res = new HttpResponse();
        res.setStatusCode(401);
        return res;
    }
        
    }
    /**************************************************************************************************************************
	* @description : This method is check status code.
	* @param : HTTPRequest req.
	* @return : HttpResponse.
	***************************************************************************************************************************/
    public HTTPResponse respond (HTTPRequest req) {    
        HttpResponse res = new HttpResponse ();
        res.setHeader('Content-Type', 'application/json');   
        res.setBody('{"title" : "Contact","mimeType" : "application/vnd.google-apps.folder"}');
        res.setStatusCode(200);
        return res;
    }
    
    /**************************************************************************************************************************
	* @description : This method is test method for get Folder in Google Drive.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void getFolderTest(){  
        HTTPResponse res = new HTTPResponse();
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new GoogleDriveCreateFolderTest());        
        res = GoogleDriveCreateFolder.getFolder();
        Test.stopTest();
        System.assertEquals(res.getStatusCode(), 200);
    }
    
    /**************************************************************************************************************************
	* @description : This method is test method for create Folder in Google Drive.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void createFolderTest(){
        HttpResponse res = new HttpResponse();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleDriveCreateFolderTest());
        res = GoogleDriveCreateFolder.createFolder();
        Test.stopTest();
         System.assertEquals(res.getStatusCode(), 200);
    }
    
    /**************************************************************************************************************************
	* @description : This method is test method for delete Folder in Google Drive.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void deleteFolderTest(){
        HttpResponse res = new HttpResponse();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleDriveCreateFolderTest());
        res = GoogleDriveCreateFolder.deleteFolder('1Fl2OrXGxLUWmL53X8ZRkigESMLzxG4h4');
        Test.stopTest(); 
         System.assertEquals(res.getStatusCode(), 200);
    }
    
    /**************************************************************************************************************************
	* @description : This method is test method for delete Folder in Google Drive for Negative Testing.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void deleteFolderNegTest(){
        HttpResponse res = new HttpResponse();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleDriveNegativeTest());
         res = GoogleDriveCreateFolder.deleteFolder('1Fl2OrXGxLUWmL53X8Z');
        Test.stopTest();  
         System.assertEquals(res.getStatusCode(), 401);
    }
    
    /**************************************************************************************************************************
	* @description : This method is test method for upload File Folder in Google Drive.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/    
    @isTest 
    static void uploadFolderTest(){
        HttpResponse res = new HttpResponse();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleDriveCreateFolderTest());
        ContentVersion conVer = DataFactory.returnContentVersion();
        res = GoogleDriveCreateFolder.uploadFiles(conVer, '1Fl2OrXGxLUWmL53X8ZRkigESMLzxG4h4');
        Test.stopTest();
         System.assertEquals(res.getStatusCode(), 200);
    }
    
    /**************************************************************************************************************************
	* @description : This method is test method for upload File Folder in Google Drive for Negative Testing.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/    
    @isTest 
    static void uploadFolderNegTest(){
        HttpResponse res = new HttpResponse();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GoogleDriveNegativeTest());
        ContentVersion conVer = DataFactory.returnContentVersion();
        res = GoogleDriveCreateFolder.uploadFiles(conVer, '1Fl2OrXGxLUWmL53X');
        Test.stopTest();
         System.assertEquals(res.getStatusCode(), 401); 
    }
    
}