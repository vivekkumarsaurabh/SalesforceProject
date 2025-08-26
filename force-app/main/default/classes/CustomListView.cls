/*
* @Description : This class is used for custom List view;
* @author      : Vivek Kumar Saurabh
* @Created Date: 30/08/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 12/09/2024
*/
public class CustomListView {
    
    public static List<Object_Configration__mdt> objectConfigrationList = [SELECT Id, MasterLabel FROM Object_Configration__mdt WHERE Id != NULL AND MasterLabel != NULL];
    
    public static List<Refresh_Time_Interval__mdt> refreshTimeIntervalList = [SELECT Id, MasterLabel, DeveloperName FROM Refresh_Time_Interval__mdt WHERE Id != NULL AND MasterLabel != NULL AND DeveloperName != NULL];
    
    public static final Map<String, String> operatorMap = new Map<String, String>{'equals'=>'=', 'not equal to'=>'!=', 'less than' =>'<', 'greater than'=>'>', 'greater or equal' =>'>=', 'less or equal' =>'<=', 'contains'=>'LIKE', 'does not contains'=>'NOT LIKE', 'start with'=>'LIKE'};
        
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
                if(SObjectMap != NULL){       
                    for(Object_Configration__mdt iterateSObject : objectConfigrationList){
                        if(iterateSObject != NULL){
                            if(SObjectMap.containskey(iterateSObject.MasterLabel)){
                                Schema.DescribeSObjectResult describeSObject = Schema.getGlobalDescribe().get(iterateSObject.MasterLabel).getDescribe();
                                ObjectWrappar createSObjectWrapper = new ObjectWrappar();
                                createSObjectWrapper.label = String.valueOf(describeSObject.getLabel());
                                createSObjectWrapper.value = String.valueOf(iterateSObject.Id);
                                objectWrapperList.add(createSObjectWrapper);
                            }
                        }
                    }
                }
            }catch(Exception e){
                ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'retriveSobjectName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
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
                Object_Configration__mdt objectName =  [SELECT Id, MasterLabel FROM Object_Configration__mdt WHERE Id = :sobjectId AND MasterLabel != NULL LIMIT 1];  
                if(objectName != NULL){
                    Schema.DescribeSObjectResult describeSObject = Schema.getGlobalDescribe().get(objectName.MasterLabel).getDescribe(); 
                    sObjectApiName = String.valueOf(describeSObject.getName());
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'getsObjectApiName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
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
            for(field_Configration__mdt iterateRec : [SELECT Id, label, fieldName__c, Type__c, Sortable__c, editable__c, Sequence__c, Visible__c FROM field_Configration__mdt WHERE Object_Configration__c =:sobjectId AND label != NULL AND fieldName__c != NULL AND Type__c != NULL]){
                if(iterateRec != NULL && iterateRec.Visible__c){
                    if(iterateRec.Type__c == 'button'){
                        TypeAttributesWrapper createTypeAttribute = new TypeAttributesWrapper();
                        label createWrapperLabel = new label();
                        createWrapperLabel.fieldName = iterateRec.fieldName__c;
                        createTypeAttribute.label = createWrapperLabel;
                        createTypeAttribute.variant = 'Base';
                        createTypeAttribute.name = 'Action';
                        ColumnWrapper createWrapper = new ColumnWrapper();                               
                        createWrapper.label = iterateRec.Label;
                        // createWrapper.fieldName = iterateRec.fieldName__c;
                        createWrapper.required = Schema.getGlobalDescribe().get(getsObjectApiName(sobjectId)).getDescribe().fields.getMap().get(iterateRec.fieldName__c).getDescribe().isNillable() == false ? true : false;
                        createWrapper.type = iterateRec.Type__c;
                        createWrapper.sortable = iterateRec.Sortable__c; 
                        createWrapper.editable = iterateRec.editable__c; 
                        createWrapper.sequence = Integer.valueOf(iterateRec.Sequence__c);
                        // createWrapper.initialWidth = 100;                       
                        createWrapper.typeAttributes = createTypeAttribute;
                        accWrapperList.add(createWrapper);
                    }else{
                        ColumnWrapper createWrapper = new ColumnWrapper();                               
                        createWrapper.label = iterateRec.Label;
                        createWrapper.fieldName = iterateRec.fieldName__c;
                        createWrapper.type = iterateRec.Type__c;
                        createWrapper.sortable = iterateRec.Sortable__c; 
                        createWrapper.editable = iterateRec.editable__c; 
                        createWrapper.sequence = Integer.valueOf(iterateRec.Sequence__c);
                        accWrapperList.add(createWrapper);
                    }
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'getColumns', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return accWrapperList;
    }
    
    /*
* @description : This method is used for retrive record of sObject.
* @param : String sobjectId  retrive data behalf of sObjectId, String sObjectApiName for dynamically data retrive then we use sObjectAPI Name.
* @return : N/A.
*/ 
    @AuraEnabled
    public static List<sObject> getData(String sobjectId, String sObjectName){
        List<sObject> sObjectrecordList = new List<sObject>(); 
        try{
            if(sobjectId != NULL){
                List<String> sObjectfieldList = returnfields(sobjectId);
                if(!sObjectfieldList.isEmpty() && sObjectName != NULL){      
                    String query = 'SELECT  Id, '+String.join(sObjectfieldList, ', ')+' FROM '+sObjectName;
                    sObjectrecordList = Database.query(query);
                }                
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'getData', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return sObjectrecordList;
    }
    
    /*
* @description : This method is used for return Fields list from configration.
* @param : String sobjectId params as sOBjectId of configration, String sObjectName param as sObjectApiName.
* @return : List<String> returns fields name list.
*/ 
    @AuraEnabled
    public static List<String> returnfields(String sobjectId){
        List<String> sObjectFieldList = new List<String>();
        try{
            if(sobjectId != NULL){
                for(field_Configration__mdt iterateField : [SELECT Id, label, fieldName__c, Visible__c, Object_Configration__c FROM field_Configration__mdt WHERE Object_Configration__c =:sobjectId AND label != NULL AND fieldName__c != NULL AND Id != NULL]){
                    if(iterateField.Visible__c){
                        sObjectFieldList.add(iterateField.fieldName__c);
                    }
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'returnfields', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return sObjectFieldList;       
    }
    
    
    /*
* @description : This method is search behalf of Search key.
* @param : String searchVal.
* @return : List<Account>.
*/
    @AuraEnabled
    public static List<sObject> searchKey(String searchVal, String sObjectName, String sObjectId){
        List<sObject> sObejctList = new List<sObject>();
        List<String> fieldList = new List<String>();
        try{
            if(sObjectId != NULL && sObjectName != NULL){
                fieldList = returnfields(sObjectId);
            }
            if(searchVal == null || String.isBlank(searchVal)){
                return NULL;
            }
            if(searchVal != NULL && !fieldList.isEmpty() && sObjectName != NULL){
                String searckKey = '%'+searchVal+'%';
                String filterName = fieldList[0];
                String query = 'SELECT '+String.join(fieldList,',')+' FROM '+sObjectName+' WHERE '+filterName+' LIKE :searckKey';                            
                sObejctList = Database.query(query);
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'searchKey', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return sObejctList;
    }
    
    /*
* @description : This method is delete Accounts records.
* @param : String recId.
* @return : N/A.
*/
    @AuraEnabled
    public static List<sObject> deletesObjectRecord(String recordId, String objectName){       
        List<sObject> sObjectList = new List<sObject>();        
        try{
            if(objectName != NULL && recordId != NULL){
                String query;
                if(objectName == 'ContentVersion'){
                     query = 'SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId =:recordId';
                }else{
                     query = 'SELECT Id FROM '+objectName+' WHERE Id =:recordId';
                }
                sObjectList = Database.query(query);           
            }            
            if(!sObjectList.isEmpty()){
                Delete sObjectList;
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'deletesObjectRecord', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
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
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'updatesObjectRecord', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return sObjectRecords;
    }
    
    /*
* @description : This method is used for get all field from configration for filter field.
* @param : String sobjectId sObject record Id.
* @return : List<fieldWrapper> return wrapper value with label and value for dual list box.
*/
    @AuraEnabled
    public static List<fieldWrapper> getAllFields(String sobjectId){
        List<fieldWrapper> fieldWrapperList = new List<fieldWrapper>();
        try{
            if(sobjectId != NULL){
                for(field_Configration__mdt iterateField : [SELECT Id, label, fieldName__c, Object_Configration__c FROM field_Configration__mdt WHERE Object_Configration__c =:sobjectId AND Id != NULL AND label != NULL AND fieldName__c != NULL]){
                    fieldWrapper createWrapper = new fieldWrapper();
                    createWrapper.label = iterateField.label;
                    createWrapper.value = iterateField.fieldName__c;
                    fieldWrapperList.add(createWrapper);                
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'getAllFields', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }  
        return fieldWrapperList;
    }
    
    
    /*
* @description : This method is used for objectIcon.
* @param : String objectName sObjectAPIName to take dynamically object Icon.
* @return : String return dynamically icon. 
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
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'objectIconMethod', e.getMessage(), e.getStackTraceString(), e.getLineNumber()); 
        }
        return iconName;
    }
    /*
* @description : This method is used get filter records of sObject.
* @param : String filter getting filterList in params, String sObjectName getting sObjectName as a params, String sObjectId sObjectId in params.
* @return : List<sObject> return filters records. 
*/
    @AuraEnabled
    public static List<sObject> getfilterList(String filter, String sObjectName, String sObjectId){
        List<filterWrapper> filterList = new List<filterWrapper>();
        List<String> fieldList = new List<String>();
        List<sObject> sObjectReocrdList = new List<sObject>(); 
        if(filter != NULL && sObjectId != NULL){
            filterList = (List<filterWrapper>) JSON.deserialize(filter, List<filterWrapper>.class);
            fieldList = returnfields(sObjectId);
        }         
        String filterValue;
        try{
            if(!filterList.isEmpty()){                
                for(Integer iterateFilter = 0; iterateFilter < filterList.size(); iterateFilter++){
                    if(filterList.size() == 1){
                        if(filterList[iterateFilter].operator == 'contains' || filterList[iterateFilter].operator == 'does not contains' || filterList[iterateFilter].operator == 'start with'){
                            filterValue = filterList[iterateFilter].fieldName+' '+operatorMap.get(filterList[iterateFilter].operator)+' '+'\'%'+filterList[iterateFilter].value+'%\'';       
                            
                        }else{
                            filterValue = filterList[iterateFilter].fieldName+' '+operatorMap.get(filterList[iterateFilter].operator)+' '+'\''+filterList[iterateFilter].value+'\'';       
                        }
                    }else{
                        if(iterateFilter == 0){
                            if(filterList[iterateFilter].operator == 'contains' || filterList[iterateFilter].operator == 'does not contains' || filterList[iterateFilter].operator == 'start with'){
                                filterValue = filterList[iterateFilter].fieldName+' '+operatorMap.get(filterList[iterateFilter].operator)+' '+'\'%'+filterList[iterateFilter].value+'%\' AND ';
                            }else{
                                filterValue = filterList[iterateFilter].fieldName+' '+operatorMap.get(filterList[iterateFilter].operator)+' '+'\''+filterList[iterateFilter].value+'\' AND ';
                            }
                        }else if(iterateFilter == filterList.size()-1){
                            if(filterList[iterateFilter].operator == 'contains' || filterList[iterateFilter].operator == 'does not contains' || filterList[iterateFilter].operator == 'start with'){
                                filterValue += filterList[iterateFilter].fieldName+' '+operatorMap.get(filterList[iterateFilter].operator)+' '+'\'%'+filterList[iterateFilter].value+'%\'';           
                            }else{
                                filterValue += filterList[iterateFilter].fieldName+' '+operatorMap.get(filterList[iterateFilter].operator)+' '+'\''+filterList[iterateFilter].value+'\'';                            
                                
                            }                            
                        }else{
                            if(filterList[iterateFilter].operator == 'contains' || filterList[iterateFilter].operator == 'does not contains' || filterList[iterateFilter].operator == 'start with'){
                                filterValue += filterList[iterateFilter].fieldName+' '+operatorMap.get(filterList[iterateFilter].operator)+' '+'\'%'+filterList[iterateFilter].value+'%\' AND ';                                
                            }else{
                                filterValue += filterList[iterateFilter].fieldName+' '+operatorMap.get(filterList[iterateFilter].operator)+' '+'\''+filterList[iterateFilter].value+'\' AND ';                                
                            }                            
                        }
                    }            
                }
            }
            if(filterValue != NULL && !fieldList.isEmpty()){
                String query = 'SELECT Id, '+String.join(fieldList, ', ')+' FROM '+sObjectName+' WHERE '+filterValue;
                sObjectReocrdList = Database.query(query);
            } 
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'getfilterList', e.getMessage(), e.getStackTraceString(), e.getLineNumber()); 
        }
        return sObjectReocrdList;
    }
    
    /*
* @description : This method is used for arrange fields.
* @param : String finnalFieldList final list JSON used for arrange that data, String sobjectId it is used behalf of sObjectId.
* @return : N/A.
*/
    
    @AuraEnabled
    public static void arrangeFiled(String finnalFieldList, String sobjectId, String sObjectName){
        Map<String, Integer> fieldApiNameMap = new Map<String, Integer>();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        List<String> readOnlyFieldList = new List<String>();        
        try{ 
            if(sObjectName != NULL){
                if (globalDescribe.containsKey(sObjectName)) {
                    Schema.SObjectType objectType = globalDescribe.get(sObjectName);            
                    Schema.DescribeSObjectResult describeResult = objectType.getDescribe();
                    Map<String, Schema.SObjectField> fieldsMap = describeResult.fields.getMap();
                    for (String fieldName : fieldsMap.keySet()) {
                        Schema.DescribeFieldResult fieldDescribe = fieldsMap.get(fieldName).getDescribe();
                        if (!fieldDescribe.isUpdateable()) {
                            readOnlyFieldList.add(fieldName);
                        }
                    }                    
                }                
            }
            if(finnalFieldList != NULL){
                List<FinalFieldWrappar> finnalFieldWrapperList = (List<FinalFieldWrappar>)JSON.deserialize(finnalFieldList, List<FinalFieldWrappar>.class);       
                if(!finnalFieldWrapperList.isEmpty()){
                    for(FinalFieldWrappar iterateField : finnalFieldWrapperList){
                        fieldApiNameMap.put(iterateField.Key, iterateField.value); 
                    }
                }
                for(field_Configration__mdt iterateField : [SELECT Id, label, fieldName__c, Object_Configration__c, Sequence__c, Type__c FROM field_Configration__mdt WHERE Object_Configration__c =:sobjectId AND Id != NULL AND label != NULL AND fieldName__c != NULL]){         
                    if(iterateField != NULL){
                        if(fieldApiNameMap.containsKey(iterateField.fieldName__c)){
                            Map<String, Object> updateMetadataMap = new Map<String, Object>();
                            if(readOnlyFieldList.contains(String.valueOf(iterateField.fieldName__c).toLowerCase())){
                                updateMetadataMap.put('editable__c', false);
                            }else{
                                updateMetadataMap.put('editable__c', true);                                
                            }
                            updateMetadataMap.put('fieldName__c', String.valueOf(iterateField.fieldName__c));
                            updateMetadataMap.put('Object_Configration__c', sObjectName);
                            updateMetadataMap.put('Sequence__c', fieldApiNameMap.get(iterateField.fieldName__c));
                            updateMetadataMap.put('Sortable__c', true);    
                            updateMetadataMap.put('Type__c', String.valueOf(iterateField.type__c));
                            updateMetadataMap.put('Visible__c', true);
                            String fullName = 'field_Configration.'+String.valueOf(iterateField.fieldName__c);
                            CreateUpdateMetadataUtils.createUpdateMetadata(fullName, String.valueOf(iterateField.label), updateMetadataMap);
                        }else{
                            Map<String, Object> updateMetadataMap = new Map<String, Object>();
                            updateMetadataMap.put('editable__c', true);
                            updateMetadataMap.put('fieldName__c', String.valueOf(iterateField.fieldName__c));
                            updateMetadataMap.put('Object_Configration__c', sObjectName);
                            //Datetime dt = Datetime.now();
                            // Integer epochTime = (Integer) (dt.getTime() / 1000);
                            updateMetadataMap.put('Sequence__c', 0);                          
                            updateMetadataMap.put('Sortable__c', true);    
                            updateMetadataMap.put('Type__c', String.valueOf(iterateField.type__c));
                            updateMetadataMap.put('Visible__c', false);
                            String fullName = 'field_Configration.'+String.valueOf(iterateField.fieldName__c);
                            CreateUpdateMetadataUtils.createUpdateMetadata(fullName, String.valueOf(iterateField.label), updateMetadataMap);                
                        }
                    }
                }   
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'arrangeFiled', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        } 
    }
    
    /*
* @description : This method is used for getting listView .
* @param : String sObjectName sObjectApiName in params.
* @return : List<listViewWrapper> wrapper send in JS for selecting list view.
*/
    @AuraEnabled
    public static List<listViewWrapper> gettingListView(String sObjectName){
        List<listViewWrapper> listViewWrapperList = new List<listViewWrapper>();
        try{
            if(sObjectName != NULL){
                for(ListView iterateListView : [SELECT Id, Name, DeveloperName FROM ListView WHERE SobjectType = :sObjectName AND Name != NULL AND DeveloperName != NULL]){
                    listViewWrapper createWrapper = new listViewWrapper();
                    createWrapper.label = iterateListView.Name;
                    createWrapper.value = iterateListView.DeveloperName;
                    listViewWrapperList.add(createWrapper);
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'gettingListView', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return listViewWrapperList;
    }
    
    /*
* @description : This method is used for getting filters .
* @param : String filterName filterAPIName in params, String sObjectName sObjectApiName in params.
* @return : List<filterWrapper> wrapper send in JS for filter records.
*/
    @AuraEnabled 
    public static List<filterWrapper> gettingFilter(String listViewName, String sObjectName) {
        List<filterWrapper> filterWrapperList = new List<filterWrapper>();
        List<String> listViewNameList = new List<String>();
        try{
            if(listViewName != NULL && sObjectName != NULL){
                 //listViewNameList = new List<String>{sObjectName+'.'+listViewName};
                 listViewNameList.add(sObjectName+'.'+listViewName);
            }
            if(!listViewNameList.isEmpty()){
                MetadataService.MetadataPort service = createService();
                MetadataService.ListView listView = (MetadataService.ListView) service.readMetadata('ListView', listViewNameList).getRecords()[0];     
                if(listView.filters != null){
                    for(MetadataService.ListViewFilter filter : listView.filters){
                        filterWrapper createFilterWrapper = new filterWrapper();
                        List<String> filterFieldName = String.valueOf(filter.field).split('\\.');
                        if(filterFieldName[1].contains('_')){
                            if(getFieldNameFromApiName(sObjectName, filterFieldName[1]) != NULL){
                                createFilterWrapper.fieldName = filterFieldName[1];
                                createFilterWrapper.operator = filter.operation;
                                createFilterWrapper.value = filter.value; 
                            }else{
                                List<String> splitFieldApiList = filterFieldName[1].split('_');
                                String fieldApi;
                                for(String iterateField : splitFieldApiList){
                                    if(fieldApi == NULL){
                                        fieldApi = iterateField.toLowerCase().capitalize();
                                    }else{
                                        fieldApi += iterateField.toLowerCase().capitalize();
                                    }
                                }
                                createFilterWrapper.fieldName = fieldApi;
                                createFilterWrapper.operator = filter.operation;
                                createFilterWrapper.value = filter.value; 
                            }
                        }else{
                            createFilterWrapper.fieldName = filterFieldName[1];
                            createFilterWrapper.operator = filter.operation;
                            createFilterWrapper.value = filter.value;                            
                        }                        
                        filterWrapperList.add(createFilterWrapper);
                        System.Debug('Filter ' + filter.field + ' ' + filter.operation + ' ' + filter.value);
                    }
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'gettingFilter', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return filterWrapperList;
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
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'createService', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
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
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'apiEnabledSessionId', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return vfContent.substring(startIndex, endIndex);
    }
    
    /*
* @description : This method is used for creating .
* @param : String sObjectName, String listViewLabelName, String listViewApiName, String filters, List<String> columnsList.
* @return : N/A.
*/
    @AuraEnabled
    public static List<MetadataService.SaveResult> createListView(String sObjectName, String listViewLabelName, String listViewApiName, List<String> columnsList){       
        MetadataService.MetadataPort service = createService();
        MetadataService.ListView listView = new MetadataService.ListView();
        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();
        try{
            if(sObjectName != NULL && listViewLabelName != NULL && listViewApiName != NULL && !columnsList.isEmpty()){
                listView.fullName = sObjectName+'.'+listViewApiName;
                listView.label = listViewLabelName;
                listView.filterScope = 'Everything';
                listView.columns =  columnsList;
            }        
            results = service.createMetadata(new MetadataService.Metadata[] { listView });  
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'createListView', e.getMessage(), e.getStackTraceString(), e.getLineNumber());            
        }
        return results;
    }
    
    /*
* @description : This method is used for update Listview with Filter.
* @param : String sObjectName getting sObjectName as params, String listViewLabelName getting list view lable Name as param, String listViewApiName getting list view lable Name as param, List<String> columnsList getting column which is shows, String filtersJSON filter json for deserialize in filter list.
* @return : List<MetadataService.SaveResult> return save results list.
*/
    @AuraEnabled
    public static List<MetadataService.SaveResult> updateListViewMetadata(String sObjectName, String listViewLabelName, String listViewApiName, List<String> columnsList, String filtersJSON, String shareToList, String filterScop){        
        MetadataService.MetadataPort service =  CustomListView.createService();
        MetadataService.ListView listView = new MetadataService.ListView();
        MetadataService.ListViewFilter filter = new MetadataService.ListViewFilter();        
        List<MetadataService.ListViewFilter> filterListToAdd = new List<MetadataService.ListViewFilter>();
        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();  
        try{
            if(sObjectName != NULL && listViewLabelName != NULL && listViewApiName != NULL && !columnsList.isEmpty()){
                List<filterWrapper> filterList = (List<filterWrapper>) JSON.deserialize(filtersJSON, List<filterWrapper>.class);
                for(filterWrapper iterateFilter : filterList){
                    filter.field = sObjectName+'.'+iterateFilter.fieldName.toUpperCase();
                    filter.operation = iterateFilter.operator;
                    filter.value = iterateFilter.value;
                    filterListToAdd.add(filter);
                }
                listView.fullName = sObjectName+'.'+listViewApiName;
                listView.label = listViewLabelName;        
                listView.filters = filterListToAdd;
                listView.filterScope = filterScop;
                listView.sharedTo = new MetadataService.sharedTo();
                if(shareToList != NULL){
                    List<ShareToWrapper> sharePartList = (List<ShareToWrapper>) JSON.deserialize(shareToList, List<ShareToWrapper>.class);
                    List<String> groupList = new List<String>();
                    List<String> roleList = new List<String>();
                    List<String> roleAndSubordinatesList = new List<String>();
                    List<String> roleAndSubordinatesInternalList = new List<String>();
                    for(ShareToWrapper iterateSharing : sharePartList){
                        if(iterateSharing.groupType == 'Regular'){                        
                            groupList.add(iterateSharing.name);
                        }else if(iterateSharing.groupType == 'role'){
                            roleList.add(iterateSharing.name);
                        }else if(iterateSharing.groupType == 'roleAndSubordinates'){
                            roleAndSubordinatesList.add(iterateSharing.name);
                        }else if(iterateSharing.groupType == 'roleAndSubordinatesInternal'){
                            roleAndSubordinatesInternalList.add(iterateSharing.name);
                        }
                    }
                    if(!groupList.isEmpty()){
                        listView.sharedTo.groups = groupList;
                    }else if(!roleList.isEmpty()){
                        listView.sharedTo.roles = roleList;
                    }else if(!roleAndSubordinatesList.isEmpty()){
                        listView.sharedTo.roleAndSubordinates = roleAndSubordinatesList;
                    }else if(!roleAndSubordinatesInternalList.isEmpty()){
                        listView.sharedTo.roleAndSubordinatesInternal = roleAndSubordinatesInternalList;
                    }
                }
                listView.columns = columnsList;  
            }
            results = service.updateMetadata(new MetadataService.Metadata[] { listView });
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'updateListViewMetadata', e.getMessage(), e.getStackTraceString(), e.getLineNumber());            
        }
        return results;
    }
    
    /*
* @description : This method is used for delete metadata.
* @param : String sObjectName, String apiName.
* @return : String return field Name.
*/  
    @AuraEnabled
    public static List<MetadataService.DeleteResult> deleteListViewMetadata(String listViewName, String sObjectName){
        MetadataService.MetadataPort service = CustomListView.createService();        
        List<String> listViewList = new List<String>(); 
        List<MetadataService.DeleteResult> deleteResuts = new List<MetadataService.DeleteResult>();
        try{
            if(sObjectName != NULL && listViewName != NULL){
                listViewList.add(sObjectName+'.'+listViewName);
            }
            deleteResuts = service.deleteMetadata('ListView', listViewList);
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'deleteListViewMetadata', e.getMessage(), e.getStackTraceString(), e.getLineNumber());            
        }        
        return deleteResuts;
    }
    /*
* @description : This method is used for getting groups records.
* @param : String typeOfGroup in this we defined type  like role, Queue, etc.. .
* @return : List<Group> groupslist return behalf of type.
*/    
    @AuraEnabled
    public static List<Group> gettingRecords(String typeOfGroup, String key){
        List<Group> groupsList = new List<Group>();
        try{
            if(typeOfGroup != NULL){                
                String searchKey = '%'+key+'%';
                groupsList =  [SELECT Id, Name, DeveloperName, Type FROM Group WHERE DeveloperName Like :searchKey AND Type =:typeOfGroup ];                 
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'gettingRecords', e.getMessage(), e.getStackTraceString(), e.getLineNumber());            
        }
        return groupsList;
    }
    
    /*
* @description : This method is used for getting Field from Field APi Name.
* @param : String sObjectName, String apiName.
* @return : String return field Name.
*/
    @AuraEnabled
    public static String getFieldNameFromApiName(String sObjectName, String apiName) {
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName);
        Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fields = describeResult.fields.getMap();    
        for (Schema.SObjectField field : fields.values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if (fieldDescribe.getName() == apiName) {
                return String.valueOf(fieldDescribe.getLabel());
            }
        }
        return null;
    }
    
    /*
* @description : This method is used for getting Field from Field APi Name.
* @param : String sObjectName, String apiName.
* @return : String return field Name.
*/
    @AuraEnabled
    public static List<String> getRichTextFields(String objectName){
        List<String> richTextFieldList = new List<String>();
        try{
            if(objectName != NULL){            
                for(FieldDefinition iterateField : [SELECT QualifiedApiName FROM FieldDefinition WHERE EntityDefinitionId = :objectName AND DataType = 'Rich Text Area(32768)']){
                    richTextFieldList.add(iterateField.QualifiedApiName);
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'getFieldDataType', e.getMessage(), e.getStackTraceString(), e.getLineNumber());            
        }
        return richTextFieldList;
    }
    
    /*
* @description : This method is used for return time Interval.
* @param : N/A.
* @return : List<ObjectWrappar> return wrapper list of time label value.
*/
    
    @AuraEnabled
    public static List<SChildObjectWrapper> timeInterval(){
        List<SChildObjectWrapper> timeIntervalList = new List<SChildObjectWrapper>();
        try{
            if(!refreshTimeIntervalList.isEmpty()){
                for(Refresh_Time_Interval__mdt iterateMetaDataRecords : refreshTimeIntervalList){
                    SChildObjectWrapper createtimeIntervalWrapper = new SChildObjectWrapper();
                    createtimeIntervalWrapper.label = String.valueOf(iterateMetaDataRecords.MasterLabel);
                    createtimeIntervalWrapper.value = String.valueOf(iterateMetaDataRecords.DeveloperName);
                    timeIntervalList.add(createtimeIntervalWrapper);
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('CustomListView', 'timeInterval', e.getMessage(), e.getStackTraceString(), e.getLineNumber());            
        }
        return timeIntervalList;
    }
    
    
    public class ObjectWrappar{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }  
    
    public class DataWrapper{
        @AuraEnabled public String createDate;
        @AuraEnabled public List<sObject> filterdataList;
    }
    
    public class TypeAttributesWrapper{
        @AuraEnabled public label label;
        @AuraEnabled public String target;
        @AuraEnabled public String variant;
        @AuraEnabled public String name;
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
        @AuraEnabled public Integer initialWidth;
        @AuraEnabled public TypeAttributesWrapper typeAttributes;
    }
    
    public class fieldWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class FinalFieldWrappar{
        @AuraEnabled public String key;
        @AuraEnabled public Integer value;
    }
    
    public class filterWrapper{
        @AuraEnabled public String displayClass;
        @AuraEnabled public String fieldName;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
    }
    
    public class SChildObjectWrapper{        
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class label{
        @AuraEnabled public String fieldName;        
    }
    
    public class shareToWrapper{
        @AuraEnabled public String name;
        @AuraEnabled public String groupType;
        @AuraEnabled public String icon;
    }
    
    public class listViewWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;        
    }
    
}