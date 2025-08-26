/*
* @Description : This class is used to merge sObject record; // Description should be more dynamic
* @author      : Vivek Kumar Saurabh
* @Created Date: 15/07/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 16/10/2024
*/
public class MergeSObject {     

     /*
	* @description : This method is used for get sObjectField Values.
	* @param : List<String> sObjectIds  sObjectIds list.
	* @return :List<FieldsValueWrapper>  return wrapperList which have some fieldLabel,fieldApiName,value,reqFied values.
	*/ 
    @AuraEnabled
    public static List<FieldsValueWrapper> getsObjectFieldsValues(List<String> sObjectIds){
        List<String> fields = new List<String>();
        List<String> opportunityIdsStrList = new List<String>();
        List<String> removeKeysInMap = new List<String>();
        List<String> requiredFieldsList = new List<String>();
        List<FieldsValueWrapper> FieldsValueWrapperList = new List<FieldsValueWrapper>();
        Map<String, List<String>> fieldsRecordMap = new Map<String, List<String>>();
        Map <String, Schema.SObjectType> SObjectMap = Schema.getGlobalDescribe();                     
        String objectName;
        try{
            if(!sObjectIds.isEmpty() && sObjectIds != NULL){
                for(String iteratreId : sObjectIds){
                    Id recordId = Id.valueOf(iteratreId);
                    Schema.SObjectType sObj = recordId.getsobjecttype();
                    objectName = String.valueOf(sObj);
                }
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
            if(!sObjectIds.isEmpty() && sObjectIds != NULL){
                for (String iterateOpportunityId : sObjectIds) {
                    opportunityIdsStrList.add('\'' + iterateOpportunityId + '\'');
                }
            }            
            String query = 'SELECT '+String.join(fields, ', ')+' FROM '+objectName+' WHERE Id IN '+opportunityIdsStrList;       
            for(sObject iterateRecords :  Database.Query(query)){
                for(String iterateField : fields){
                    List<String> records = new List<String>();
                    if(fieldsRecordMap.containskey(iterateField)){
                        records = fieldsRecordMap.get(iterateField);
                    }
                    records.add(String.valueOf(iterateRecords.get(iterateField)));                   
                    fieldsRecordMap.put(iterateField, records);                    
                }            
            }
            if(!fieldsRecordMap.isEmpty()){
                for(String iterateField : fieldsRecordMap.keySet()){
                    List<String> fieldRecordList =  fieldsRecordMap.get(iterateField);                
                    if(containsNullValue(fieldRecordList)){
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
                    createfieldValueWrapper.fieldValues =  fieldsRecordMap.get(iterateFieldRecord);
                    FieldsValueWrapperList.add(createfieldValueWrapper);
                    
                }
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('MergeSObject', 'getsObjectFieldsValues', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return FieldsValueWrapperList;
    }
    
    /*
	* @description : This method is used for containing null values then return false.
	* @param : List<String> recordList  record list have string values.
	* @return :Boolean  return true when list found null else false.
	*/ 
    public static Boolean containsNullValue(List<String> recordList) {
        try{
            for (String item : recordList) {
                if (item == null) {
                    return true; 
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('MergeSObject', 'containsNullValue', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return false; 
    }    
    
    /*
	* @description : This method is used for getting name of record.
	* @param : List<String> recordIds record id for getting their name.
	* @return :List<ChildObjectsWrapper> childObjectWrapper which is store list of child Object .
	*/ 
    @AuraEnabled
    public static List<SelectedRecordWrapper> retriveRecordName(List<String> recordIds){
        List<SelectedRecordWrapper> selectedRecordWrapperList  = new List<SelectedRecordWrapper>();
        String objectName;
        try{
            if(!recordIds.isEmpty()){
                for(String iterateRecordId : recordIds){
                    Id recordId = Id.valueOf(iterateRecordId);
                    Schema.SObjectType sObj = recordId.getsobjecttype();
                    objectName = String.valueOf(sObj);
                }
            }
            if(objectName != NULL){
                String subQuery = returnQueryWithName(objectName); 
                subQuery+=' WHERE Id IN :recordIds'; 
                for(sObject iterateSobjectRecrod : Database.query(subQuery)){
                    SelectedRecordWrapper createWrapper = new SelectedRecordWrapper();
                    String name;
                    if(iterateSobjectRecrod.getSObjectType().getDescribe().fields.getMap().containsKey('Name')){
                        name = String.valueOf(iterateSobjectRecrod.get('Name'));
                    }else{
                        name = String.valueOf(iterateSobjectRecrod.get('Id')); 
                    }            
                    createWrapper.recordName = name;
                    selectedRecordWrapperList.add(createWrapper);
                }
            }  
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('MergeSObject', 'retriveRecordName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return selectedRecordWrapperList;
    }
    
    /*
	* @description : This method is used for get child objects name.
	* @param : String objectName object name as a params.
	* @return :List<ChildObjectsWrapper> childObjectWrapper which is store list of child Object .
	*/ 
    @AuraEnabled(cacheable = true)
    public static List<ChildObjectsWrapper> getChildObject(String objectName){
        List<ChildObjectsWrapper> ChildObjectsWrapperList = new List<ChildObjectsWrapper>();       
        Map<String, String> objectLabelApiMap = new Map<String, String>();
        Map<String, Schema.SObjectType> schemaGlobalDescribeMap = Schema.getGlobalDescribe();
        try{
            if(schemaGlobalDescribeMap != NULL){
                for(String iterateObject: schemaGlobalDescribeMap.keyset()){
                    Schema.SObjectType objectToken=schemaGlobalDescribeMap.get(iterateObject);
                    if(iterateObject.equalsignorecase(objectName)){
                        Schema.DescribeSObjectResult objDescribe = objectToken.getdescribe();
                        List<Schema.ChildRelationship> childRelationshipList = objDescribe.getChildRelationships();
                        for(Schema.ChildRelationship iterateChildRelationship : childRelationshipList){
                            String childObjectName = String.valueof(iterateChildRelationship.getChildSObject());
                            if(iterateChildRelationship.getRelationshipName() != null && !objectLabelApiMap.keySet().contains(childObjectName)){
                                Schema.SObjectType convertType = Schema.getGlobalDescribe().get(childObjectName);
                                Schema.DescribeSObjectResult describeSObjectResult = convertType.getDescribe();
                                if(describeSObjectResult.isCreateable()){                        
                                    Schema.DescribeSObjectResult describe = Schema.getGlobalDescribe().get(childObjectName).getDescribe();
                                    objectLabelApiMap.put(childObjectName, String.valueOf(describe.getLabel()));
                                }
                            }
                        }                
                    }
                }
            }           
            if(!objectLabelApiMap.isEmpty()){
                for(String iteratechildObject : objectLabelApiMap.keySet()){
                    ChildObjectsWrapper createWrapper = new ChildObjectsWrapper();
                    createWrapper.label = objectLabelApiMap.get(iteratechildObject);
                    createWrapper.value = iterateChildObject;
                    ChildObjectsWrapperList.add(createWrapper);
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('MergeSObject', 'getChildObject', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return ChildObjectsWrapperList;        
    }
    
    /*
	* @description : This method is used for get child objects name.
	* @param : String objectName object name as a params.
	* @return :List<ChildObjectsWrapper> childObjectWrapper which is store list of child Object .
	*/ 
    @AuraEnabled
    public static Map<String, String> getChildObjectWithFieldRelation(String objectName){
        List<ChildObjectFieldApiWrapper> ChildObjectFieldApiWrapperList = new List<ChildObjectFieldApiWrapper>();      
        Map<String, String> childAPiRelationshipMap = new Map<String, String>();
        Map<String, Schema.SObjectType> schemaGlobalDescribeMap = Schema.getGlobalDescribe();
        try{
            if(schemaGlobalDescribeMap != NULL){
                for(String iterateObject: schemaGlobalDescribeMap.keyset()){                   
                    Schema.SObjectType objectToken=schemaGlobalDescribeMap.get(iterateObject);
                    if(iterateObject.equalsignorecase(objectName)){
                        Schema.DescribeSObjectResult objDescribe = objectToken.getdescribe();
                        List<Schema.ChildRelationship> childRelationshipList = objDescribe.getChildRelationships();
                        for(Schema.ChildRelationship iterateChildRelationship : childRelationshipList){
                            string childObjectName = string.valueof(iterateChildRelationship.getChildSObject());
                            if(iterateChildRelationship.getRelationshipName() != null && !childAPiRelationshipMap.keySet().contains(childObjectName)){
                                Schema.SObjectType convertType = Schema.getGlobalDescribe().get(childObjectName);
                                Schema.DescribeSObjectResult describeSObjectResult = convertType.getDescribe();
                                if(describeSObjectResult.isCreateable()){ 
                                    childAPiRelationshipMap.put(childObjectName, String.valueOf(iterateChildRelationship.getField()));
                                }
                            }
                            
                        }                
                    }
                }
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('MergeSObject', 'getChildObjectWithFieldRelation', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return childAPiRelationshipMap;   
    }
    
    
    /*
	* @description : This method is used for retrive record of selected child Object. 
	* @param : String parentObjectApiName, String childObjectApiName, String parentRecordId  this is use as a param for retrive record behalf of record Id.
	* @return : List<OpportunityWrapper> retrive record for merging their values.
	*/    
    @AuraEnabled
    public static List<OpportunityWrapper> queryChildRecords(String parentObjectApiName, String childObjectApiName, String parentRecordId) {
        String parentRelationshipField = '';
        List<OpportunityWrapper> opportunityWrapperList = new List<OpportunityWrapper>();
        try{
            if(childObjectApiName != NULL){        
                Schema.SObjectType childSObjectType = Schema.getGlobalDescribe().get(childObjectApiName);               
                Schema.DescribeSObjectResult childDescribeResult = childSObjectType.getDescribe();        
                Map<String, Schema.SObjectField> fields = childDescribeResult.fields.getMap();
                if(fields != NULL){
                    for (String fieldName : fields.keySet()) {
                        Schema.SObjectField field = fields.get(fieldName);
                        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                        if(String.valueOf(fieldDescribe.getReferenceTo()).contains(parentObjectApiName)){
                            parentRelationshipField = fieldName;
                            break;
                        }
                    }
                }
                if(parentRelationshipField != NULL && childObjectApiName != NULL){
                    String subQuery = returnQueryWithName(childObjectApiName);
                    subQuery+=' WHERE ' + parentRelationshipField + ' =:parentRecordId';
                    for (sObject iterateRecord : Database.query(subQuery)) {
                        OpportunityWrapper createWrapper = new OpportunityWrapper();
                        if(iterateRecord.getSObjectType().getDescribe().fields.getMap().containsKey('Name')){
                            createWrapper.label = String.valueOf(iterateRecord.get('Name'));
                        }else{
                            createWrapper.label = String.valueOf(iterateRecord.get('Id')); 
                        }   
                        createWrapper.value = String.valueOf(iterateRecord.get('Id'));
                        opportunityWrapperList.add(createWrapper);
                    }
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('MergeSObject', 'queryChildRecords', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return opportunityWrapperList;
    }    
    /*
	* @description : This method is used for create a record.
	* @param : String objectName, List<NewMergeRecord>  their are Json comes in list of Wrapper for create a record.
	* @return : N/A.
	*/  
    @AuraEnabled
    public static sObject createRecord(String objectName, List<NewMergeRecord> keyValueList){  
        SObject sobj;
        if(objectName != NULL){
            sobj = Schema.getGlobalDescribe().get(objectName).newSObject(); 
        }         
        try{
            if(!keyValueList.isEmpty() && keyValueList != NULL){
                for (NewMergeRecord iterateRecord : keyValueList) {
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
                Database.insert(sobj, false);
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('MergeSObject', 'createRecord', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return sobj;
    }
    
    /*
	* @description : This method is used for delete a record.	
	* @param : List<String> recordIds list of recordIds which is deleted.
	* @return : N/A.
	*/  
    @AuraEnabled
    public static List<sObject> deleteRecord(List<String> recordIds){       
        String objectName;
        List<SObject> sObjectMergeRecords = new List<sObject>();
        List<String> opportunityIdsStrList = new List<String>();
        try{ 
            if(!recordIds.isEmpty() && recordIds != NULL){
                for(String iteratreId : recordIds){
                    Id recordId = Id.valueOf(iteratreId);
                    Schema.SObjectType sObj = recordId.getsobjecttype();
                    objectName = String.valueOf(sObj);
                }
            }
            if(!recordIds.isEmpty() && recordIds != NULL){
                for (String iterateOpportunityId : recordIds) {
                    opportunityIdsStrList.add('\'' + iterateOpportunityId + '\'');
                }
            }
            if(objectName != NULL){            
                String query = 'SELECT Id FROM '+objectName+' WHERE Id IN '+opportunityIdsStrList;
                sObjectMergeRecords = Database.Query(query);            
                if(sObjectMergeRecords != NULL){
                    delete sObjectMergeRecords;
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('MergeSObject', 'deleteRecord', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return sObjectMergeRecords;        
    }
    
    /*
	* @description : This method is used for merge child Records in new merge record.
	* @param : String objectName  In objectName we send child ObjectName, List<String> recordIds  which we have selected from UI that recordId comes in this list, String mergeRecordId when we create merge new record with some choosable fields then we merge that value.
	* @return : N/A.
	*/
    @AuraEnabled
    public static List<ChildsRecordWrapper> mergeChildRecords(String objectName, List<String> recordIds, String mergeRecordId){
        List<ChildsRecordWrapper> childsRecordWrapperList = new List<ChildsRecordWrapper>();
        Map<String, Map<String, List<String>>> objectNameIdListMap = new Map<String, Map<String, List<String>>>();
        Map<String, String> childAPiRelationshipMap = getChildObjectWithFieldRelation(objectName);
        Map<String, String> recordIdRecordNameMap = new Map<String, String>(); 
        Map<String, List<String>> objectFieldListMap = new Map<String, List<String>>();
        Map <String, Schema.SObjectType> SObjectMap = Schema.getGlobalDescribe();
        if(objectName != NULL && !recordIds.isEmpty()){
            String subQuery = returnQueryWithName(objectName);
            subQuery+=' WHERE Id IN :recordIds';
            for(sObject iterateRecord : Database.query(subQuery)){
                if(iterateRecord != NULL){
                    if(iterateRecord.getSObjectType().getDescribe().fields.getMap().containsKey('Name')){
                        recordIdRecordNameMap.put(String.valueOf(iterateRecord.get('Id')), String.valueOf(iterateRecord.get('Name')));
                    }else{
                        recordIdRecordNameMap.put(String.valueOf(iterateRecord.get('Id')), String.valueOf(iterateRecord.get('Id')));
                    }
                }
            }
        }
        if(childAPiRelationshipMap != NULL){
            for(String iterateObject : childAPiRelationshipMap.keySet()){
                Map<String, Schema.SObjectField> sObjectfieldMap = SObjectMap.get(iterateObject).getDescribe().fields.getMap();  
                if(sObjectfieldMap != NULL){
                    List<String> fields = new List<String>();
                    for(String fieldName : sObjectfieldMap.keySet()) 
                    {
                        Schema.SObjectField field = sObjectfieldMap.get(fieldName);
                        Schema.DescribeFieldResult fieldResult = field.getDescribe();                   
                        if(fieldResult.getName() == 'UnitPrice' || fieldResult.getName() == 'RowCause' || fieldResult.getName() == 'AccountFromId'){
                            continue;
                        }else{
                            fields.add(fieldResult.getName());   
                        }
                    }
                    objectFieldListMap.put(iterateObject, fields);
                }
            }
        }
        List<sObject> sObjectRecordList = new List<sObject>();        
        if(childAPiRelationshipMap.size() <= 200 || childAPiRelationshipMap != NULL){
            for(String iterateObject : childAPiRelationshipMap.keySet()){
                List<String> fieldNameList = objectFieldListMap.get(iterateObject);                 
                String queryChildToParent = 'SELECT '+String.join(fieldNameList, ', ')+' FROM '+ iterateObject +' WHERE '+ childAPiRelationshipMap.get(iterateObject) + ' IN :recordIds LIMIT 50000'; 
                sObjectRecordList.addAll(Database.query(queryChildToParent));
            }
        }        
        List<sObject> updateRecord = new List<sObject>(); 
        if(!sObjectRecordList.isEmpty() && sObjectRecordList != NULL){
            for(sObject iterateSObject : sObjectRecordList){ 
                Schema.SObjectType sObj = iterateSObject.id.getsobjecttype();
                String childObjectName = String.valueOf(sObj);
                List<String> sObjectList = new List<String>();
                Map<String, List<String>> recordIdSobjectListMap = new Map<String, List<String>>();           
                String referenceApiName = childAPiRelationshipMap.get(childObjectName);
                String recordId = String.valueOf(iterateSObject.get(referenceApiName));
                if(objectNameIdListMap.containskey(childObjectName)){ 
                    recordIdSobjectListMap = objectNameIdListMap.get(childObjectName);
                    if(recordIdSobjectListMap.containsKey(recordIdRecordNameMap.get(recordId))){                   
                        sObjectList = recordIdSobjectListMap.get(recordIdRecordNameMap.get(recordId));                    
                    }     
                }
                String recordName;
                if(iterateSObject.getSObjectType().getDescribe().fields.getMap().containsKey('Name')){
                    recordName = String.valueOf(iterateSObject.get('Name'));
                }else{
                    recordName = String.valueOf(iterateSObject.get('Id')); 
                }
                sObjectList.add(recordName);
                recordIdSobjectListMap.put(recordIdRecordNameMap.get(recordId), sObjectList);
                objectNameIdListMap.put(childObjectName, recordIdSobjectListMap);              
                if(childObjectName == 'Partner'){
                    childObjectName = 'AccountPartner';
                }                
                SObject sobjectCreateNewInstance = Schema.getGlobalDescribe().get(childObjectName).newSObject();
                List<String> keyValueList = objectFieldListMap.get(childObjectName); 
                for (String iterateRecord : keyValueList) {
                    Schema.SObjectType objType = sobjectCreateNewInstance.getSObjectType();
                    Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
                    Schema.SObjectField field = fieldMap.get(iterateRecord);
                    Schema.DescribeFieldResult fieldResult = field.getDescribe();
                    Schema.DisplayType fieldType = field.getDescribe().getType();
                    if(fieldResult.isCreateable()){ 
                        if(childAPiRelationshipMap.get(childObjectName) == iterateRecord){
                            sobjectCreateNewInstance.put(iterateRecord, mergeRecordId);
                        }else{
                            switch on String.valueOF(fieldType) {
                                when 'BOOLEAN' {
                                    sobjectCreateNewInstance.put(iterateRecord, Boolean.valueOf(iterateSObject.get(iterateRecord)));
                                }
                                when 'DATE' { 
                                    sobjectCreateNewInstance.put(iterateRecord, Date.valueOf(iterateSObject.get(iterateRecord)));
                                }
                                when  'DOUBLE' {   
                                    sobjectCreateNewInstance.put(iterateRecord, Double.valueOf(iterateSObject.get(iterateRecord))); 
                                }
                                when 'DATETIME' {
                                    sobjectCreateNewInstance.put(iterateRecord, Datetime.valueOf(iterateSObject.get(iterateRecord)));
                                }
                                when 'PERCENT'{
                                    sobjectCreateNewInstance.put(iterateRecord, Double.valueOf(iterateSObject.get(iterateRecord)));
                                }
                                when 'CURRENCY'{
                                    sobjectCreateNewInstance.put(iterateRecord, Double.valueOf(iterateSObject.get(iterateRecord)));
                                }
                                When else{
                                    sobjectCreateNewInstance.put(iterateRecord, iterateSObject.get(iterateRecord));
                                }
                            }
                        }
                    }                
                }             
                updateRecord.add(sobjectCreateNewInstance);
            }
        }
        if(objectNameIdListMap != NULL){
            for(String iterateObjectName : objectNameIdListMap.keySet()){
                Map<String, List<String>> innerMap = objectNameIdListMap.get(iterateObjectName);
                ChildsRecordWrapper createWrapper = new ChildsRecordWrapper();
                List<RecordWrapper> recordWrapperList = new List<RecordWrapper>();
                createWrapper.childObjectName = iterateObjectName;
                for(String iterateRecordName : innerMap.keySet()){
                    RecordWrapper createInnerWrapper = new RecordWrapper();
                    createInnerWrapper.parentRecordName = iterateRecordName;
                    createInnerWrapper.records = innerMap.get(iterateRecordName);
                    recordWrapperList.add(createInnerWrapper);          
                }
                createWrapper.recordWrapper = recordWrapperList;
                childsRecordWrapperList.add(createWrapper); 
            }
        }
        try{
            if(!updateRecord.isEmpty()){
                Database.insert(updateRecord, false);
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('MergeSObject', 'mergeChildRecords', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return childsRecordWrapperList;
    }
    /*
	* @description : This method is used for return Query with Id and Name.
	* @param : String objectName  In objectName checked if their any field of name or not on that object.
	* @return : String return query of that object with Name and Id.
	*/ 
    public static String returnQueryWithName(String objectName){
        String query;
        try{
            query ='SELECT ';
            if(objectName != NULL){
                Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
                if(objType != NULL){
                    Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
                    String fieldName = 'Name';
                    if (fieldMap.containsKey(fieldName)) {
                        query += fieldName+', Id';
                    } else {
                        query += 'Id';
                    }
                    query += ' FROM ' + objectName;
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('MergeSObject', 'returnQueryWithName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return query;
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
                    if( desribeResult.isCreateable() && !desribeResult.isNillable() && !desribeResult.isDefaultedOnCreate())
                    {
                        reqFieldsList.add(String.valueOf(fieldsMap.get(iterateField)));
                    }
                }  
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('MergeSObject', 'getRequiredFields', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return reqFieldsList;
    }
    
    public class OpportunityWrapper{
        @AuraEnabled Public String label;
        @AuraEnabled Public String value;
    }
    
    public class ChildObjectsWrapper{
        @AuraEnabled Public String label;
        @AuraEnabled Public String value;
    }
    
    public class OpportunityDataWrapper{
        @AuraEnabled public String field;        
        @AuraEnabled public List<String> values;
    }
    
    public class SelectedRecord{
        @AuraEnabled Public String label;
        @AuraEnabled Public String value; 
    }
    
    public class NewMergeRecord {
        @AuraEnabled public String key {get;set;}
        @AuraEnabled public String value {get;set;}
    }
    
    public class ChildsRecordWrapper{
        @AuraEnabled Public String childObjectName;       
        @AuraEnabled Public List<RecordWrapper> recordWrapper;       
    }
    
    public class RecordWrapper{
        @AuraEnabled public String parentRecordName;
        @AuraEnabled public List<String> records;
    }
    
    public class ChildObjectFieldApiWrapper{
        @AuraEnabled public String childObjectNames;
        @AuraEnabled public String fieldAPiName;
        @AuraEnabled public String relationshipName;
    }
    
    public class FieldsValueWrapper{
        @AuraEnabled public String fieldName;
        @AuraEnabled public String fieldApiName;
        @AuraEnabled public Boolean reqField;
        @AuraEnabled public List<String> fieldValues;        
    }
    
    public class SelectedRecordWrapper{
        @AuraEnabled public String recordName;  
    }
    
}