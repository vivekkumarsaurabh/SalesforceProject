/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 08/01/2023
* @Description : LWC Apex Code of DataTable.
******************************************************************/
public class DataTable {
    /**************************************************************************************************************************
	* @description : This method is return Account Objects.
	* @param : N/A.
	* @return : List<Account>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<Account> getAccountList() {
        return [SELECT Id, Name, Type, Rating, Phone, Website, AnnualRevenue FROM Account ORDER BY CreatedDate DESC];
    }
    
    /**************************************************************************************************************************
	* @description : This method is return all Account data.
	* @param : String searchVal.
	* @return : List<Account>.
	***************************************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<Account> retriveAccData(Integer limitSize, Integer offset){
        return [SELECT Id, Name, Rating, Phone, Website, AnnualRevenue FROM Account  ORDER BY CreatedDate LIMIT :limitSize OFFSET :offset];
    }
    
     /**************************************************************************************************************************
	* @description : This method is search behalf of Search key.
	* @param : String searchVal.
	* @return : List<Account>.
	***************************************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<Account> searchKey(String searchVal){
        if(searchVal == null || String.isBlank(searchVal)){
            return NULL;
        }
        String searckKey = '%'+searchVal+'%';
        return [SELECT Id, Name, Type, Rating, Phone, Website, AnnualRevenue FROM Account WHERE Name LIKE :searckKey];
    }
    
     /**************************************************************************************************************************
	* @description : This method is delete Accounts records.
	* @param : String recId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static void deleteAcc(String recId){
        List<Account> accRecordList = [SELECT ID, Name FROM Account WHERE ID = :recId LIMIT 1];
        if(!accRecordList.isEmpty()){
            delete accRecordList;
        }
    }
    
     /**************************************************************************************************************************
	* @description : This method is columns header.
	* @param : N/A.
	* @return : List<AccountColumnWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<AccountColumnWrapper> getAccColumn(){
        List<AccountColumnWrapper> accWrapperList = new List<AccountColumnWrapper>();
        for(Account_Mapping__mdt iterateRec : [SELECT Id, label, FieldName__c, type__c, sortable__c, editable__c, (SELECT label,target__c FROM typeAttributes__r) FROM Account_Mapping__mdt]){
            AccountColumnWrapper createWrapper = new AccountColumnWrapper();
            TypeAttributesWrapper createChildWrapper = new TypeAttributesWrapper();            
            label filLabel = new label(); 
            for(typeAttribute__mdt iterateChild : iterateRec.typeAttributes__r){
                filLabel.fieldName = iterateChild.label;
                createChildWrapper.target = iterateChild.target__c;    
                createChildWrapper.label = filLabel; 
                createWrapper.typeAttributes = createChildWrapper;
            }                  
            createWrapper.label = iterateRec.Label;
            createWrapper.fieldName = iterateRec.FieldName__c;
            createWrapper.type = iterateRec.type__c;
            createWrapper.sortable = iterateRec.sortable__c; 
            createWrapper.editable = iterateRec.editable__c;
            if(iterateRec.type__c == 'action'){                
                createWrapper.type = iterateRec.type__c;
                createWrapper.sortable = false;
                createWrapper.label = '';
                createWrapper.fieldName = '';
                TypeAttributesWrapper createChildWrapperOther = new TypeAttributesWrapper(); 
                RowsAction actionCreate = new RowsAction();
                actionCreate.label = 'Edit';
                actionCreate.name = 'edit';
                RowsAction actionCreateOther = new RowsAction();
                actionCreateOther.label = 'Delete';
                actionCreateOther.name = 'delete';
                List<RowsAction> actionList = new List<RowsAction>();
                actionList.add(actionCreate);
                actionList.add(actionCreateOther); 
                createChildWrapperOther.menuAlignment = 'right';
                createChildWrapperOther.rowActions = actionList;
                createWrapper.typeAttributes = createChildWrapperOther;
            }
            accWrapperList.add(createWrapper);
        }
        return accWrapperList;
    }
    
    @AuraEnabled
public static string updateContacts(String data) {
  //  List<SObject> contactsForUpdate = (List<SObject>) JSON.deserialize(JSON.serialize(data),List<SObject>.class);
        List<Account> contactsForUpdate = (List<Account>) JSON.deserialize(data, List<Account>.class);

    System.debug('data---->'+contactsForUpdate);
    try {
        update contactsForUpdate;
        return 'Success: contacts updated successfully';
    }
    catch (Exception e) {
        return 'The following exception has occurred: ' + e.getMessage();
    }
}
    
    public class TypeAttributesWrapper{
        @AuraEnabled public label label;
        @AuraEnabled public String target; 
        @AuraEnabled public List<RowsAction> rowActions;
        @AuraEnabled public String menuAlignment;
    }
    
 /**   public class CellAttributesWrapper{
      @AuraEnabled public classWrapper class;
    }
    
    public class classWrapper{
        @AuraEnbled public String fieldName;
    }**/
    
    public class RowsAction{
        @AuraEnabled public String  label;
        @AuraEnabled public String  name;
    }
    public class AccountColumnWrapper{
        @AuraEnabled public String label;       
        @AuraEnabled public String fieldName;       
        @AuraEnabled public String  type; 
        @AuraEnabled public Boolean sortable;
        @AuraEnabled public Boolean editable;
        @AuraEnabled public TypeAttributesWrapper typeAttributes;
    }
    
    public class label{
        @AuraEnabled public String fieldName;        
    }
}