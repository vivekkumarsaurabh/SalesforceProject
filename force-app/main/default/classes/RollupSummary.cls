/*
* @Description : This class is used for create custom rollup summary on sOBject;
* @author      : Vivek Kumar Saurabh
* @Created Date: 14/11/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 14/11/2024
*/
public with sharing class RollupSummary {    
    
    /*
* @description : This method is used for retrive sObject name from configration.
* @param : N.A.
* @return : List<SobjectConfigrationWrapper> return sObjectName wrapper list for combo box.
*/
    @AuraEnabled
    public static List<SobjectConfigrationWrapper> getsObjectWithConfigration(){     
        List<SobjectConfigrationWrapper> createsObjectWrapperList = new List<SobjectConfigrationWrapper>();
        try{       
            for(RollupSummarysObjectConfig__mdt iterateSobject : [SELECT Id, MasterLabel, DeveloperName FROM RollupSummarysObjectConfig__mdt WHERE Id != NULL AND MasterLabel != NULL AND DeveloperName != NULL]){
                SobjectConfigrationWrapper createWrapper = new SobjectConfigrationWrapper();
                createWrapper.label = iterateSobject.MasterLabel;
                createWrapper.value = iterateSobject.DeveloperName;
                createsObjectWrapperList.add(createWrapper);
            }            
            if(!createsObjectWrapperList.isEmpty()){
                return createsObjectWrapperList;
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('RollupSummary', 'getsObjectWithConfigration', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return createsObjectWrapperList;  
    }
    
    /*
* @description : This method is used for get child objects name.
* @param : String objectName object name as a params.
* @return :List<ChildObjectsWrapper> childObjectWrapper which is store list of child Object .
*/ 
    @AuraEnabled
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
            ExceptionHandlingClass.exceptionLogRecords('RollupSummary', 'getChildObject', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
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
        // List<ChildObjectFieldApiWrapper> ChildObjectFieldApiWrapperList = new List<ChildObjectFieldApiWrapper>();      
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
            ExceptionHandlingClass.exceptionLogRecords('RollupSummary', 'getChildObjectWithFieldRelation', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return childAPiRelationshipMap;   
    }
    
    /*
* @description : This method is used for get NUMBER/DOUBLE/CURRENCY type fields of child sobject.
* @param : String childSObjectName  child sObejctapi name as params.
* @return : List<SobjectConfigrationWrapper> child sObject fields List.
*/
    @AuraEnabled
    public static List<SobjectConfigrationWrapper> getFieldIntegrated(String childObjectName){
        List<SobjectConfigrationWrapper> childFieldList = new List<SobjectConfigrationWrapper>();
        Map<String, Schema.SObjectType> schemaGlobalDescribeMap = Schema.getGlobalDescribe();
        try{
            if(childObjectName != NULL){
                Map<String, Schema.SObjectField> fieldsMap = schemaGlobalDescribeMap.get(childObjectName).getdescribe().fields.getMap();
                if(fieldsMap != NULL){
                    for (String fieldName : fieldsMap.keySet()) {            
                        Schema.DescribeFieldResult fieldDescribe = fieldsMap.get(fieldName).getDescribe();
                        if(fieldDescribe != NULL){
                            Schema.DisplayType fieldType = fieldDescribe.getType();
                            if (fieldDescribe.isCalculated()) {
                                continue;
                            }
                            if(fieldType != NULL){
                                if (fieldType == Schema.DisplayType.Currency || fieldType == Schema.DisplayType.DOUBLE || fieldType == Schema.DisplayType.PERCENT) {
                                    SobjectConfigrationWrapper fieldWrapper = new SobjectConfigrationWrapper();
                                    fieldWrapper.label = String.valueOf(fieldDescribe.getLabel());
                                    fieldWrapper.value = String.valueOf(fieldName);
                                    childFieldList.add(fieldWrapper);
                                    // System.debug('Field: ' + fieldName + ', Type: ' + fieldType+ '  Label ---> '+fieldDescribe.getLabel());
                                }
                            }
                        }
                    }
                }
                if(!childFieldList.isEmpty()){
                    return childFieldList;
                }                
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('RollupSummary', 'getFieldIntegrated', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return childFieldList;
    }
    
    /*
* @description : This method is used for createCustomField.
* @param : String fieldLabelName get field Label Name, String fieldApiName get field Api name, String defaultValue get default value.
* @return : N/A.
*/
    @AuraEnabled
    public static List<MetadataService.SaveResult> createCustomField(String fieldLabelName, String fieldApiName, String description, String helpText, String realValueList, String childsObject){        
        MetadataService.MetadataPort service = createService();
        MetadataService.CustomField customField = new MetadataService.CustomField();
        MetadataService.Profile profile = new MetadataService.Profile();
        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();        
        List<sObject> createsObjectRecordList = new List<sObject>();
        try{
            if(fieldLabelName != NULL && fieldApiName != NULL){                
                customField.fullName = fieldApiName;  //Account.CustomField_c
                customField.label = fieldLabelName;
                customField.type_x = 'Text';                        
                customField.length = 100;                         
                customField.required = false;
                customField.description = description;
                customField.inlineHelpText = helpText;
                results = service.createMetadata(new MetadataService.Metadata[] { customField });
             	 MetadataService.PermissionSetFieldPermissions fieldPermission = new MetadataService.PermissionSetFieldPermissions();
      		  	fieldPermission.field = fieldApiName; 
      		  	fieldPermission.readable = true;  
        	  	fieldPermission.editable = false;  
        		 MetadataService.PermissionSet permissionSet = new MetadataService.PermissionSet();
       			 permissionSet.fullName = 'test_permission_set';  
       			 permissionSet.label = 'permission set';
        		 permissionSet.fieldPermissions = new List<MetadataService.PermissionSetFieldPermissions>{ fieldPermission };       
                 MetadataService.UpsertResult[] upsertPermissionSet = service.upsertMetadata(new MetadataService.Metadata[] { permissionSet });      
               if(!results.isEmpty() && !upsertPermissionSet.isEmpty()){
                    String sObjectName = fieldApiName.split('\\.')[0];
                    String fieldName =  fieldApiName.split('\\.')[1];
                     Map<String, String> childRelationshipMap = getChildObjectWithFieldRelation(sObjectName); 
              		 if(realValueList != NULL){                         
                     List<Object> sObjectObjectList = (List<Object>)JSON.deserializeUntyped(realValueList); 
                      String childObject = childRelationshipMap.get(childsObject);
                     for(Object iterateSObjetRecord : sObjectObjectList){
                         Map<String, Object> currentMap = (Map<String, Object>)iterateSObjetRecord;
                         	 if(currentMap.containsKey(childObject) && currentMap.containsKey('exp')) {
                                       sObject createsObjectRecord = Schema.getGlobalDescribe().get(sObjectName).newSObject();
                                       Schema.SObjectType objType = createsObjectRecord.getSObjectType();
                                           //Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();  
                                           // Schema.SObjectField field = fieldMap.get('Name');  
                                     		 createsObjectRecord.put('Id', (String) currentMap.get(childObject));
                                              Integer val =  (Integer) currentMap.get('exp');
                    	             		 createsObjectRecord.put(fieldName , String.valueOf(val));
                                     		 createsObjectRecordList.add(createsObjectRecord); 
                   			  } 
        				} 
                   	    System.debug('createsObjectRecordList----->'+createsObjectRecordList);                          
                       upsert createsObjectRecordList;
               		 }
                }
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('RollupSummary', 'createCustomField', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return results;
    }
    
 /*
* @description : This method is used for getFieldValue.
* @param : String parentsObjectName parent sObject Name as a params, String fieldIntegrated fieldAPIName as params, String childsObjectName childSObjectAPIName as params, String operation operation as params, String parentsObjectId parentsObjectId as params.
* @return : String value get value as String.
*/    
    @AuraEnabled
    public static List<AggregateResult> getFieldValue(String parentsObjectName, String fieldIntegrated, String childsObjectName, String operation, String parentsObjectId){
        List<AggregateResult> resultList = new List<AggregateResult>();
        try{
            if(parentsObjectName != NULL && childsObjectName != NULL && operation != NULL){
                 String queryCreated;
                 Map<String, String> childRelationshipMap  = getChildObjectWithFieldRelation(parentsObjectName);
                if(operation == 'COUNT'){
                    queryCreated = 'SELECT '+childRelationshipMap.get(childsObjectName)+', COUNT(Id) exp FROM '+childsObjectName+' GROUP BY '+childRelationshipMap.get(childsObjectName);
                }else{
                    queryCreated = 'SELECT '+childRelationshipMap.get(childsObjectName)+', '+operation+'('+fieldIntegrated+') exp FROM '+childsObjectName+' GROUP BY '+childRelationshipMap.get(childsObjectName);
                }
                resultList = Database.query(queryCreated);
                if(!resultList.isEmpty()){
                                 //   value = String.valueOf(result.get('exp'));
                    return resultList;
                }
            }
            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('RollupSummary', 'getFiedlValue', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return resultList;
    }

       
    
    /*
* @description : This method is used for create Metadata service .
* @param : N/A.
* @return : MetadataService.MetadataPort return Metadata port service.
*/
    public static MetadataService.MetadataPort createService() {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        try{
            if(service != NULL){
                service.SessionHeader = new MetadataService.SessionHeader_element();
                service.SessionHeader.sessionId = apiEnabledSessionId();
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('RollupSummary', 'createService', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return service;
    }
    
    
    /*
* @description : This method is used for getting current getSessionId.
* @param : N/A.
* @return : String return user id using Apex pagerefrence Id.
*/
    public static String apiEnabledSessionId(){
        String vfContent = '';
        Integer startIndex;
        Integer endIndex;
        try{
            PageReference sessionPage = Page.SessionId;
            vfContent = Test.isRunningTest() ? 'Start_Of_Session_IdSESSION_ID_REMOVEDEnd_Of_Session_Id': sessionPage.getContent().toString();
            startIndex = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length();
            endIndex = vfContent.indexOf('End_Of_Session_Id');    
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('RollupSummary', 'apiEnabledSessionId', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return vfContent.substring(startIndex, endIndex);
    }
    
    
    public class ChildObjectsWrapper{
        @AuraEnabled Public String label;
        @AuraEnabled Public String value;
    }
    
    public class SobjectConfigrationWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
}