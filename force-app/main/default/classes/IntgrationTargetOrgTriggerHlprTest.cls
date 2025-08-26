/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 05/12/2023
* @Description : Test Class of Integration on CRUD.
******************************************************************/
@isTest
public class IntgrationTargetOrgTriggerHlprTest implements HttpCalloutMock{     
    public HTTPResponse respond (HTTPRequest req) {    
        HttpResponse res = new HttpResponse ();
        res.setStatusCode(200);
        return res;
    }
    
    @isTest
    static void insertOnTargetOrg(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IntgrationTargetOrgTriggerHlprTest());
        Account accRecord = DataFactory.returnAcc('Acc Rec', 't@gmail.com', 'Cold');        
        Database.insert(accRecord, false);   
        Account accRecord1 = new Account(Id = accRecord.Id, Name = 'Acc Rec 1', Rating = 'Cold', External_Id_Account__c = 't@gmail.com');        
        Database.update(accRecord1, false);         
        Account accRecord2 = new Account(Id = accRecord1.Id);
        Database.delete(accRecord2, false);        
        Test.stopTest();
    }  
}