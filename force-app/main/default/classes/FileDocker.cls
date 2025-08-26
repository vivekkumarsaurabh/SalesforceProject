/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 02/01/2023
* @Description : LWC Apex Code of File Docker.
******************************************************************/
public class FileDocker {
    /**************************************************************************************************************************
	* @description : This method is return a WrapperList of file details.
	* @param : String objectId.
	* @return : List<ContentVersionWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<ContentVersionWrapper> returnFiles(String objectId){
        Set<Id> contentDocId = new Set<Id>();
        for(ContentDocumentLink iterateConDocLink : [SELECT ContentDocumentId  FROM ContentDocumentLink WHERE LinkedEntityId = :objectId ]){
            contentDocId.add(iterateConDocLink.ContentDocumentId);
        }          
        List<ContentVersionWrapper> contVersList = new List<ContentVersionWrapper>();
        for(ContentVersion iterateConVersion : [SELECT contentDocumentId, title, contentSize, FileExtension, Createdby.Name FROM ContentVersion WHERE contentDocumentId IN: contentDocId]){
            ContentVersionWrapper createWrapper = new ContentVersionWrapper();
            createWrapper.title = iterateConVersion.title;
            createWrapper.conDocId = iterateConVersion.contentDocumentId;
            createWrapper.conSize = String.valueOf(iterateConVersion.contentSize);
            createWrapper.fileExtension = iterateConVersion.FileExtension;
            createWrapper.createdBy = iterateConVersion.Createdby.Name;
            createWrapper.fileLink = '/'+iterateConVersion.contentDocumentId;
            createWrapper.downloadLink = '/sfc/servlet.shepherd/document/download/'+iterateConVersion.contentDocumentId;
            if(iterateConVersion.FileExtension == 'jpg' || iterateConVersion.FileExtension == 'png' || iterateConVersion.FileExtension == 'jpeg'){
                createWrapper.extensionIcon = 'doctype:image';  
            }else if(iterateConVersion.FileExtension == 'xlsx'){
                createWrapper.extensionIcon = 'doctype:csv'; 
            }else if(iterateConVersion.FileExtension == 'docx'){
                createWrapper.extensionIcon = 'doctype:word';
            }else{
                createWrapper.extensionIcon = 'doctype:'+iterateConVersion.FileExtension;
            }            
            contVersList.add(createWrapper);
        }
        return contVersList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is delete single file.
	* @param : String docId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static void deleteFile(String docId){
        ContentDocument docFile = [SELECT ID FROM ContentDocument WHERE ID = :docId];
        Database.delete(docFile, false);      
    }
    
    /**************************************************************************************************************************
	* @description : This method is delete multiple files.
	* @param : List<String> docIds.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static void deleteFileAll(List<String> docIds){
       List<ContentDocument> docFileList = [SELECT ID FROM ContentDocument WHERE ID IN : docIds];
       Database.delete(docFileList, false);
    }
    
    /**************************************************************************************************************************
	* @description : This method is for return contentDocument.
	* @param : String docId.
	* @return : ContentDocument.
	***************************************************************************************************************************/
    @AuraEnabled
    public static ContentDocWrapper returnFileDetails(String docId){
        ContentDocWrapper createWrapper = new ContentDocWrapper();    
        for(ContentDocument iterateRec:  [SELECT title, Description, FORMAT(CreatedDate), FORMAT(LastModifiedDate) FROM ContentDocument WHERE ID = :docId]){      
        createWrapper.title = iterateRec.Title;
        createWrapper.descrip = iterateRec.Description;
        createWrapper.CreatedDate = String.valueOf(iterateRec.CreatedDate);
        createWrapper.LastModifiedDate = String.valueOf(iterateRec.LastModifiedDate);
        }
        return createWrapper;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for edit file details.
	* @param : String docId, String title, String description.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static void editFile(String docId, String title, String descrip){
        ContentDocument docFile = [SELECT ID FROM ContentDocument WHERE ID = :docId];
        docFile.Id = docId;
        docFile.Title = title;
        docFile.Description = descrip;
        Database.update(docFile, false);        
    }
    
    /**************************************************************************************************************************
	* @description : This method is searching.
	* @param : String searchVal, String recId.
	* @return : List<ContentVersionWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<ContentVersionWrapper> searchKey(String searchVal, String recId){       
        String searckKey = '%'+searchVal+'%';
        Set<Id> contentDocId = new Set<Id>();
        for(ContentDocumentLink iterateConDocLink : [SELECT ContentDocumentId  FROM ContentDocumentLink WHERE LinkedEntityId = :recId ]){
            contentDocId.add(iterateConDocLink.ContentDocumentId);
        }          
        List<ContentVersionWrapper> contVersList = new List<ContentVersionWrapper>();
        for(ContentVersion iterateConVersion : [SELECT contentDocumentId, title, contentSize, FileExtension, Createdby.Name FROM ContentVersion WHERE title LIKE :searckKey AND contentDocumentId IN:contentDocId]){
            ContentVersionWrapper createWrapper = new ContentVersionWrapper();
            createWrapper.title = iterateConVersion.title;
            createWrapper.conDocId = iterateConVersion.contentDocumentId;
            createWrapper.conSize = String.valueOf(iterateConVersion.contentSize);
            createWrapper.fileExtension = iterateConVersion.FileExtension;
            createWrapper.createdBy = iterateConVersion.Createdby.Name;
            createWrapper.fileLink = '/'+iterateConVersion.contentDocumentId;
            createWrapper.downloadLink = '/sfc/servlet.shepherd/document/download/'+iterateConVersion.contentDocumentId;
            if(iterateConVersion.FileExtension == 'jpg' || iterateConVersion.FileExtension == 'png' || iterateConVersion.FileExtension == 'jpeg'){
                createWrapper.extensionIcon = 'doctype:image';  
            }else if(iterateConVersion.FileExtension == 'xlsx'){
                createWrapper.extensionIcon = 'doctype:csv'; 
            }else if(iterateConVersion.FileExtension == 'docx'){
                createWrapper.extensionIcon = 'doctype:word';
            }else{
                createWrapper.extensionIcon = 'doctype:'+iterateConVersion.FileExtension;
            }            
            contVersList.add(createWrapper);
        }
        return contVersList;
    }
    
    public class ContentVersionWrapper{
        @AuraEnabled  public String title;
        @AuraEnabled  public String conDocId;
        @AuraEnabled  public String fileLink;
        @AuraEnabled  public String downloadLink; 
        @AuraEnabled  public String createdBy; 
        @AuraEnabled  public String extensionIcon;        
        @AuraEnabled  public String conSize;
        @AuraEnabled  Public String fileExtension;
    }
    
    public class ContentDocWrapper{
        @AuraEnabled  public String title;
        @AuraEnabled  public String descrip;
        @AuraEnabled  public String CreatedDate;
        @AuraEnabled  public String LastModifiedDate;         
    }
    
}