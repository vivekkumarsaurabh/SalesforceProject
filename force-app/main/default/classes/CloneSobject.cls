/*
* @Description : This class is used to clone sObject;
* @author      : Vivek Kumar Saurabh
* @Created Date: 09/12/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 09/12/2024 
*/
public class CloneSobject {
    
    /*
* @description : This method is used for retrive all public group.
* @param : N.A.
* @return : List<GroupWrapper> return public group wrapper list for combo box.
*/  
    @AuraEnabled
    public static List<FieldsValueWrapper> getsObjectFieldsValues(String sObjectIds){
        List<String> fields = new List<String>();
        List<String> removeKeysInMap = new List<String>();
        List<String> requiredFieldsList = new List<String>();
        List<FieldsValueWrapper> FieldsValueWrapperList = new List<FieldsValueWrapper>();
        Map<String, String> fieldsRecordMap = new Map<String, String>();
        Map <String, Schema.SObjectType> SObjectMap = Schema.getGlobalDescribe();                     
        String objectName;
        try{
            if( sObjectIds != NULL){
                Id recordId = Id.valueOf(sObjectIds);
                Schema.SObjectType sObj = recordId.getsobjecttype();
                objectName = String.valueOf(sObj);
            }
            if(objectName != NULL){             
                requiredFieldsList = getRequiredFields(objectName);   
            }
            Map<String, Schema.SObjectField> sObjectfieldMap = SObjectMap.get(objectName).getDescribe().fields.getMap();  
            if(sObjectfieldMap != NULL){
                for(String fieldName : sObjectfieldMap.keySet()) 
                {
                    Schema.SObjectField field = sObjectfieldMap.get(fieldName);
                    Schema.DescribeFieldResult fieldResult = field.getDescribe();
                    if(fieldResult.isCreateable() && fieldResult.isUpdateable()){
                        fields.add(fieldResult.getName());
                    }
                }
            }          
            String query = 'SELECT '+String.join(fields, ', ')+' FROM '+objectName+' WHERE Id = :sObjectIds ';       
            for(sObject iterateRecords :  Database.Query(query)){
                for(String iterateField : fields){                                     
                    fieldsRecordMap.put(iterateField, String.valueOf(iterateRecords.get(iterateField)));                    
                }            
            }
            if(!fieldsRecordMap.isEmpty()){
                for(String iterateField : fieldsRecordMap.keySet()){
                    String fieldRecord =  fieldsRecordMap.get(iterateField);                
                    if(containsNullValue(fieldRecord)){
                        removeKeysInMap.add(iterateField);
                    }
                }
            }
            if(!removeKeysInMap.isEmpty()){
                for(String iterateKey : removeKeysInMap){
                    fieldsRecordMap.remove(iterateKey);
                }
            }
            if(!fieldsRecordMap.isEmpty()){
                for(String iterateFieldRecord : fieldsRecordMap.keySet()){
                    Schema.DescribeFieldResult fieldResult = sObjectfieldMap.get(iterateFieldRecord).getDescribe(); 
                    FieldsValueWrapper createfieldValueWrapper = new FieldsValueWrapper();
                    createfieldValueWrapper.fieldName = String.valueOf(fieldResult.getLabel());
                    createfieldValueWrapper.fieldApiName = iterateFieldRecord; 
                    if(requiredFieldsList.contains(iterateFieldRecord)){
                        createfieldValueWrapper.reqField = true; 
                    }else{
                        createfieldValueWrapper.reqField = false;  
                    }
                    createfieldValueWrapper.fieldValue =  fieldsRecordMap.get(iterateFieldRecord);
                    FieldsValueWrapperList.add(createfieldValueWrapper);
                    
                }
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CloneSobject', 'getsObjectFieldsValues', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return FieldsValueWrapperList;
    }
    
    /*
* @description : This method is used for getting required fields of SObject.
* @param : String objectName  In objectName getting sObject Name.
* @return : List<String> return all required fields of sObjects.
*/ 
    @AuraEnabled
    public static List<String> getRequiredFields(String objectName){     
        List<String> reqFieldsList = new List<String>();
        try{
            if(objectName != NULL){
                Map<String, Schema.SObjectType> sObjectGlobalDescribeMap  = Schema.getGlobalDescribe() ;
                Schema.SObjectType sObjectTypeSchema = sObjectGlobalDescribeMap.get(objectName) ;
                Schema.DescribeSObjectResult describeSObjectResult = sObjectTypeSchema.getDescribe() ;
                Map<String,Schema.SObjectField> fieldsMap = describeSObjectResult.fields.getMap() ;   
                for(String iterateField : fieldsMap.keyset())
                {
                    Schema.DescribeFieldResult desribeResult = fieldsMap.get(iterateField).getDescribe();
                    if(desribeResult.isCreateable() && !desribeResult.isNillable() && !desribeResult.isDefaultedOnCreate())
                    {
                        reqFieldsList.add(String.valueOf(fieldsMap.get(iterateField)));
                    }
                }  
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CloneSobject', 'getRequiredFields', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return reqFieldsList;
    }
    
    /*
* @description : This method is used for containing null values then return false.
* @param : List<String> recordList  record list have string values.
* @return :Boolean  return true when list found null else false.
*/ 
    public static Boolean containsNullValue(String record) {
        try{
            if (record == null) {
                return true; 
            }
            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CloneSobject', 'containsNullValue', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return false; 
    }   
    
    
    /*
* @description : This method is used for create a record.
* @param : String objectName, List<NewMergeRecord>  their are Json comes in list of Wrapper for create a record.
* @return : N/A.
*/  
    @AuraEnabled
    public static String createRecord(String objectName, List<NewCloneRecord> keyValueList){  
        SObject sobj;
        String sObjectDetails;
        if(objectName != NULL){
            sobj = Schema.getGlobalDescribe().get(objectName).newSObject(); 
        }         
        try{
            if(!keyValueList.isEmpty() && keyValueList != NULL){
                for (NewCloneRecord iterateRecord : keyValueList) {
                    Schema.SObjectType objType = sobj.getSObjectType();
                    Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
                    Schema.SObjectField field = fieldMap.get(iterateRecord.key);
                    Schema.DisplayType fieldType = field.getDescribe().getType();
                    switch on String.valueOF(fieldType) {
                        when 'BOOLEAN' {
                            sobj.put(iterateRecord.key, Boolean.valueOf(iterateRecord.value));                               
                        }                        
                        when 'DATE' { 
                            sobj.put(iterateRecord.key, Date.valueOf(iterateRecord.value.split(' ')[0]));                
                        }
                        when 'PERCENT','DOUBLE','CURRENCY' {   
                            sobj.put(iterateRecord.key, Double.valueOf(iterateRecord.value)); 
                        }
                        when 'DATETIME' {
                            sobj.put(iterateRecord.key, Datetime.valueOf(iterateRecord.value));                
                        }
                        When  else{
                            sobj.put(iterateRecord.key, iterateRecord.value);
                        }  
                    }
                }
            }
            if(sobj != NULL){
                insert sobj;
                return String.valueOf(sobj);
              //  Database.insert(sobj, false);
            }
        }catch(Exception e){
            sObjectDetails = String.valueOf(e.getMessage());            
            ExceptionHandlingClass.exceptionLogRecords('CloneSobject', 'createRecord', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return sObjectDetails;
    }
    
        /*
* @description : This method is used for return label Name of sObjectApiName.
* @param : String sObjectApiName sObjectApiName as input.
* @return : String label name of sObject.
*/  
    @AuraEnabled
    public static String sObjectLabelName(String sObjectApiName){
        String sObjectLabel;
        Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();
        try{
            if(sObjectApiName != NULL){
                if (!sObjectMap.get(sObjectApiName).getDescribe().getName().endsWith('__c')) {
                    sObjectLabel = String.valueOf(sObjectMap.get(sObjectApiName.replaceAll('\\s+', '')).getDescribe().getLabel());
                } else {
                    sObjectLabel =  String.valueOf(sObjectMap.get(sObjectApiName).getDescribe().getLabel());
                }
                return sObjectLabel;                
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CloneSobject', 'sObjectLabelName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            
        }
        return sObjectLabel;
    }
    
    public class NewCloneRecord {
        @AuraEnabled public String key {get;set;}
        @AuraEnabled public String value {get;set;}
    }
    
    
    public class FieldsValueWrapper{
        @AuraEnabled public String fieldName;
        @AuraEnabled public String fieldApiName;
        @AuraEnabled public Boolean reqField;
        @AuraEnabled public String fieldValue;        
    }
}