/*
* @Description : This class is test class of DecribeSObjectHandler where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 26/12/2023
*@modified by  : Vivek Kumar Saurabh
*@modified date: 29/01/2025 
*/
@isTest
public class DecribeSObjectHandlerTest implements HttpCalloutMock {
    /*
* @description : This method is respond method to set fake response for HttpCalloutMock.
* @param : HTTPRequest req (send request from HttpCalloutMock).
* @return : HTTPResponse.
*/ 
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('{"message": "success"}');
        return res;
    }
    
    /*
* @description : This method is test method for positive test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testPositiveCases(){    
        Test.setMock(HttpCalloutMock.class, new DecribeSObjectHandlerTest());
        Test.startTest();
        List<Object> sObjectList = DecribeSObjectHandler.getSObjects();
        List<Object> recordTypeList = DecribeSObjectHandler.returnRecordTypeName('Account');
        DecribeSObjectHandler.RecordTypeWrapper wrapper = (DecribeSObjectHandler.RecordTypeWrapper)recordTypeList[0];
        List<Object> layoutWrapperList = DecribeSObjectHandler.getLayoutName(wrapper.value);
        List<Object> sectionWrapperList = DecribeSObjectHandler.returnlayout('Account-Account Data');
        Test.stopTest();
        Assert.areEqual(sObjectList.size(), 476, 'getting all sobject in sObject List in positive case'); 
        Assert.areEqual(recordTypeList.size(), 5, 'getting all recordType behalf on sObject in positive case');
        Assert.areEqual(layoutWrapperList.size(), 1, 'getting all sobject in sObject List in positive case'); 
        Assert.areEqual(sectionWrapperList.size(), 2, 'getting all section wrapper behalf on layout in positive case');  
        
    }
    
    /*
* @description : This method is test method for negative test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testNegativeCases(){    
        Test.setMock(HttpCalloutMock.class, new DecribeSObjectHandlerTest());
        Test.startTest();
        List<Object> sObjectList = DecribeSObjectHandler.getSObjects();
        List<Object> recordTypeList = DecribeSObjectHandler.returnRecordTypeName(NULL);
        List<Object> layoutWrapperList = DecribeSObjectHandler.getLayoutName(NULL);
        List<Object> sectionWrapperList = DecribeSObjectHandler.returnlayout(NULL);
        Test.stopTest();
        Assert.areEqual(sObjectList.size(), 476, 'getting all sobject in sObject List in negative case'); 
        Assert.areEqual(recordTypeList.size(), 0, 'getting all recordType behalf on sObject in negative case');
        Assert.areEqual(layoutWrapperList.size(), 0, 'getting all sobject in sObject List in negative case'); 
        Assert.areEqual(sectionWrapperList.size(), 0, 'getting all section wrapper behalf on layout in negative case');  
        
    }
}