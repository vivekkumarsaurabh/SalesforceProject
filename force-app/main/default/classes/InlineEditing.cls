/*
* @Description : This class is used to Inline editing record;
* @author      : Vivek Kumar Saurabh
* @Created Date: 30/07/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 27/11/2024 
*/
public class InlineEditing {   
    
    public static List<Inline_Object_Mapping__mdt> inlineEditingObjectMappingList = [SELECT Id, MasterLabel, ObjectApiName__c FROM Inline_Object_Mapping__mdt WHERE Id != NULL AND MasterLabel != NULL AND ObjectApiName__c != NULL];
    public static List<Object_Configration__mdt> inlineEditingObjectList = [SELECT Id, MasterLabel, QualifiedApiName FROM Object_Configration__mdt WHERE Id != NULL AND MasterLabel != NULL AND QualifiedApiName != NULL];
    
    /*
* @description : This method is used for retrive sObject name from configration.
* @param : N.A.
* @return : List<ObjectWrappar> return sObjectName wrapper list for combo box.
*/  
    @AuraEnabled
    public static List<ObjectWrappar> retriveSobjectName(){
        List<ObjectWrappar> objectWrapperList = new List<ObjectWrappar>();
        Map<String, Schema.SObjectType> SObjectMap = Schema.getGlobalDescribe();
        try{
            if(!inlineEditingObjectMappingList.isEmpty()){
                for(Inline_Object_Mapping__mdt iterateSObject : inlineEditingObjectMappingList){
                    if(SObjectMap.containskey(iterateSObject.ObjectApiName__c)){
                        Schema.DescribeSObjectResult describeSObject = Schema.getGlobalDescribe().get(iterateSObject.ObjectApiName__c).getDescribe();
                        ObjectWrappar createSObjectWrapper = new ObjectWrappar();
                        createSObjectWrapper.label = String.valueOf(describeSObject.getLabel());
                        createSObjectWrapper.value = String.valueOf(iterateSObject.Id);  
                        objectWrapperList.add(createSObjectWrapper);                                                       
                    }
                }                
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'retriveSobjectName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return objectWrapperList;
    }    
    
    /*
* @description : This method is used for retrive sObject API Name with sObjectId.
* @param : String recordId retrive record behalf of sObjectRecordId.
* @return : String  return sObject API Name.
*/ 
    @AuraEnabled
    public Static String getsObjectApiName(String sobjectId){
        String sObjectApiName;
        try{
            if(sobjectId != NULL){
                Inline_Object_Mapping__mdt objectName =  [SELECT Id, MasterLabel, ObjectApiName__c FROM Inline_Object_Mapping__mdt WHERE Id = :sobjectId AND MasterLabel != NULL AND ObjectApiName__c != NULL LIMIT 1];  
                if(objectName != NULL){
                    Schema.DescribeSObjectResult describeSObject = Schema.getGlobalDescribe().get(objectName.ObjectApiName__c).getDescribe(); 
                    sObjectApiName = String.valueOf(describeSObject.getName());
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'getsObjectApiName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return sObjectApiName;
    }
    
    /*
* @description : This method is used for retrive column.
* @param : String recordId retrive record behalf of sObjectRecordId.
* @return : List<ColumnWrapper> return sObjectColumn Wrapper.
*/ 
    @AuraEnabled
    public static List<ColumnWrapper> getColumns(String sobjectId){
        List<ColumnWrapper> accWrapperList = new List<ColumnWrapper>();
        try{
            for(Inline_Fields__mdt iterateRec : [SELECT Id, Label, field_Api_Name__c, Type__c, Sortable__c, editable__c, Sequence__c, Visible__c FROM Inline_Fields__mdt WHERE Inline_Object_Mapping__c =:sobjectId AND Label != NULL AND field_Api_Name__c != NULL AND Type__c != NULL]){
                if(iterateRec != NULL && iterateRec.Visible__c){
                    ColumnWrapper createWrapper = new ColumnWrapper();                               
                    createWrapper.label = iterateRec.Label;
                    createWrapper.fieldName = iterateRec.field_Api_Name__c;
                    createWrapper.type = iterateRec.Type__c;
                    createWrapper.sortable = iterateRec.Sortable__c; 
                    createWrapper.editable = iterateRec.editable__c;                   
                    createWrapper.required = Schema.getGlobalDescribe().get(getsObjectApiName(sobjectId)).getDescribe().fields.getMap().get(iterateRec.field_Api_Name__c).getDescribe().isNillable() == false ? true : false;
                    createWrapper.sequence = Integer.valueOf(iterateRec.Sequence__c);
                    accWrapperList.add(createWrapper);
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'getColumns', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return accWrapperList;
    }
    
    /*
* @description : This method is used for retrive record of sObject.
* @param : String sObjectConfigurationId (), String parentRecordId (parent record ID ), String sObjectName (from getting data with using sObjectName), String parentObjectName (parent objectname).
* @return : N/A.
*/
    @AuraEnabled
    public static List<sObject> getData(String sObjectConfigurationId, String parentRecordId, String sObjectName, String parentObjectName, String filterFieldName){
        List<sObject> sObjectRecordList = new List<sObject>();
        try{
            if(parentObjectName != NULL && parentRecordId != NULL && sObjectName != NULL){
                Map<String, String> childObjectFieldRelationMap = getChildObjectWithFieldRelation(parentObjectName);
                List<String> requiredFieldList = new List<String>();
                for(FieldWrapper iterate : getRequiredFields(sObjectName)){
                    requiredFieldList.add(iterate.value);
                }                
                String query = 'SELECT  Id, '+String.join(requiredFieldList, ', ')+' FROM '+sObjectName+' WHERE '+childObjectFieldRelationMap.get(sObjectName)+' =:parentRecordId';
                sObjectrecordList = Database.query(query);
            }else if(sObjectConfigurationId != NULL && sObjectName != NULL){
                List<String> sObjectfieldList = returnfields(sObjectConfigurationId, sObjectName);
                String query;
                if(filterFieldName != NULL){
                    FieldFilterWrapper filterwrapper = (FieldFilterWrapper) JSON.deserialize(filterFieldName, FieldFilterWrapper.class);
                    query = 'SELECT  Id, '+String.join(sObjectfieldList, ', ')+' FROM '+sObjectName+ ' ORDER BY '+filterwrapper.fieldName+' '+filterwrapper.filter; 
                }else{
                    query = 'SELECT  Id, '+String.join(sObjectfieldList, ', ')+' FROM '+sObjectName;
                }
                sObjectrecordList = Database.query(query);
            }    
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'getData', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }       
        return sObjectRecordList;
    }
    
    /*
* @description : This method is used for retrive record of sObject.
* @param : String sobjectId  retrive data behalf of sObjectId, String sObjectApiName for dynamically data retrive then we use sObjectAPI Name.
* @return : N/A.
*/ 
    /** @AuraEnabled
public static List<sObject> getData(String sobjectId, String sObjectName, String parentRecordId, String parentObject, List<String> filterList, String operator){
List<sObject> sObjectrecordList = new List<sObject>(); 
try{
if(parentObject != NULL){
Map<String, String> childObjectFieldRelationMap = getChildObjectWithFieldRelation(parentObject);
List<String> sObjectfieldList = returnfields(sobjectId, sObjectName);
if(filterList.isEmpty() && operator == NULL){
if(!sObjectfieldList.isEmpty() && sObjectName != NULL && parentRecordId != NULL && sobjectId != NULL){      
String query = 'SELECT  Id, '+String.join(sObjectfieldList, ', ')+' FROM '+sObjectName+' WHERE '+childObjectFieldRelationMap.get(sObjectName)+' =:parentRecordId';                         
sObjectrecordList = Database.query(query);
}
}else{
if(!sObjectfieldList.isEmpty() && sObjectName != NULL && parentRecordId != NULL && sobjectId != NULL){          
String query = 'SELECT  Id, '+String.join(sObjectfieldList, ', ')+' FROM '+sObjectName+' WHERE '+childObjectFieldRelationMap.get(sObjectName)+' =:parentRecordId  ORDER BY '+String.join(filterList, ', ')+' '+operator;                   
sObjectrecordList = Database.query(query);
}  
}
}
}catch(Exception e){
ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'getData', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
}  
return sObjectrecordList;
}**/
    
    /*
* @description : This method is used for return Fields list from configration.
* @param : String sobjectId params as sOBjectId of configration, String sObjectName param as sObjectApiName.
* @return : List<String> returns fields name list.
*/ 
    @AuraEnabled
    public static List<String> returnfields(String sobjectId, String sObjectName){
        List<String> sObjectFieldList = new List<String>();
        try{
            if(sobjectId != NULL){
                for(Inline_Fields__mdt iterateField : [SELECT Id, field_Api_Name__c, Visible__c FROM Inline_Fields__mdt WHERE Inline_Object_Mapping__c =:sobjectId AND field_Api_Name__c != NULL]){
                    if(iterateField.Visible__c){
                        sObjectFieldList.add(iterateField.field_Api_Name__c);
                    }
                }
            }            
            if(!sObjectFieldList.isEmpty()){
                return sObjectFieldList;
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'returnfields', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return sObjectFieldList;       
    }
    
    /*
* @description : This method is used for objectIcon.
* @param : String objectName (sObjectAPIName to take dynamically object Icon). // What is the param  explain in details.
* @return : String (return dynamically icon). // What it will return explain
*/
    @AuraEnabled
    public static String objectIconMethod(String objectName){
        String iconName;  
        try{
            if(objectName != NULL){
                Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
                Schema.SObjectType objToken = globalDescribe.get(objectName);
                if(objToken != NULL){
                    if(objToken.getDescribe().isCustom()){
                        iconName = System.Label.CustomIcon;
                    }else{
                        iconName = System.Label.StandardIcon+objectName.toLowerCase();
                    }
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ObjectHistoryTracking', 'objectIconMethod', e.getMessage(), e.getStackTraceString(), e.getLineNumber()); 
        }
        return iconName;
    }
    
    /*
* @description : This method is used for return Object Label Name using schema.
* @param : String objApiName (sObjectApi to take label of sObject).   
* @return : String (return Label of sObject Api).             
*/
    @AuraEnabled
    public static String returnObjectLabelName(String objApiName){
        String labelName;
        try{
            if(objApiName != NULL){      
                labelName = Schema.getGlobalDescribe().get(objApiName).getDescribe().getLabel();
            }         
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ObjectHistoryTracking', 'returnObjectLabelName', e.getMessage(), e.getStackTraceString(), e.getLineNumber()); 
        }
        return labelName;
    }
    
    /*
* @description : This method is search behalf of Search key.
* @param : String searchVal.
* @return : List<Account>.
*/
    /**  @AuraEnabled(cacheable=true)
public static List<sObject> searchKey(String searchVal, String sObjectName, String sObjectId, String parentRecordId, String parentObject){
List<sObject> sObejctList = new List<sObject>();
List<String> fieldList = new List<String>();
try{
if(sObjectId != NULL && sObjectName != NULL){
fieldList = returnfields(sObjectId, sObjectName);
}
Map<String, String> childObjectFieldRelationMap = getChildObjectWithFieldRelation(parentObject);
if(searchVal == null || String.isBlank(searchVal)){
return NULL;
}
if(searchVal != NULL && !fieldList.isEmpty() && sObjectName != NULL){
String searckKey = '%'+searchVal+'%';
String query = 'SELECT '+String.join(fieldList,',')+' FROM '+sObjectName+' WHERE LastName LIKE :searckKey AND '+childObjectFieldRelationMap.get(sObjectName)+'=:parentRecordId';
sObejctList = Database.query(query);
}
}catch(Exception e){
ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'searchKey', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
}  
return sObejctList;
}**/
    
    /*
* @description : This method is delete Accounts records.
* @param : String recId.
* @return : N/A.
*/
    @AuraEnabled
    public static List<sObject> deletesObjectRecord(String recordId, String objectName){       
        List<sObject> sObjectList = new List<sObject>();
        try{
            if(objectName != NULL &&  recordId != NULL){
                String query = 'SELECT Id FROM '+objectName+' WHERE Id =:recordId';
                sObjectList = Database.query(query);           
            }            
            if(!sObjectList.isEmpty()){
                Delete sObjectList;
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'deletesObjectRecord', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        
        return sObjectList;
    }
    
    /*
* @description : This method is use for updateSObjectRecords.
* @param : String data.
* @return : String.
*/
    @AuraEnabled
    public static List<sObject> updatesObjectRecord(String data) {
        List<sObject> sObjectRecords = new List<sObject>();
        if(data != NULL && !String.isEmpty(data)){
            sObjectRecords = (List<sObject>) JSON.deserialize(data, List<sObject>.class);
        }
        try {
            if(!sObjectRecords.isEmpty()){
                update sObjectRecords; 
            }           
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'updatesObjectRecord', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return sObjectRecords;
    }
    
    /*
* @description : This method is used for get all field from configration for filter field.
* @param : String sobjectId sObject record Id.
* @return : List<FieldWrapper> return wrapper value with label and value for dual list box.
*/
    /**   @AuraEnabled
public static List<FieldWrapper> getAllFields(String sobjectId){
List<FieldWrapper> FieldWrapperList = new List<FieldWrapper>();
try{
if(sobjectId != NULL){
for(Inline_Fields__mdt iterateField : [SELECT Id, label, fieldName__c, Object_Configration__c FROM Inline_Fields__mdt WHERE Object_Configration__c =:sobjectId AND Id != NULL AND label != NULL]){
FieldWrapper createWrapper = new FieldWrapper();
createWrapper.label = iterateField.label;
createWrapper.value = iterateField.fieldName__c;
FieldWrapperList.add(createWrapper);                
}
}
}catch(Exception e){
ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'getAllFields', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
}  
return FieldWrapperList;
}**/
    
    /*
* @description : This method is used for get child objects name.
* @param : String objectName object name as a params.
* @return :List<ChildObjectsWrapper> childObjectWrapper which is store list of child Object .
*/ 
    @AuraEnabled
    public static Map<String, String> getChildObjectWithFieldRelation(String objectName){             
        Map<String, String> childAPiRelationshipMap = new Map<String, String>();
        Map<String, Schema.SObjectType> schemaGlobalDescribeMap = Schema.getGlobalDescribe();
        try{
            if(schemaGlobalDescribeMap != NULL){
                for(String iterateObject: schemaGlobalDescribeMap.keyset()){                   
                    Schema.SObjectType objectToken = schemaGlobalDescribeMap.get(iterateObject);
                    if(iterateObject.equalsignorecase(objectName)){
                        Schema.DescribeSObjectResult objDescribe = objectToken.getdescribe();
                        List<Schema.ChildRelationship> childRelationshipList = objDescribe.getChildRelationships();
                        for(Schema.ChildRelationship iterateChildRelationship : childRelationshipList){
                            String childObjectName = String.valueof(iterateChildRelationship.getChildSObject());
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
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'getChildObjectWithFieldRelation', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return childAPiRelationshipMap;   
    }
    /*
* @description : This method is used for getting object childs.
* @param : String parentsObjectName parentsObjectName is as a params, String childsObjectName childsObject is as a param .
* @return : List<SChildObjectWrapper> return all sObject wrapper list.
*/ 
    /**  @AuraEnabled
public static List<SChildObjectWrapper> getsObjectChilds(String parentsObjectName, String childsObjectName){
Map<String, String> parentsObjectMap = getChildObjectWithFieldRelation(parentsObjectName);
Map<String, String> childsObjectMap = getChildObjectWithFieldRelation(childsObjectName);
Map<String, Schema.SObjectType> SObjectMap = Schema.getGlobalDescribe();
List<SChildObjectWrapper> sChildObjectWrapperList = new List<SChildObjectWrapper>();
Map<String, String> newCopidMap = new Map<String, String>();
try{
if(parentsObjectMap != NULL && childsObjectMap != NULL){
for(String iterateMap :  parentsObjectMap.keySet()){
if(childsObjectMap.containsKey(iterateMap) && parentsObjectMap.containskey(iterateMap)){
Schema.DescribeSObjectResult describeSObject = Schema.getGlobalDescribe().get(iterateMap).getDescribe();
SChildObjectWrapper createWrapper = new SChildObjectWrapper();
createWrapper.label = String.valueOf(describeSObject.getLabel());
createWrapper.value = iterateMap;
sChildObjectWrapperList.add(createWrapper);                
}
} 
}
}catch(Exception e){
ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'getsObjectChilds', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
} 
return sChildObjectWrapperList;
}**/
    
    /*
* @description : This method is used for getting records of sObject.
* @param : String schildObjectName, String parentsObjectName, String parentrecordId, String childsObjectName, String childRecordId.
* @return : List<sObject> return all sObject records.
*/
   /** @AuraEnabled
    public static List<sObject> returnRecords(String schildObjectName, String parentsObjectName, String parentrecordId, String childsObjectName, String childRecordId){
        Map<String, String> parentsObjectMap = getChildObjectWithFieldRelation(parentsObjectName);
        Map<String, String> childsObjectMap = getChildObjectWithFieldRelation(childsObjectName);
        List<String> reqFieldList = new List<String>();        
        List<sObject> sObejctList = new List<sObject>();
        if(schildObjectName != NULL){        
            for(FieldWrapper iterate : getRequiredFields(schildObjectName)){
                reqFieldList.add(iterate.value);
            }
        }
        try{
            if(!reqFieldList.isEmpty() && schildObjectName != NULL && parentsObjectMap != NULL && childsObjectMap != NULL){
                String query = 'SELECT Id,'+String.join(reqFieldList, ',')+' FROM '+schildObjectName+' WHERE '+parentsObjectMap.get(schildObjectName)+' =:parentrecordId AND '+childsObjectMap.get(schildObjectName)+' =:childRecordId';
                sObejctList = Database.query(query);
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'returnRecords', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        } 
        return sObejctList;
    }**/
    
    /*
* @description : This method is used for getting required fields of SObject.
* @param : String objectName  In objectName getting sObject Name.
* @return : List<String> return all required fields of sObjects.
*/ 
    @AuraEnabled
    public static List<FieldWrapper> getRequiredFields(String objectName){ 
        List<FieldWrapper> FieldWrapperList = new List<FieldWrapper>();
        Map<String, Schema.SObjectType> sObjectGlobalDescribeMap  = Schema.getGlobalDescribe();
        try{
            if(objectName != NULL){
                Map<String, Schema.SObjectField> fieldsMap = sObjectGlobalDescribeMap.get(objectName).getDescribe().fields.getMap();        
                for(String iterateField : fieldsMap.keyset())
                {
                    Schema.DescribeFieldResult desribeResult = fieldsMap.get(iterateField).getDescribe();                  
                    if(!desribeResult.isNillable() && desribeResult.isCreateable()){
                        FieldWrapper createWrapper = new FieldWrapper();
                        createWrapper.label = desribeResult.getLabel();
                        createWrapper.value = desribeResult.getName();
                        FieldWrapperList.add(createWrapper);
                    }
                }  
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'getRequiredFields', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return FieldWrapperList;
    }
    
    /*
* @description : This method is used for return Record Name behalf of recordId.
* @param : String recordId  In recordId we use different record Ids in param.
* @return : String return record Name behalf of record Id.
*/  
 /**   @AuraEnabled
    public static String returnRecordName(String recordId){
        String name;
        String objectName;
        try{
            if(recordId != NULL){
                Id recordIds = Id.valueOf(recordId);
                Schema.SObjectType sObj = recordIds.getsobjecttype();
                objectName = String.valueOf(sObj);               
            }
            if(objectName != NULL){
                String subQuery = returnQueryWithName(objectName);
                subQuery+=' WHERE Id = :recordId LIMIT 1'; 
                if(subQuery != NULL){
                    sObject record = Database.query(subQuery);                    
                    if(record != NULL){
                        if(record.getSObjectType().getDescribe().fields.getMap().containsKey('Name')){
                            name = String.valueOf(record.get('Name'));
                        }else{
                            name = String.valueOf(record.get('Id')); 
                        }
                    }
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'returnRecordName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }        
        return name;
    }**/
    
    /*
* @description : This method is used for return Query with Id and Name.
* @param : String objectName  In objectName checked if their any field of name or not on that object.
* @return : String return query of that object with Name and Id.
*/ 
   /** @AuraEnabled
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
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'returnQueryWithName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return query;
    }**/
    
    /*
* @description : This method is used filter data behalf on date.
* @param : String sObjectName as params which is select from configration, String parentRecordId where component drop their recordId, String sobjectId configration sObject Id as a params.
* @return : List<sObject> return sObject record list.
*/ 
    /**   @AuraEnabled
public static List<DataWrapper> filterByDate(String sObjectName, String parentRecordId, String sobjectId, String parentObject){
List<DataWrapper> dataWrapperList = new List<DataWrapper>();
Map<String, List<sObject>> datefilterMap = new Map<String, List<sObject>>();
try{
if(sObjectName != NULL){
Map<String, String> childObjectFieldRelationMap = getChildObjectWithFieldRelation(parentObject);
List<String> sObjectfieldList = returnfields(sobjectId, sObjectName);               
if(!sObjectfieldList.isEmpty() && sObjectName != NULL && parentRecordId != NULL && sobjectId != NULL){          
String filterQuery = 'SELECT  Id, '+String.join(sObjectfieldList, ', ')+' FROM '+sObjectName+' WHERE '+childObjectFieldRelationMap.get(sObjectName)+' =:parentRecordId';                  
System.debug('filterQuery------>'+filterQuery);
if(sObjectfieldList.contains('CreatedDate')){
for(sObject iteratesObject : Database.query(filterQuery)){
List<sObject> sObjectrecordList = new List<sObject>(); 
String createdDate = String.valueOf(iteratesObject.get('CreatedDate'));
DateTime resultDateTime = DateTime.ValueofGmt(createdDate.replace('T', ' '));
String key = String.valueOf(resultDateTime).split(' ')[0];
if(datefilterMap.containsKey(key)){
sObjectrecordList = datefilterMap.get(key);
}
sObjectrecordList.add(iteratesObject);
datefilterMap.put(key, sObjectrecordList);
}
}
}  
}
System.debug('datefilterMap---->'+datefilterMap);
if(datefilterMap != NULL){
for(String iterateKey : datefilterMap.keySet()){
DataWrapper createDateWrapper = new DataWrapper();
createDateWrapper.createDate = iterateKey;
createDateWrapper.filterdataList = datefilterMap.get(iterateKey);
dataWrapperList.add(createDateWrapper);
}
}            
}catch(Exception e){
ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'filterByDate', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
}  
return dataWrapperList;  
} 
**/
    
    /*
* @description : This method is used getting all child wrapper.
* @param : String recordId  (recordId of selected record), String sObjectName (sObjectName of child object), String parentSobjectName (which is parent of the record).
* @return : ChildRecordWrapper return wrapper record .
*/ 
    @AuraEnabled
    public static ChildRecordWrapper getAllChildRecord(String recordId, String sObjectName, String parentSobjectName){
        List<sObject> childRecords = getData(NULL, recordId, sObjectName, parentSobjectName, NULL);
        List<ColumnWrapper> columnWrapperList =  new List<ColumnWrapper>();
        ChildRecordWrapper createChildRecordWrapper = new ChildRecordWrapper();
        try{
            for(FieldWrapper iterate : getRequiredFields(sObjectName)){
                ColumnWrapper createColumnWrapper = new ColumnWrapper();
                createColumnWrapper.label = iterate.label;
                createColumnWrapper.required = true;
                createColumnWrapper.fieldName = iterate.value;
                createColumnWrapper.sortable = true;   
                createColumnWrapper.type = 'text';
                createColumnWrapper.editable = true;
                columnWrapperList.add(createColumnWrapper);   
            }
            createChildRecordWrapper.column = columnWrapperList;
            createChildRecordWrapper.data = childRecords;
            createChildRecordWrapper.objectName = sObjectName;
            createChildRecordWrapper.icon = objectIconMethod(sObjectName);
            createChildRecordWrapper.total = childRecords.size();
            if(childRecords.size()  > 4){
                createChildRecordWrapper.count = '4+';  
            }else{
                createChildRecordWrapper.count = String.valueOf(childRecords.size());                
            }           
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'getAllChildRecord', e.getMessage(), e.getStackTraceString(), e.getLineNumber());           
        }
        return createChildRecordWrapper;
    }    
    
    /*
* @description : This method is used getting all related object.
* @param : String objectName  (objectName is configuration ).
* @return : List<String> childs list .
*/ 
    
    @AuraEnabled
    public static List<String> getAllRelatedObject(String objectName){
        List<String> childSObjectList = new List<String>();
        try{
            Inline_Object_Mapping__mdt inlineSObject = [SELECT Id, Related_Object_Mapping__c FROM  Inline_Object_Mapping__mdt WHERE ObjectApiName__c =:objectName LIMIT  1];
            if(inlineSObject != NULL){
                 childSObjectList = inlineSObject.Related_Object_Mapping__c.split(',');
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'getAllRelatedObject', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return childSObjectList;
    }
    
    /*
* @description : This method is used getting sObject Name.
* @param : Id recordId  (recordId as params).
* @return : String sObjectName (return sObject Name).
*/ 
    @AuraEnabled
    public static String getSObjectName(Id recordId){
        String sobjectName;
        try{
            if(recordId != NULL){
                Schema.SObjectType sobjectType = recordId.getSObjectType();
                sobjectName = sobjectType.getDescribe().getName();
            }  
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'getSObjectName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        } 
        return sobjectName;
    }
    
    /*
* @description : This method is used getting filter with using configuration.
* @param : String sObjectId (sObject Id of parent as a param).
* @return : String fieldName return single fieldname which have ascending or descending filter.
*/ 
    @AuraEnabled  
    public static FieldFilterWrapper gettingFilter(String sObjectId){      
       FieldFilterWrapper createWrapper = new FieldFilterWrapper();
        try{
            if(sObjectId != NULL){
                Inline_Fields__mdt iterateInlineField = [SELECT field_Api_Name__c, ORDER_BY__c, Inline_Object_Mapping__c FROM Inline_Fields__mdt WHERE Inline_Object_Mapping__c = :sObjectId AND ORDER_BY__c != 'None' AND field_Api_Name__c != NULL LIMIT 1];
                if(iterateInlineField != NULL){
                    createWrapper.fieldName = iterateInlineField.field_Api_Name__c;
                    if(iterateInlineField.ORDER_BY__c == 'Ascending'){
                        createWrapper.filter = 'ASC';  
                    }else{
                        createWrapper.filter = 'DESC';   
                    }
                }  
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('InlineEditing', 'gettingFilter', e.getMessage(), e.getStackTraceString(), e.getLineNumber());            
        }
        return createWrapper;
    }
    
    public static void testt(){
              User currentUser = [SELECT Name, email FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
             System.debug('userId ====>'+currentUser);
    }
    
    
    
    public class ObjectWrappar{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }  
    
    /* public class DataWrapper{
@AuraEnabled public String createDate;
@AuraEnabled public List<sObject> filterdataList;
}*/
    
    public class TypeAttributesWrapper{
        @AuraEnabled public label label;
        @AuraEnabled public String target; 
        @AuraEnabled public List<RowsAction> rowActions;
        @AuraEnabled public String menuAlignment;
    }
    
    public class RowsAction{
        @AuraEnabled public String  label;
        @AuraEnabled public String  name;
    }
    public class ColumnWrapper{
        @AuraEnabled public String label;       
        @AuraEnabled public String fieldName;       
        @AuraEnabled public String  type; 
        @AuraEnabled public Boolean sortable;
        @AuraEnabled public Boolean editable;
        @AuraEnabled public Integer sequence;
        @AuraEnabled public Boolean required;
        @AuraEnabled public TypeAttributesWrapper typeAttributes;
    }
    
    public class FieldWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    /** public class FinalFieldWrappar{
@AuraEnabled public String key;
@AuraEnabled public Integer value;
}**/
    
    public class SChildObjectWrapper{        
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class label{
        @AuraEnabled public String fieldName;        
    }
    
    public class FieldFilterWrapper{
        @AuraEnabled public String fieldName;
        @AuraEnabled public String filter;
    }
    
    public class ChildRecordWrapper{
        @AuraEnabled public String objectName;
        @AuraEnabled public String icon;
        @AuraEnabled public String count;
        @AuraEnabled public Integer total;
        @AuraEnabled public List<ColumnWrapper> column;
        @AuraEnabled public List<sObject> data;        
        
    }
}