/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 12/01/2023
* @Description : LWC Apex Code of Mini Gallery.
******************************************************************/
public class MiniGallery {    
    /**************************************************************************************************************************
	* @description : This method is retrive all sObject.
	* @param : N/A.
	* @return : List<ObjectWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<ObjectWrapper> getSObjects(){
        List<ObjectWrapper> objectWrapperList = new List<ObjectWrapper>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            String name = objTyp.getDescribe().getName();
            String label = objTyp.getDescribe().getLabel();          
            ObjectWrapper createWrapper = new ObjectWrapper();
            createWrapper.label = label;
            createWrapper.value = name; 
            objectWrapperList.add(createWrapper);            
        }
        return  objectWrapperList;
    }    
    
    /**************************************************************************************************************************
	* @description : This method is get All records behalf of objectName.
	* @param : String objName.
	* @return : List<RecordWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<RecordWrapper> getAllRecords(String objName, String field){
        System.debug('field Name => '+ field);
        if(objName == null || String.isBlank(objName)){
            return NULL;
        }
        List<RecordWrapper> recordWrapperList = new List<RecordWrapper>();
        String query = 'SELECT Id, '+field+' FROM '+objName+' ORDER BY CreatedDate DESC LIMIT 10000';      
        List<sObject> listofRec = Database.query(query);
        for(sObject iterateRec : listofRec){          
            RecordWrapper createWrapper = new RecordWrapper();
            createWrapper.id = iterateRec.id;
            createWrapper.name = (String)iterateRec.get(field);
            recordWrapperList.add(createWrapper);   
        }
        return  recordWrapperList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is get search Object from all Object.
	* @param : String objName.
	* @return : List<RecordWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<ObjectWrapper> sObjectSearch(String searchKey){
        if(searchKey == null || String.isBlank(searchKey)){
            return NULL;
        }
        List<ObjectWrapper> wrapperList = new List<ObjectWrapper>();
        Map<String, Schema.SObjectType> objMap = Schema.getGlobalDescribe();     
        if(objMap.containsKey(searchKey)){
            List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{searchKey}); 
            String objectLabel = describeSobjectsResult[0].getLabel();
            String apiName = describeSobjectsResult[0].getName();
            ObjectWrapper createWrapper = new ObjectWrapper();
            createWrapper.label = objectLabel;
            createWrapper.value = apiName;
            wrapperList.add(createWrapper);
        }
        return wrapperList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is get All records behalf of searchKey.
	* @param : String objName, String searchKey.
	* @return : List<RecordWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<RecordWrapper> searchRecord(String objName, String searchKey){
        if(searchKey == null && objName == null || String.isBlank(searchKey) && String.isBlank(objName)){
            return NULL;
        }
        List<RecordWrapper> recordWrapperList = new List<RecordWrapper>();
        String searckVal = '\'%'+searchKey+'%\'';
        String query = 'SELECT Id, Name FROM '+objName+' WHERE Name LIKE '+searckVal+' ORDER BY CreatedDate DESC LIMIT 10000'; 
        List<sObject> listofRec = Database.query(query);
        for(sObject iterateRec : listofRec){
            RecordWrapper createWrapper = new RecordWrapper();
            createWrapper.Id = iterateRec.Id;
            createWrapper.name = (String)iterateRec.get('Name');
            recordWrapperList.add(createWrapper);            
        }
        return recordWrapperList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is get All Image.
	* @param : String objectId.
	* @return : List<ImageWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<ImageWrapper> getImage(String objectId){
        if(objectId == null || String.isBlank(objectId)){
            return NULL;
        }
        List<ContentDocumentLink> conVerList = [SELECT contentDocumentId, ContentDocument.FileType, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :objectId];
        String baseUrl = URL.getOrgDomainURL().toExternalForm()+'/';   
        String contentUrl = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=';        
        List<ImageWrapper> imageWrapperList = new List<ImageWrapper>();
        for(ContentDocumentLink iterateConVer : conVerList){            
            if(iterateConVer.ContentDocument.FileType == 'PNG' || iterateConVer.ContentDocument.FileType == 'JPG' || iterateConVer.ContentDocument.FileType == 'JPEG'){ 
                ImageWrapper createWrapper = new ImageWrapper();
                createWrapper.image = baseUrl + contentUrl + iterateConVer.ContentDocument.LatestPublishedVersionId;   
                createWrapper.link = '#';
                imageWrapperList.add(createWrapper); 
            }
        }
        return imageWrapperList;
    }     
    
    public class ObjectWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class RecordWrapper{
        @AuraEnabled public String id;
        @AuraEnabled public String name;
    }    
    
    public class ImageWrapper{
        @AuraEnabled public String image;
        @AuraEnabled public String link;
    } 
}