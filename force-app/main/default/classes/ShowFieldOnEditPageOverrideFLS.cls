/*
* @Description : This class is used for override Standard Button;
* @author      : Vivek Kumar Saurabh
* @Created Date: 04/10/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 08/10/2024
*/
public class ShowFieldOnEditPageOverrideFLS {
    
    /*
* @description : This method is take fields configration with metadata.
* @param : N/A.
* @return : List<String> fieldConfigrationsList.
*/ 
    @AuraEnabled
    public static List<String> fieldConfigrationList(){
        List<String> fieldConfigrationsList = new List<String>();
        for(FieldConfigration__mdt iterateField  : [SELECT Id, Label FROM FieldConfigration__mdt]){
            if(iterateField != NULL){
                fieldConfigrationsList.add(String.valueOf(iterateField.Label));
            }
        }
        return fieldConfigrationsList;
    }
    
    /*
* @description : This method is for return method to take endpoint and method.
* @param : String query.
* @return : String.
*/ 
    @AuraEnabled
    public static String toolingAPISOQL(String query) {
        if(query != NULL){
        String baseURL = URL.getOrgDomainURL().toExternalForm();       
        return restGet( baseURL + '/services/data/v58.0/tooling/query?q='+ (query.replace(' ', '+')) , 'GET');
        }
        return null;
    }
    
