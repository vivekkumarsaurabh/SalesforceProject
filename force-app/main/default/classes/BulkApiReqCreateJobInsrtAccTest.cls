/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 07/12/2023
* @Description : Test Class of Bulk Api Create Job and Insert Account Record in Target Org.
******************************************************************/
@isTest
public class BulkApiReqCreateJobInsrtAccTest implements HttpCalloutMock{
    
    /**************************************************************************************************************************
	* @description : This method is check status code.
	* @param : HTTPRequest req.
	* @return : HttpResponse.
	***************************************************************************************************************************/
    public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse ();
        res.setHeader('Content-Type', 'application/json');   
        res.setBody('{"Name":"InsertRec"}');
        res.setStatusCode(200);
        return res;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for dummy data.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/    
    @isTest
    static void createJobTest(){
        ContentVersion createConVer = DataFactory.returnContentVersion();
        insert createConVer;        
        Test.startTest();          
        Test.setMock(HttpcalloutMock.class, new BulkApiReqCreateJobInsrtAccTest());
        BulkApiResuestCreateJobInsertAcc.putUploadJob('insert', 'Account', 'CSV', 'LF', '"Name"\n"InsertRec"');         
        Test.stopTest();    
        
    }
}