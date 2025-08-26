/*
* @Description : This class is used for field Accessibility;
* @author      : Vivek Kumar Saurabh
* @Created Date: 19/12/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 19/12/2024
*/
public class FieldAccessibilityTable {    
    /*
* @description : This method is getFieldAccessibility.
* @param : N/A.
* @return : N/A.
*/  
    public static void getViewByField(String sObjectName){    
        Map<String, Map<String, String>> profileFieldAccessMap = new  Map<String, Map<String, String>>(); 
        try{
            if(sObjectName != NULL){
                for(FieldPermissions iterateFieldPermission : [SELECT Id, ParentId, SobjectType, Field, PermissionsEdit, PermissionsRead, Parent.Profile.Name  FROM FieldPermissions WHERE SobjectType =:sObjectName]){         
                    Map<String, String> fieldAccessMap = new Map<String, String>();
                    String fieldAccess;
                    if(profileFieldAccessMap.containsKey(String.valueOf(iterateFieldPermission.Parent.Profile.Name))){
                        fieldAccessMap = profileFieldAccessMap.get(String.valueOf(iterateFieldPermission.Parent.Profile.Name)); 
                        if(fieldAccessMap.containsKey(String.valueOf(iterateFieldPermission.Field))){
                            fieldAccess = fieldAccessMap.get(iterateFieldPermission.Field);
                        }                
                    }
                    fieldAccess = String.valueOf(iterateFieldPermission.PermissionsEdit+'-'+iterateFieldPermission.PermissionsRead);
                    fieldAccessMap.put(String.valueOf(iterateFieldPermission.Field), fieldAccess);
                    profileFieldAccessMap.put(String.valueOf(iterateFieldPermission.Parent.Profile.Name), fieldAccessMap);            
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('FieldAccessibilityTable', 'getViewByField', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
    }
    
    
    
    /*
* @description : This method is for return Record Type with their RecordTypeId.
* @param : String objectName.
* @return : List<>.
*/  
    public static List<RecordTypeWrapper> returnRecordTypeName(String objectName){     
        List<RecordTypeWrapper> recordTypeWrapperList = new List<RecordTypeWrapper>();
        try{
            if(objectName != NULL){
                List<RecordType> recordTypeList = [SELECT Id, Name FROM RecordType WHERE sObjectType=:objectName AND Id != NULL AND Name != NULL];
                for(RecordType iterateRec : recordTypeList){ 
                    RecordTypeWrapper createWrapper = new RecordTypeWrapper();
                    createWrapper.label = iterateRec.Name;
                    createWrapper.value = iterateRec.Id;
                    recordTypeWrapperList.add(createWrapper);
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('FieldAccessibilityTable', 'returnRecordTypeName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            
        }
        if(recordTypeWrapperList.isEmpty()){
            return NULL;
        }else{
            return recordTypeWrapperList;  
        } 
        
    }
    
    
    /*
* @description : This method is getFieldAccessibility.
* @param : String sObjectName getting sobjectName as params.
* @return : N/A.
*/ 
    public static void getAllInformationFieldAccessibility(String sObjectName){
        Map<Id, Map<Id, Map<Id, Map<String, String>>>> profileRecordTypeLayoutFieldAccessibilityMap = new Map<Id, Map<Id, Map<Id, Map<String, String>>>>();
        Map<Id, Id> recordTypeLauoutMap = new Map<Id, Id>();
        List<Id> profileIdSet = new List <Id>{'00e5j000003pQzrAAE', '00eJ4000000DemIIAS'};
        List<Id> recordTypeSet = new List<Id>();
        List<RecordTypeWrapper> recordTypeWrapperList = returnRecordTypeName(sObjectName);        
        if(!recordTypeWrapperList.isEmpty()){
            for(RecordTypeWrapper iterateRecordType : recordTypeWrapperList){
                recordTypeSet.add(iterateRecordType.value);   
            }            
        }      
        List<LayoutWrapper> layoutWrapperList = getLayoutName(recordTypeSet, profileIdSet); 
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
    
    /*
* @description : This method is for return name of pageLayout.
* @param : String recordId.
* @return : String.
*/    
    public static List<LayoutWrapper> getLayoutName(List<Id> recordTypeIdSet, List<Id> profileIdSet) {
        List<LayoutWrapper> layoutWrapperList = new List<LayoutWrapper>();
        String query  = 'select Layout.Name, ProfileId, RecordTypeId from ProfileLayout where ProfileId  = \''+UserInfo.getProfileId()+'\' AND RecordTypeId =\'0125j000000eyIzAAI\'';   
        System.debug('query----->'+query);
        String body = toolingAPISOQL(query);
        System.debug(LoggingLevel.ERROR, '@@@ body: ' + body );
        String name = body.substringBetween('"Name":"', '"');     
        layoutWrapper createLayout = new layoutWrapper();
        createLayout.label = name;
        createLayout.value = name;
        layoutWrapperList.add(createLayout);
        return layoutWrapperList;
    }
    
    /*
* @description : This method is for hit with tooling API.
* @param : String endPoint, String method.
* @return : String.
*/ 
    @AuraEnabled
    public static String restGet(String endPoint, String method) {  
        System.debug('endPoint===>'+endPoint);
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
        PageReference sessionPage = Page.SessionId;
        String vfContent = sessionPage.getContent().toString();
        Integer startIndex = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length();
        Integer endIndex = vfContent.indexOf('End_Of_Session_Id');        
        return vfContent.substring(startIndex, endIndex);
    }
    
    
    public class RecordTypeWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class LayoutWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    
    
    
    
}