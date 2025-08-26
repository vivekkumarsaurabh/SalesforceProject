/*
* @Description : This class is used track audittrailRecord with Batch;
* @author      : Vivek Kumar Saurabh
* @Created Date: 03/06/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 05/06/2024
*/
public class TrackAuditTrailRecordsBatch implements Database.Batchable<SObject> {
    /*
	* @description : This method is prdefined method of Database.Batchable Interface method for return SetupAuditTrail Records.
	* @param : Database.BatchableContext BC (Batchable Context take as params).
	* @return : Database.QueryLocator (Return Records of SetupAuditTrail).
	*/
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Action, CreatedDate, Display, Id, Section FROM SetupAuditTrail WHERE CreatedDate = YESTERDAY]);
    }
    /*
	* @description : This method is also predefined method of Batchable interface execute method.
	* @param : Database.BatchableContext BC, List<SObject> auditTrailRecList (Batchable Context take as params and take list of SetupAuditTrail Records).
	* @return : N/A.
	*/    
    public void execute(Database.BatchableContext BC, List<SetupAuditTrail> auditTrailRecList) {
        List<Object_sHistory__c> objectHistoryRecordList = new List<Object_sHistory__c>();
        List<String> nonSetupObjectNameList = System.Label.nonSetupObject.split(',');
        try{
            if(!auditTrailRecList.isEmpty() && auditTrailRecList != NULL){
                for(SetupAuditTrail iterateAuditRecord: auditTrailRecList){        // Don't use hard code values
                    if(!nonSetupObjectNameList.isEmpty() && nonSetupObjectNameList != NULL){
                        for(String iterateNonSetupObjectName : nonSetupObjectNameList){
                            if(iterateAuditRecord.Display.contains(iterateNonSetupObjectName)){  
                                Object_sHistory__c createObjHistory = new Object_sHistory__c();
                                createObjHistory.Object_Name__c = iterateAuditRecord.Action;                       
                                createObjHistory.New_Value__c = iterateAuditRecord.Display;                        
                                createObjHistory.Record_Id__c = iterateAuditRecord.Id;
                                objectHistoryRecordList.add(createObjHistory);
                            }
                        }
                    }
                }
            }        
            
            if(!objectHistoryRecordList.isEmpty() && objectHistoryRecordList != NULL){ 
                insert objectHistoryRecordList;
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('TrackAuditTrailRecordsBatch', 'execute Batch Method', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
    }
    /*
	* @description : This method is also predefined method of Batchable interface finish method.
	* @param : Database.BatchableContext BC (Batchable Context take as params).
	* @return : N/A.
	*/   
    public void finish(Database.BatchableContext BC) {
        System.debug('Finish Job');
    }  
    
}