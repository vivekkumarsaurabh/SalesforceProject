@isTest
public class CompositeApiCreateRecordTest implements HttpCalloutMock{
    /**************************************************************************************************************************
	* @description : This method is check status code.
	* @param : HTTPRequest req.
	* @return : HttpResponse.
	***************************************************************************************************************************/
    public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse ();
        res.setHeader('Content-Type', 'application/json');   
        res.setBody('{"Name":"New Account"}');
        res.setStatusCode(200);
        return res;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for dummy data and Test.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void createRecordWithCompApi(){       
        Test.startTest();          
        Test.setMock(HttpcalloutMock.class, new CompositeApiCreateRecordTest());
        CompositeApiCreateRecords.createRecordWithCompositApi('POST', 'Account', new Account(Name = 'New Account'));         
        Test.stopTest();   
    }
    
    
}