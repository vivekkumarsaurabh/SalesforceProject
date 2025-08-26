/*
* @author      : Vivek Kumar Saurabh
* @date        : 26/12/2023
* @Description : LWC Apex Code Describe Object Layout.
*/
public with sharing class DecribeSObjectHandler {     
    /*
* @description : This method is for return Object Map.
* @param : N/A.
* @return : Map<String,String>.
*/  
    @AuraEnabled(cacheable=true)
    public static List<ObjectWrapper> getSObjects(){
        List<ObjectWrapper> objectWrapperList = new List<ObjectWrapper>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            String name = objTyp.getDescribe().getName();
            String label = objTyp.getDescribe().getLabel();
            if(objTyp.getDescribe().getRecordTypeInfos().size() > 0){ 
                ObjectWrapper createWrapper = new ObjectWrapper();
                createWrapper.label = label;
                createWrapper.value = name; 
                objectWrapperList.add(createWrapper);
            } 
        }
        return  objectWrapperList;
    }
    
    /*
* @description : This method is for return Record Type with their RecordTypeId.
* @param : String objectName.
* @return : Map<String, String>.
*/  
    @AuraEnabled(cacheable=true)
    public static List<RecordTypeWrapper> returnRecordTypeName(String objectName){     
        List<RecordTypeWrapper> recordTypeWrapperList = new List<RecordTypeWrapper>();
        if(objectName != NULL){
            List<RecordType> recordTypeList = [SELECT Id, Name FROM RecordType WHERE sObjectType=:objectName AND Id != NULL AND Name != NULL];
            if(!recordTypeList.isEmpty()){
                for(RecordType iterateRec : recordTypeList){ 
                    RecordTypeWrapper createWrapper = new RecordTypeWrapper();
                    createWrapper.label = iterateRec.Name;
                    createWrapper.value = iterateRec.Id;
                    recordTypeWrapperList.add(createWrapper);
                }
            }
        }
        if(recordTypeWrapperList.isEmpty()){
            return recordTypeWrapperList;
        }else{
            return recordTypeWrapperList;  
        } 
        
    }
    
    /*
* @description : This method is for return method to take endpoint and method.
* @param : String query.
* @return : String.
*/ 
    @AuraEnabled
    public static String toolingAPISOQL(String query) {
        //String baseURL = 'https://algocirruspvtltd-6d-dev-ed.develop.my.salesforce.com';   
        String sfdcBaseURL = URL.getOrgDomainURL().toExternalForm();    
        return restGet( sfdcBaseURL + '/services/data/v58.0/tooling/query?q='+ (query.replace(' ', '+')) , 'GET');
    }
    
    /**************************************************************************************************************************
* @description : This method is for return name of pageLayout.
* @param : String recordId.
* @return : String.
***************************************************************************************************************************/ 
    @AuraEnabled
    public static List<layoutWrapper> getLayoutName(String recordId) {
        List<layoutWrapper> layoutWrapperList = new List<layoutWrapper>();
        if(recordId != NULL){
            String query  = 'select Layout.Name from ProfileLayout where ProfileId = \''+UserInfo.getProfileId()+'\' AND RecordTypeId =\''+recordId+'\'';   
            // String query  = 'select Layout.Name from ProfileLayout where ProfileId = \'00eJ4000000DemIIAS\' AND RecordTypeId =\''+recordId+'\'';
            String body = toolingAPISOQL(query);
            System.debug('body===>'+body);
            System.debug(LoggingLevel.ERROR, '@@@ body: ' + body );
            String name = body.substringBetween('"Name":"', '"');     
            layoutWrapper createLayout = new layoutWrapper();
            createLayout.label = name;
            createLayout.value = name;
            layoutWrapperList.add(createLayout);
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
        HttpRequest httpReq = new HttpRequest();
        httpReq.setHeader('Authorization', 'Bearer ' + apiEnabledSessionId());
        httpReq.setHeader('Content-Type','application/json');
        httpReq.setEndpoint(endPoint);
        httpReq.setMethod(method);
        HttpResponse res = http.send(httpReq);
        System.debug(res.getStatusCode());
        return res.getBody();
    }  
    
    /*
* @description : This method is for return SessionId.
* @param : N/A.
* @return : String.
*/ 
    private static String apiEnabledSessionId(){        
        String vfContent = '';
        Integer startIndex;
        Integer endIndex;
        try{
            PageReference sessionPage = Page.SessionId;
            vfContent = Test.isRunningTest() ? 'Start_Of_Session_IdSESSION_ID_REMOVEDEnd_Of_Session_Id': sessionPage.getContent().toString();
            startIndex = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length();
            endIndex = vfContent.indexOf('End_Of_Session_Id');    
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('DecribeSObjectHandler', 'apiEnabledSessionId', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return vfContent.substring(startIndex, endIndex);
    }
    
    /*
* @description : This method is for return layout Section Wrapper.
* @param : String layoutName.
* @return : List<sectionWrapper>.
*/ 
    @AuraEnabled
    public static List<sectionWrapper> returnlayout(String layoutName){ 
        List<sectionWrapper> secListWrap = new List<sectionWrapper>();
        if(layoutName != NULL){
            List<String> liofObject = layoutName.split('\\-');
            List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {layoutName});
            System.debug('layouts--->'+layouts);
            Metadata.Layout layoutMd = (Metadata.Layout) layouts.get(0); 
            for (Metadata.LayoutSection section : layoutMd.layoutSections) { 
                Integer i = 1;        
                List<columnWrapper> listColumnWrap = new List<columnWrapper>();
                for (Metadata.LayoutColumn column : section.layoutColumns) {                 
                    List<FieldsWrapper> createWrap = new List<FieldsWrapper>();
                    if (column.layoutItems != null) {                    
                        for (Metadata.LayoutItem item : column.layoutItems) {                                                        
                            Schema.SObjectType objName = Schema.getGlobalDescribe().get(liofObject[0]);                                                  
                            Map<String, Schema.SObjectField> mfields = objName.getDescribe().fields.getMap();                   
                            if(mfields.containsKey(item.field)){
                                Schema.DescribeFieldResult fieldResult = mfields.get(item.field).getDescribe();
                                FieldsWrapper createField = new FieldsWrapper();                        
                                createField.apiName = String.valueOf(fieldResult.getLocalName());
                                createField.name = String.valueOf(fieldResult.getLabel());
                                if(String.valueOf(item.behavior) == 'Required'){
                                    createField.req = true;
                                }                    
                                createWrap.add(createField);  
                            }
                        }
                    } 
                    columnWrapper columnWrap = new columnWrapper();
                    columnWrap.columnName = 'column'+i;
                    columnWrap.fields = createWrap;
                    listColumnWrap.add(columnWrap);
                    i++;
                }
                sectionWrapper createSec = new sectionWrapper();
                createSec.sectionName = section.label;
                createSec.columns = listColumnWrap;
                secListWrap.add(createSec);      
            }  
        }
        return secListWrap;
    }
    
    public class ObjectWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class RecordTypeWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class layoutWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class sectionWrapper{
        @AuraEnabled Public String sectionName;
        @AuraEnabled public List<columnWrapper> columns;
    }
    
    public class columnWrapper{
        @AuraEnabled  public String columnName;
        @AuraEnabled  public  List<FieldsWrapper> fields;                
    }
    
    public class FieldsWrapper{
        @AuraEnabled  public String name;
        @AuraEnabled  public String apiName;
        @AuraEnabled  public Boolean req;
        
    }
    
}