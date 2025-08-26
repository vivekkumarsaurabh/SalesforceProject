public class CountUploadFilesUsingTrigger {
    public static void countUploadedFiles(List<ContentDocumentLink> newContactList){   
        Set<Id> setOfIdLinkedEntity = new Set<Id>();
        Map<String, Integer> mapOfContactFileCount = new Map<String, Integer>();
        List<Contact> conListforUpdate = new List<Contact>(); 
        for(ContentDocumentLink iterateRecords : newContactList){  
            setOfIdLinkedEntity.add(iterateRecords.LinkedEntityId);
        }        
        for(AggregateResult storeDocLink  : [SELECT LinkedEntityId, COUNT(ContentDocumentId) countDocId FROM ContentDocumentLink WHERE LinkedEntityId IN:setOfIdLinkedEntity  GROUP BY LinkedEntityId]){            
            mapOfContactFileCount.put(String.valueOf(storeDocLink.get('LinkedEntityId')), Integer.valueOf(storeDocLink.get('countDocId')));
        }        
        for(Contact iterateCon : [SELECT Id,Document_Count__c FROM Contact WHERE Id IN :mapOfContactFileCount.keySet()]){
            Contact newCon = new Contact();
            if(mapOfContactFileCount.containsKey(iterateCon.Id)){
                newCon.Id = iterateCon.Id;
                newCon.Document_Count__c = mapOfContactFileCount.get(iterateCon.Id);
            }
            conListforUpdate.add(newCon);                
        }
        update conListforUpdate;
    }
    public static void deleteUpdateField(List<ContentDocument> oldContactList){        
        Set<Id> setOfIdContDoc = new Set<Id>();          
        List<Contact> conListforUpdate = new List<Contact>(); 
        Set<Id> setOfDocummentLinkedEntityId = new Set<Id>();
        Map<String, Integer> mapOfContactFileCount = new Map<String, Integer>();
        for(ContentDocument iterateRecords : oldContactList){  
            setOfIdContDoc.add(iterateRecords.Id);
        }        
        for (ContentDocumentLink files: [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN:setOfIdContDoc]){           
            setOfDocummentLinkedEntityId.add(files.LinkedEntityId);
        }                
        for(AggregateResult storeDocLink : [SELECT LinkedEntityId, COUNT(ContentDocumentId) countDocId FROM ContentDocumentLink WHERE LinkedEntityId IN:setOfDocummentLinkedEntityId  GROUP BY LinkedEntityId]){            
            mapOfContactFileCount.put(String.valueOf(storeDocLink.get('LinkedEntityId')), Integer.valueOf(storeDocLink.get('countDocId')));
        }
        for(Contact iterateCon : [SELECT Id, Document_Count__c FROM Contact WHERE Id IN :mapOfContactFileCount.keySet()]){
            Contact newCon = new Contact();
            if(mapOfContactFileCount.containsKey(iterateCon.Id)){
                newCon.Id = iterateCon.Id;
                newCon.Document_Count__c = mapOfContactFileCount.get(iterateCon.Id)-1;
            }
            conListforUpdate.add(newCon);                
        }
        update conListforUpdate;        
    }   
    
}