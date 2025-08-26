/*
* @Description : This class is used for LWC of Approval Process Request component;
* @author      : Vivek Kumar Saurabh
* @date        : 04/02/2025
*@modified by  : Vivek Kumar Saurabh
*@modified date: 04/02/2025
*/
public class ApprovalProcessRequest {
    /*
* @description : This method is getting all pending approval request with help of ProcessInstance.
* @param : N/A.
* @return : List<ProcessInstanceWrapper> wrapper data list of approval request.
*/  
    @AuraEnabled
    public static List<ProcessInstanceWrapper> getAllApprovalRequest(){
        List<ProcessInstanceWrapper> ProcessInstanceWrapperList = new List<ProcessInstanceWrapper>();
        Map<String, SObjectType> sObjects = Schema.getGlobalDescribe();
        try{
            ProcessInstance recentApprovalUserinfo = [SELECT SubmittedBy.Name, SubmittedById FROM ProcessInstance WHERE Status = 'Approved' ORDER BY CreatedDate DESC LIMIT 1];
            for(ProcessInstance iterateProcessInstance : [SELECT Id, TargetObjectId, TargetObject.Name, Status, SubmittedById, SubmittedBy.Name, CreatedDate FROM ProcessInstance WHERE Status = 'Pending' ORDER BY CreatedDate DESC]){
                ProcessInstanceWrapper createInstanceWrapper = new ProcessInstanceWrapper();
                createInstanceWrapper.processInstanceId = iterateProcessInstance.Id;
                createInstanceWrapper.name = iterateProcessInstance.TargetObject.Name;
                createInstanceWrapper.objectId = iterateProcessInstance.TargetObjectId;
                if (!sObjects.get(String.valueOf(iterateProcessInstance.TargetObjectId.getsobjecttype())).getDescribe().getName().endsWith('__c')) {
                    createInstanceWrapper.objectType = sObjects.get(String.valueOf(iterateProcessInstance.TargetObjectId.getsobjecttype()).replaceAll('\\s+', '')).getDescribe().getLabel();
                } else {
                    createInstanceWrapper.objectType = String.valueOf(sObjects.get(String.valueOf(iterateProcessInstance.TargetObjectId.getsobjecttype())).getDescribe().getLabel()); 
                }
                if(recentApprovalUserinfo != NULL){
                    createInstanceWrapper.mostRecentApprovalName = recentApprovalUserinfo.SubmittedBy.Name;
                    createInstanceWrapper.mostRecentApprovalId = recentApprovalUserinfo.SubmittedById;    
                }               
                createInstanceWrapper.status = iterateProcessInstance.Status;
                createInstanceWrapper.dateSubmitted = iterateProcessInstance.createdDate;
                createInstanceWrapper.submitUserId =  iterateProcessInstance.SubmittedById;
                createInstanceWrapper.submitUserName = iterateProcessInstance.SubmittedBy.Name;
                ProcessInstanceWrapperList.add(createInstanceWrapper);
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ApprovalProcessRequest', 'getAllApprovalRequest', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return ProcessInstanceWrapperList;         
    }
    
    /*
* @description : This method is use to update status of approval request in bulk.
* @param : N/A.
* @return : List<Object> processInstanceList as a params, String action like approve and reject.
*/  
    @AuraEnabled
    public static Boolean approveRejectProcessInstance(List<Id> processInstanceList, String action){
        List<Approval.ProcessResult> resultList = new List<Approval.ProcessResult>();
        List<Approval.ProcessWorkitemRequest> processWorkItemsList = new List<Approval.ProcessWorkitemRequest>();       
        if(!processInstanceList.isEmpty() && action != NULL){
          Set<Id> pInstanceWorkitems = (new Map<Id, ProcessInstanceWorkitem>([SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId in :processInstanceList])).keySet();
            try{
                for(Id iterateWorkItem : pInstanceWorkitems){
                    Approval.ProcessWorkitemRequest processWorkItemReq = new Approval.ProcessWorkitemRequest();
                    processWorkItemReq.setComments('');
                    processWorkItemReq.setAction(action); 
                    processWorkItemReq.setWorkitemId(iterateWorkItem);
                    processWorkItemsList.add(processWorkItemReq);
                }            
                if(!processWorkItemsList.isEmpty()){
                    resultList =  Approval.process(processWorkItemsList);
                }
                if(!resultList.isEmpty()){
                    return true;
                }
            }catch(Exception e){
                ExceptionHandlingClass.exceptionLogRecords('ApprovalProcessRequest', 'approveRejectProcessInstance', e.getMessage(), e.getStackTraceString(), e.getLineNumber()); 
            }
        }        
       return false;
    }
    
    public class ProcessInstanceWrapper{
        @AuraEnabled public String processInstanceId;
        @AuraEnabled public String name;
        @AuraEnabled public String objectId;
        @AuraEnabled public String objectType;
        @AuraEnabled public String status;
        @AuraEnabled public String mostRecentApprovalName;
        @AuraEnabled public String mostRecentApprovalId;
        @AuraEnabled public String submitUserName;        
        @AuraEnabled public String submitUserId;
        @AuraEnabled public Datetime dateSubmitted;        
    }
}