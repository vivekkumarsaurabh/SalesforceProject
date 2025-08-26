/*
* @Description : This class is used for export data of permission set/permission set group and download in csv;
* @author      : Vivek Kumar Saurabh
* @Created Date: 25/11/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 25/11/2024
*/
public class DataExpoter {    
    
    /*
* @description : This method is used for retrive sObject name from configration.
* @param : N.A.
* @return : List<SobjectConfigrationWrapper> return sObjectName wrapper list for combo box.
*/
    @AuraEnabled
    public static List<SobjectConfigrationWrapper> getsObjectWithConfigration(){     
        List<SobjectConfigrationWrapper> createsObjectWrapperList = new List<SobjectConfigrationWrapper>();
        try{       
            for(DataExporterSobject__mdt iterateSobject : [SELECT Id, MasterLabel, DeveloperName FROM DataExporterSobject__mdt WHERE Id != NULL AND MasterLabel != NULL AND DeveloperName != NULL]){
                SobjectConfigrationWrapper createWrapper = new SobjectConfigrationWrapper();
                createWrapper.label = iterateSobject.MasterLabel;
                createWrapper.value = iterateSobject.DeveloperName;
                createsObjectWrapperList.add(createWrapper);
            }            
            if(!createsObjectWrapperList.isEmpty()){
                return createsObjectWrapperList;
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('DataExpoter', 'getsObjectWithConfigration', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return createsObjectWrapperList;  
    }
    
    /*
* @description : This method is used for getting all records .
* @param : sobjectName as a params.
* @return : List<sObject> return all sObject records data.
*/
    @AuraEnabled
    public static List<sObject> getAllData(String sobjectName){
        List<sObject> sObjectRecordList = new List<sObject>();        
        try{
            if(sobjectName != NULL){
                List<SobjectConfigrationWrapper> fieldNameWrapperList = getAllfields(sobjectName);
                List<String> fieldAPINameList = new List<String>();
                for(SobjectConfigrationWrapper iteratefieldApiName : fieldNameWrapperList){               
                   fieldAPINameList.add(iteratefieldApiName.value);
                }
                if(!fieldAPINameList.isEmpty()){
                    String query;
                    if(sobjectName == 'Group'){
                        query = 'SELECT '+String.join(fieldAPINameList, ',')+' FROM '+sobjectName+' WHERE Type = \'Regular\'';
                    }else{
                        query = 'SELECT '+String.join(fieldAPINameList, ',')+' FROM '+sobjectName;
                    }
                    System.debug('query--->'+query);
                    sObjectRecordList = Database.query(query);  
                }            
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('DataExpoter', 'getAllData', e.getMessage(), e.getStackTraceString(), e.getLineNumber());            
        }
        return sObjectRecordList;
    }
    
    /*
* @description : This method is used for getting all fields .
* @param : sobjectName as a params.
* @return : List<String> return all fields of sObject.
*/
    @AuraEnabled
    public static List<SobjectConfigrationWrapper> getAllfields(String sobjectName){
        List<SobjectConfigrationWrapper> fieldNameWrapperList = new List<SobjectConfigrationWrapper>();
        try{
            if(sobjectName != NULL){
                for(FieldDefinition iterateField : [SELECT DeveloperName, Label, QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName =:sobjectName]){
                    SobjectConfigrationWrapper createWrapper = new SobjectConfigrationWrapper();              
                     if(String.valueOf(iterateField.DeveloperName) == 'Permissions' || String.valueOf(iterateField.DeveloperName) == 'CreatedBy' || String.valueOf(iterateField.DeveloperName) == 'LastModifiedBy' || String.valueOf(iterateField.DeveloperName) == 'UserPreferences' || String.valueOf(iterateField.DeveloperName) == 'EmailPreferences' || String.valueOf(iterateField.DeveloperName) == 'NeedsNewPassword' || String.valueOf(iterateField.DeveloperName) == 'UserPermissions'){
                        continue;
                    }
                    else{
                         createWrapper.label = String.valueOf(iterateField.Label);
                         createWrapper.value = String.valueOf(iterateField.QualifiedApiName);
                    }
                    fieldNameWrapperList.add(createWrapper);
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('DataExpoter', 'getAllfields', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }        
        return fieldNameWrapperList;
    }
    
    public class SobjectConfigrationWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
}