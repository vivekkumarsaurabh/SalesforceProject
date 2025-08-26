/*
* @Description : This class is used for track history of objects;
* @author      : Vivek Kumar Saurabh
* @date        : 27/05/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 10/06/2024
*/
public class ObjectHistoryTracking{
    /*
* @description : This method is a trigger method of creating Object History Records.
* @param : N/A.
* @return : N/A.
*/   
    // COMMENT : Code should be more formated
    public static void trackObjectHistory(){
        List<SObject> updatedRecordList = Trigger.New; // Variable name should be more relevant.
        List<Object_sHistory__c> objHistoryRecordList = new List<Object_sHistory__c>();
        List<ObjectHistory__e> objHistoryEventList = new List<ObjectHistory__e>();
        Set<Id> recordIdsSet = new Set<Id>();
        Map<String, String> metaDataConfigrationMap = new Map<String, String>();  
        for(ObjectHistoryConfig__mdt iterateConfigMetaData : [SELECT Id, ObjectName__c, Field_Name__c FROM ObjectHistoryConfig__mdt WHERE ObjectName__c != NULL AND Id != NULL]){
            metaDataConfigrationMap.put(iterateConfigMetaData.ObjectName__c, iterateConfigMetaData.Field_Name__c);
        }
       // Map<Id, String> objectRecordMap =  gettingReferenceMap(objName);
        if(!updatedRecordList.isEmpty() && updatedRecordList != NULL){        
            for(SObject iterateUpdatedRecord : updatedRecordList){
                Schema.SObjectType sobjectType = iterateUpdatedRecord.Id.getSObjectType();
                String sobjectName = sobjectType.getDescribe().getName();
                String fieldsAPIName = metaDataConfigrationMap.get(sobjectName);   // Variable name should be more relevant.
                if(Trigger.oldMap == NULL){
                    Object_sHistory__c createObjHistory = new Object_sHistory__c();
                    createObjHistory.Object_Name__c = Schema.getGlobalDescribe().get(sobjectName).getDescribe().getLabel();                               
                    createObjHistory.Record_Id__c = iterateUpdatedRecord.Id;
                    createObjHistory.Field_Name__c = 'Created.';
                    objHistoryRecordList.add(createObjHistory);
                    ObjectHistory__e event = new ObjectHistory__e();
                    event.isShowTable__c = true;
                    objHistoryEventList.add(event);
                }
                if(fieldsAPIName != NULL && Trigger.oldMap != NULL){
                    SObject oldObjectRecordDetail = Trigger.oldMap.get(iterateUpdatedRecord.Id);
                    List<String> fieldsList = fieldsAPIName.split(','); 
                    //not required 
                    // if(!fieldsList.isEmpty()){           
                    for(String iterateField : fieldsList){
                        iterateField.trim();
                        if(iterateUpdatedRecord.get(iterateField) != oldObjectRecordDetail.get(iterateField)){
                            Object_sHistory__c createObjHistory = new Object_sHistory__c();
                            createObjHistory.Object_Name__c = sobjectName;
                            createObjHistory.New_Value__c = String.valueOf(iterateUpdatedRecord.get(iterateField)).replaceAll('<[^>]+>', '');
                            createObjHistory.Old_Value__c = String.valueOf(oldObjectRecordDetail.get(iterateField)) != null ? String.valueOf(oldObjectRecordDetail.get(iterateField)).replaceAll('<[^>]+>', '') : '';
                            createObjHistory.Record_Id__c = iterateUpdatedRecord.Id;
                            createObjHistory.Field_Name__c = iterateField;
                            objHistoryRecordList.add(createObjHistory);
                            ObjectHistory__e event = new ObjectHistory__e();
                            event.isShowTable__c = true;
                            objHistoryEventList.add(event);
                        }
                    } 
                    // }
                }
            } 
            if(!objHistoryEventList.isEmpty()) {   
                EventBus.publish(objHistoryEventList);
            }
        }
        try{
            if(!objHistoryRecordList.isEmpty() && objHistoryRecordList != NULL){
                insert objHistoryRecordList;
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ObjectHistoryTracking', 'trackObjectHistory', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }      
    }
    
    /*
* @description : This method is used for returns all history.
* @param : Integer limitsize, String objName, String recId, Integer offset (records take from database behalf on recordId and sObjectName under the limit).  // Where you are using offset param
* @return : List<ObjectHistoryWrapper>  (return WrapperList of ObjectHistory Records). // What it will return explain
*/    
    // Add proper error handeling.
    @AuraEnabled
    public static List<ObjectHistoryWrapper> retriveObjectHistory(Integer limitsize, String objName, String recId, Integer offset){
        List<ObjectHistoryWrapper> objHistoryWrapperList = new List<ObjectHistoryWrapper>(); 
        Set<Id> recordIdSet = new Set<Id>();
        Map<String, String> recIDLastModifyIdMap = new Map<String, String>();
        Map<String, String> userIduserNameMap = new Map<String, String>(); 
        try{
            if(objName != NULL && recId != NULL && limitsize != NULL && offset != NULL){
                //Variable name should be unique and  in clear words.
                List<Object_sHistory__c> objHistoryDataList = [SELECT Object_Name__c, Field_Name__c, New_Value__c, Record_Id__c, Old_Value__c, CreatedDate FROM Object_sHistory__c WHERE Object_Name__c = :objName AND Record_Id__c =:recId ORDER BY CreatedDate DESC LIMIT:limitsize OFFSET :offset]; /// Need to potimize the heap size.   
                if(!objHistoryDataList.isEmpty() && objHistoryDataList != NULL){
                    for(Object_sHistory__c iterateObjHistory : objHistoryDataList){
                        recordIdSet.add(iterateObjHistory.Record_Id__c); 
                    }   
                }
                Map<Id, String> objectRecordMap =  gettingReferenceMap(objName);
                if(!recordIdSet.isEmpty()){      
                    String query = 'SELECT Id, LastModifiedById FROM '+objName+' WHERE Id IN :recordIdSet';
                    List<sObject> objRecordList = Database.query(query);  
                    if(!objRecordList.isEmpty()){
                        for(Sobject iterateRecord : objRecordList){
                            recIDLastModifyIdMap.put(iterateRecord.Id, (Id)iterateRecord.get(System.Label.LastModify)); // Don't use hard code value
                        }
                    }
                    if(!recIDLastModifyIdMap.values().isEmpty()){
                        for(User iterateUser : [SELECT Id, Name FROM User WHERE Id IN :recIDLastModifyIdMap.values()]){
                            userIduserNameMap.put(iterateUser.Id, iterateUser.Name);
                        }
                    }
                }
                if(!objHistoryDataList.isEmpty() && objHistoryDataList != NULL){
                    for(Object_sHistory__c iterateObjHistory : objHistoryDataList){
                        ObjectHistoryWrapper createWrapper = new ObjectHistoryWrapper();
                        createWrapper.objectName = Schema.getGlobalDescribe().get(iterateObjHistory.Object_Name__c).getDescribe().getLabel();  
                        createWrapper.fieldName = Schema.getGlobalDescribe().get(iterateObjHistory.Object_Name__c).getDescribe().fields.getMap().get(iterateObjHistory.Field_Name__c).getDescribe().getLabel();
                        Schema.DescribeFieldResult fieldDescribe = Schema.getGlobalDescribe().get(iterateObjHistory.Object_Name__c).getDescribe().fields.getMap().get(iterateObjHistory.Field_Name__c).getDescribe();
                        if(fieldDescribe.getType() == Schema.DisplayType.REFERENCE){
                           createWrapper.newValue = objectRecordMap.get(iterateObjHistory.New_Value__c) != NULL ? objectRecordMap.get(iterateObjHistory.New_Value__c) : iterateObjHistory.New_Value__c;                       
                           createWrapper.oldValue = objectRecordMap.get(iterateObjHistory.Old_Value__c) != NULL ? objectRecordMap.get(iterateObjHistory.Old_Value__c) : iterateObjHistory.Old_Value__c;  
                        }else{
                           createWrapper.newValue = iterateObjHistory.New_Value__c;                       
                           createWrapper.oldValue = iterateObjHistory.Old_Value__c;  
                        }                       
                        createWrapper.recordId = iterateObjHistory.Record_Id__c;                          
                        createWrapper.userName = userIduserNameMap.get(recIDLastModifyIdMap.get(iterateObjHistory.Record_Id__c));
                        createWrapper.userId = recIDLastModifyIdMap.get(iterateObjHistory.Record_Id__c);
                        createWrapper.lastModifyDate = iterateObjHistory.CreatedDate.format();           
                        objHistoryWrapperList.add(createWrapper);
                    }             
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ObjectHistoryTracking', 'retriveObjectHistory', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return objHistoryWrapperList;
    }
    
    /*
* @description : This method is used for return number of record behalf of objectName and recId.
* @param : String objName, String recId (return length of records behalf of ObjectName and recordId).
* @return : Integer (return length of records).         
*/
    @AuraEnabled
    public static Integer returnLengthObjectHistoryRecords(String objName, String recId){
        List<Object_sHistory__c> objHistoryDataSize = new List<Object_sHistory__c>();
        try{
            if(objName != NULL && recId != NULL){ 
                objHistoryDataSize = [SELECT Object_Name__c, Field_Name__c, New_Value__c, Record_Id__c, Old_Value__c, CreatedDate FROM Object_sHistory__c WHERE Object_Name__c = :objName AND Record_Id__c =:recId];  
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ObjectHistoryTracking', 'returnLengthObjectHistoryRecords', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }        
        return objHistoryDataSize.size();
    }
    
    /*
* @description : This method is used for return Object Label Name using schema.
* @param : String objApiName (sObjectApi to take label of sObject).    // What is the param  explain in details.
* @return : String (return Label of sObject Api).             // What it will return explain
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
* @description : This method is return query behalf of object for getting reference Name behalf on their Id.
* @param : N/A.
* @return : String query.
*/ 
    @AuraEnabled
    public static Map<Id, String> gettingReferenceMap(String objectName){          
        String referenceQuery;
        List<sObject> sObjectList = new List<sObject>();
        List<String> referenceFieldApiName = new List<String>();        
        Map<Id, String> recordIdNameMap = new Map<Id, String>();        
        Map<Id, String> objectRecordMap = new Map<Id, String>();
        Map<String, String> fieldIdFieldNameMap = new Map<String, String>();    
        for(ObjectHistoryConfig__mdt iterateConfiguration : [SELECT Id, ObjectName__c, Field_Name__c FROM ObjectHistoryConfig__mdt WHERE ObjectName__c = :objectName]){
            if(iterateConfiguration.Field_Name__c != NULL){
                List<String> fieldList = iterateConfiguration.Field_Name__c.split(',');
                for(String iteratefield : fieldList){
                    Schema.DescribeFieldResult fieldDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(iteratefield).getDescribe();
                    if(fieldDescribe.getType() == Schema.DisplayType.REFERENCE){
                        referenceFieldApiName.add(iteratefield);
                        if(fieldDescribe.isCustom()){      
                            referenceFieldApiName.add(iteratefield.removeEndIgnoreCase('c')+'r.Name');
                            fieldIdFieldNameMap.put(iteratefield, iteratefield.removeEndIgnoreCase('c')+'r');
                        }else{   
                            referenceFieldApiName.add(iteratefield.removeEndIgnoreCase('Id')+'.Name');
                            fieldIdFieldNameMap.put(iteratefield, iteratefield.removeEndIgnoreCase('Id'));
                        }                      
                    }
                }                
            }
        }      
        if(!referenceFieldApiName.isEmpty()){
            referenceQuery = 'SELECT '+String.join(referenceFieldApiName, ',')+' FROM '+objectName;
        }
        if(referenceQuery != NULL){
            sObjectList = Database.query(referenceQuery);
        }
        System.debug('referenceQuery===>'+referenceQuery);
        System.debug('sObjectList===>'+JSON.serialize(sObjectList));
        if(fieldIdFieldNameMap != NULL && !sObjectList.isEmpty()){
            for(sObject iterateRecord : sObjectList){
                System.debug('record====>'+ JSON.serialize(iterateRecord));
                for(String iterateApiName :  fieldIdFieldNameMap.keySet()){
                    if(iterateRecord.get(iterateApiName)!= NULL){
                        System.debug('Id---->'+iterateRecord.getSobject(fieldIdFieldNameMap.get(iterateApiName)).get('Id'));
                        System.debug('Name===>'+String.valueOf(iterateRecord.getSobject(fieldIdFieldNameMap.get(iterateApiName)).get('Name')));
                        objectRecordMap.put(String.valueOf(iterateRecord.getSobject(fieldIdFieldNameMap.get(iterateApiName)).get('Id')), String.valueOf(iterateRecord.getSobject(fieldIdFieldNameMap.get(iterateApiName)).get('Name')));                       
                    }
                }
            }
        }
         System.debug('fieldIdFieldNameMap-===>'+objectRecordMap);        
        return objectRecordMap;
    }
    
    /*
* @description : This method is return column Header of Object History with using Metadata.
* @param : N/A.
* @return : List<ObjectHistoryColumnWrapper> (return wrapper list of Header column with mapping that header with metadata).
*/
    @AuraEnabled
    public static List<ObjectHistoryColumnWrapper> objectHistoryColumn(){
        List<ObjectHistoryColumnWrapper> historyColumnWrappperList = new List<ObjectHistoryColumnWrapper>();
        for(ObjectHistoryColumnMapping__mdt iterateMetadataRecord : [SELECT Id, label, FieldName__c, type__c, Sequence__c, sortable__c, (SELECT label, target__c FROM typeAttributes__r WHERE label != NULL AND target__c != NULL) FROM ObjectHistoryColumnMapping__mdt WHERE label != NULL AND FieldName__c != NULL AND type__c != NULL]){
            ObjectHistoryColumnWrapper createWrapper = new ObjectHistoryColumnWrapper();
            TypeAttributesWrapper createChildWrapper = new TypeAttributesWrapper();            
            Label labelName = new Label(); 
            for(typeAttributes__mdt iterateTypeAttributeRecord: iterateMetadataRecord.typeAttributes__r){
                labelName.fieldName = iterateTypeAttributeRecord.label;
                createChildWrapper.target = iterateTypeAttributeRecord.target__c;    
                createChildWrapper.label = labelName; 
                createWrapper.typeAttributes = createChildWrapper;
            }                  
            createWrapper.label = iterateMetadataRecord.Label;
            createWrapper.fieldName = iterateMetadataRecord.FieldName__c;
            createWrapper.type = iterateMetadataRecord.type__c;
            createWrapper.sortable = iterateMetadataRecord.sortable__c; 
            createWrapper.sequence = Integer.valueOf(iterateMetadataRecord.Sequence__c);
            createWrapper.wrapText = True;
            historyColumnWrappperList.add(createWrapper);
        }
        return historyColumnWrappperList;
    }
    
    public class TypeAttributesWrapper{
        @AuraEnabled public Label label;
        @AuraEnabled public String target;
    }
    
    public class ObjectHistoryColumnWrapper{
        @AuraEnabled public String label;       
        @AuraEnabled public String fieldName;   
        //Avoid using variable name like keyword 
        @AuraEnabled public String  type; //when we remove this type variable name then that does not support datatable column
        @AuraEnabled public Boolean wrapText;
        @AuraEnabled public Boolean sortable;        
        @AuraEnabled public Integer sequence;
        @AuraEnabled public TypeAttributesWrapper typeAttributes;
    }
    
    
    //Class name should always start with Capital 
    public class Label{
        @AuraEnabled public String fieldName;        
    }
    
    public class ObjectHistoryWrapper{
        @AuraEnabled public String objectName;
        @AuraEnabled public String fieldName;
        @AuraEnabled public String lastModifyDate;
        @AuraEnabled public String userName;
        @AuraEnabled public String userId;
        @AuraEnabled public String newValue;
        @AuraEnabled public String oldValue;
        @AuraEnabled public String recordId;
    }
}