    /*
* @description : This method is for return name of pageLayout.
* @param : String recordId.
* @return : String.
*/ 
    @AuraEnabled
    public static List<LayoutWrapper> getLayoutName(String recordId) {
        List<LayoutWrapper> layoutWrapperList = new List<LayoutWrapper>();
        try{
            if(recordId != NULL){
                String query  = 'select Layout.Name from ProfileLayout where ProfileId = \''+UserInfo.getProfileId()+'\' AND RecordTypeId =\''+recordId+'\'';
                String body = toolingAPISOQL(query);
                System.debug(LoggingLevel.ERROR, '@@@ body: ' + body );
                String name = body.substringBetween('"Name":"', '"');     
                LayoutWrapper createLayout = new LayoutWrapper();
                createLayout.label = name;
                createLayout.value = name;
                layoutWrapperList.add(createLayout);
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ShowFieldOnEditPageOverrideFLS', 'getLayoutName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return layoutWrapperList;
    }
    
    /*
* @description : This method is for hit with tooling API.
* @param : String endPoint, String method.
* @return : String.
*/ 
    @AuraEnabled
    public static String restGet(String endPoint, String method) {            
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        try{
            if(endPoint != NULL && method != NULL){
                HttpRequest httpReq = new HttpRequest();
                httpReq.setHeader('Authorization', 'Bearer ' + CustomListView.apiEnabledSessionId());
                httpReq.setHeader('Content-Type','application/json');
                httpReq.setEndpoint(endPoint);
                httpReq.setMethod(method);
                res = http.send(httpReq);
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ShowFieldOnEditPageOverrideFLS', 'restGet', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return res.getBody();
    } 
    
    /*
* @description : This method is for return layout Section Wrapper.
* @param : String layoutName.
* @return : List<SectionWrapper>.
*/ 
    @AuraEnabled
    public static List<SectionWrapper> returnlayout(String layoutName){ 
        System.debug('layoutName==>'+layoutName);        
        List<SectionWrapper> secListWrap = new List<SectionWrapper>();
        try{
            if(layoutName != NULL){
                List<String> liofObject = layoutName.split('\\-');
                List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {layoutName});
                Metadata.Layout layoutMd = (Metadata.Layout) layouts.get(0); 
                for (Metadata.LayoutSection section : layoutMd.layoutSections) { 
                    Integer i = 1;        
                    List<ColumnWrapper> listColumnWrap = new List<ColumnWrapper>();
                    for (Metadata.LayoutColumn column : section.layoutColumns) {                 
                        List<FieldsWrapper> createWrap = new List<FieldsWrapper>();
                        if (column.layoutItems != null) {                    
                            for (Metadata.LayoutItem item : column.layoutItems) {                                                        
                                Schema.SObjectType objName = Schema.getGlobalDescribe().get(liofObject[0]);                                                  
                                Map<String, Schema.SObjectField> mfields = objName.getDescribe().fields.getMap(); 
                                System.debug('data===>'+mfields);                       
                                if(mfields.containsKey(item.field)){
                                    Schema.DescribeFieldResult fieldResult = mfields.get(item.field).getDescribe();
                                    System.debug('fieldData===>'+fieldResult);
                                    FieldsWrapper createField = new FieldsWrapper();                        
                                    createField.apiName = String.valueOf(fieldResult.getLocalName());
                                    createField.name = String.valueOf(fieldResult.getLabel());
                                    if(String.valueOf(item.behavior) =='Required'){
                                        createField.req = true;
                                    }                    
                                    createWrap.add(createField);  
                                }
                            }
                        } 
                        ColumnWrapper columnWrap = new ColumnWrapper();
                        columnWrap.columnName = 'column'+i;
                        columnWrap.fields = createWrap;
                        listColumnWrap.add(columnWrap);
                        i++;
                    }
                    SectionWrapper createSec = new SectionWrapper();
                    createSec.sectionName = section.label;
                    createSec.columns = listColumnWrap;
                    secListWrap.add(createSec);      
                }            
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ShowFieldOnEditPageOverrideFLS', 'returnlayout', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }    
        
        return secListWrap;
    }
    
    
    
    /*
* @description : This method is update (FLS) Field level security .
* @param : List<String> listOfField, String objectNames, String profileNames, Boolean readPermission, Boolean editPermission.	
* @return : N/A.
*/ 
    @AuraEnabled
    public static List<MetadataService.SaveResult> updateFieldLevelSecurity(List<String> fieldList, String objectNames, String profileNames, Boolean readPermission, Boolean editPermission)
    {   
        System.debug('fieldList------->'+fieldList);
        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();
        try{
            if(objectNames != NULL && profileNames != NULL && readPermission != NULL && editPermission != NULL && !fieldList.isEmpty()){
                MetadataService.MetadataPort service = CustomListView.createService();
                MetadataService.Profile profilePermission = new MetadataService.Profile();  
                profilePermission.fullName = profileNames;
                profilePermission.custom = false;
                List<MetadataService.ProfileFieldLevelSecurity> profileFieldPermission = new List<MetadataService.ProfileFieldLevelSecurity>();       
                for(String iterateField : fieldList){
                    MetadataService.ProfileFieldLevelSecurity fieldSecurity = new MetadataService.ProfileFieldLevelSecurity();
                    fieldSecurity.field = objectNames+'.'+iterateField;              
                    fieldSecurity.readable = readPermission;
                    fieldSecurity.editable = editPermission;
                    profileFieldPermission.add(fieldSecurity);
                    profilePermission.fieldPermissions  = new MetadataService.ProfileFieldLevelSecurity[] {fieldSecurity} ;
                        results = service.updateMetadata(new MetadataService.Metadata[] { profilePermission });
                    System.debug(profilePermission);
                }     
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ShowFieldOnEditPageOverrideFLS', 'updateFieldLevelSecurity', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return results;
    }  
    
    
    /*
* @description : This method is for return Record Type with their RecordTypeId.
* @param : String objectName.
* @return : Map<String, String>.
*/  
    @AuraEnabled
    public static List<sObject> getRecordType(String objectName, String recordId) {
        List<sObject> recordTypeId = new List<sObject>();
        try{       
            if(objectName != NULL && recordId != NULL){
                String query = 'SELECT Name, RecordTypeId FROM '+objectName+' WHERE Id=\''+recordId+'\'';
                recordTypeId = Database.query(query);
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ShowFieldOnEditPageOverrideFLS', 'getRecordType', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return recordTypeId; 
    }
    
    public class LayoutWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class SectionWrapper{
        @AuraEnabled Public String sectionName;
        @AuraEnabled public List<ColumnWrapper> columns;
    }
    
    public class ColumnWrapper{
        @AuraEnabled  public String columnName;
        @AuraEnabled  public  List<FieldsWrapper> fields;                
    }
    
    public class FieldsWrapper{
        @AuraEnabled  public String name;
        @AuraEnabled  public String apiName;
        @AuraEnabled  public Boolean req;
        
    }
    
    
    
}