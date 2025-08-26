/*
* @Description : This class is test class of ApprovalProcessRequest where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 05/02/2025
* @modified by  : Vivek Kumar Saurabh
* @modified date: 05/02/2025 
*/
@isTest
public class ApprovalProcessRequestTest {
    
    /*
	* @description : This method is test setup method for creating test Records.
	* @param : N/A.
	* @return : N/A.
	*/
    @testSetup
     static void testSetupMethod(){
        Case createCaseRecord = TestDataFactory.createCaseInstance('Test Approve case');
        if(createCaseRecord != NULL){
        Database.insert(createCaseRecord, false);
        }
        Case createCaseReqRecord = TestDataFactory.createCaseInstance('Test Pending case');
        if(createCaseReqRecord != NULL){
        Database.insert(createCaseReqRecord, false);
        }
    }

      /*
	* @description : This method is test method for positive test cases.
	* @param : N/A.
	* @return : N/A.
	*/      
    @isTest 
    static void testPositiveCases(){ 
        Case caseRecord =  [SELECT Id FROM Case WHERE Subject = 'Test Approve case' LIMIT 1];
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();   
        req.setObjectId(caseRecord.Id);
        req.setComments('Test Approve case');
        Case caseOtherRecord =  [SELECT Id FROM Case WHERE Subject = 'Test Pending case' LIMIT 1];
        Approval.ProcessSubmitRequest reqOther = new Approval.ProcessSubmitRequest();   
        reqOther.setObjectId(caseOtherRecord.Id);
        reqOther.setComments('Test Pending case');
        List<Approval.ProcessResult> result = Approval.process(new List<Approval.ProcessSubmitRequest>{req, reqOther});
        ProcessInstance processInstance = [SELECT Id, Status, TargetObjectId, SubmittedById, SubmittedBy.Name, CreatedDate FROM ProcessInstance WHERE Status = 'Pending' AND TargetObjectId = :caseRecord.Id LIMIT 1];
        ProcessInstanceWorkitem processWork = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId = :processInstance.Id ];
        Approval.ProcessWorkitemRequest processWorkItemReq = new Approval.ProcessWorkitemRequest();
        processWorkItemReq.setComments('');
        processWorkItemReq.setAction('Approve'); 
        processWorkItemReq.setWorkitemId(processWork.Id);
        Approval.ProcessResult resultList = Approval.process(processWorkItemReq);
        Test.startTest(); 
        List<Object> approvalProcessReqList = ApprovalProcessRequest.getAllApprovalRequest(); 
        ApprovalProcessRequest.ProcessInstanceWrapper wrapper = (ApprovalProcessRequest.ProcessInstanceWrapper)approvalProcessReqList[0];        
        Boolean approveRequestTest = ApprovalProcessRequest.approveRejectProcessInstance(new List<Id>{wrapper.processInstanceId}, 'Approve');
        Test.stopTest();   
        Assert.areEqual(approvalProcessReqList.size(), 1, 'Testing for retriving all request of approval process in positive test');
        Assert.areEqual(approveRequestTest, TRUE, 'Testing for retriving result of approval process in positive test');
    }
    
       /*
	* @description : This method is test method for negative test cases.
	* @param : N/A.
	* @return : N/A.
	*/      
    @isTest 
    static void testNegativeCases(){ 
        Test.startTest(); 
        List<Object> approvalProcessReqListNeg = ApprovalProcessRequest.getAllApprovalRequest(); 
        Boolean approveRequestNegTest = ApprovalProcessRequest.approveRejectProcessInstance(NULL, NULL);
        Test.stopTest();   
        Assert.areEqual(approvalProcessReqListNeg.size(), 0, 'Testing for retriving all request of approval process in negative test');
        Assert.areEqual(approveRequestNegTest, FALSE, 'Testing for retriving result of approval process in negative test');
    }
    
    
}