/*
* @Description : This class is used for shareAccountRecord with User using LWC Checkbox;
* @Author      : Vivek Kumar Saurabh
* @Created Date: 14/06/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 14/06/2024
*/
public class ShareObjectRecordWithLWC {
    /*
	* @description : This method is used for shareAccount method to shate the record beahlf of accountId and userId.
	* @param : Id accountId, Id userId  accountrecordId and userId used as a params.
	* @return : N/A.
	*/
    @AuraEnabled
    public static void manualShareRead(Id recordId, Id userId, String objectName) {
        String shareObjectName;       
        List<AccountShare> accountShareList = new List<AccountShare>();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType objType = globalDescribe.get(objectName);
        if(objType != NULL){
            if(objType.getDescribe().isCustom()){
                shareObjectName = objectName+'__Share';
            }else{
                shareObjectName = objectName+'Share';
            }
        }
        if(shareObjectName != NULL){
            String query = 'SELECT Id FROM '+shareObjectName+' WHERE Id != NULL';        
            List<SObject> objRecordList = Database.query(query);            
            if(!objRecordList.isEmpty() && objRecordList != NULL){
                for(SObject iterateObjectRecord : objRecordList){
                    if(iterateObjectRecord.Id != recordId){
                        AccountShare accountShare = new AccountShare();
                        accountShare.AccountId = iterateObjectRecord.Id; 
                        accountShare.UserOrGroupId = userId; 
                        accountShare.AccountAccessLevel = 'Private';
                        accountShare.ContactAccessLevel = 'Private';
                        accountShare.CaseAccessLevel = 'Private';
                        accountShare.OpportunityAccessLevel = 'Private';
                        accountShare.RowCause = Schema.AccountShare.RowCause.Manual;
                        accountShareList.add(accountShare);
                    }
                }
            }
        }
        try{
            if(!accountShareList.isEmpty() && accountShareList != NULL){
                Database.insert(accountShareList, false);
            }        
        }catch(DmlException e){
            ExceptionHandlingClass.exceptionLogRecords('ShareAccountWithUser', 'shareAccountmethod', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        } 
    }
}