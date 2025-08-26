public class fileInsertByName {
    public static void insertFileByName(List<ContentVersion> newContentDocList){       
        List<ContentVersion> listOfConVer = new List<ContentVersion>();
        for(ContentVersion iterateRecords : newContentDocList){                 
            iterateRecords.Title = iterateRecords.Title + '_po';        
        }  
    } 
    public static void deleteFile(List<ContentVersion> newContDoc){      
        Set<Id> setOfIdNewDoc = new Set<Id>(); 
        Set<Id> idOfLinkedEntity = new Set<Id>();
        Set<Id> ContentDocIds = new Set<Id>();
        List<ContentDocument> ConDocLst = new  List<ContentDocument>();  
        for(ContentVersion idOfConVer : newContDoc){
            setOfIdNewDoc.add(idOfConVer.ContentDocumentId);            
        }
        for(ContentDocumentLink  iterateLinkedEntityId: [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN :setOfIdNewDoc]){
            idOfLinkedEntity.add(iterateLinkedEntityId.LinkedEntityId);
        }
        idOfLinkedEntity.remove(userInfo.getUserId());       
        for(ContentDocumentLink iterateDocumentId : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :idOfLinkedEntity]){
            ContentDocIds.add(iterateDocumentId.ContentDocumentId);
        }              
        for(ContentDocument cntDoc : [SELECT Id FROM ContentDocument WHERE Id IN: ContentDocIds AND ID NOT IN : setOfIdNewDoc]){                      
            ConDocLst.add(cntDoc);
        } 
        delete ConDocLst;  
    } 
}