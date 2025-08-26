public class CreateCSVfileOnInsertAcc {
    public static void createCSVfileInsertAfterInsert(List<Account> newlistAcc){  
        List<ID> listOfAccId = new List<ID>(); //initialise listOfAccId
        Map<Id, String> mapOfData = new Map<Id, String>();  
        List<ContentVersion> listOfConVer = new List<ContentVersion>();   
        List<Schema.FieldSetMember> fieldSetMemberList = SObjectType.Account.FieldSets.Account_Req_Fields.getFields();        
        List<String> listofFields = new List<String>();        
        List<ContentDocumentLink> newConDoclinklist = new List<ContentDocumentLink>();     
        Integer Counter = 0;
        Set<Id> setOfIdOfConVer = new Set<Id>();    
        
        for(FieldSetMember itereateFieldSet : fieldSetMemberList){  //iterate FieldSetMember and add to a list
            listofFields.add(itereateFieldSet.getFieldPath());            
        }
        String header = String.join(listofFields,',')+'\n';  //Define csv header      
        for(Account iterateAcc : newlistAcc){   // iterate new Acc list and put AccId And put as Key Of Map and data put in MapValues
            List<String> listOfRecord = new List<String>();
            for(String iterateField : listofFields){               
                Object val = iterateAcc.get(iterateField); 
                listOfRecord.add(String.valueOf(val));
            }
            String data = header + String.valueOf(String.join(listOfRecord, ','));
            mapOfData.put(iterateAcc.Id, data);
            listOfAccId.add(iterateAcc.Id);
        }
        System.debug(listOfAccId);
        for(Account iterateAcc :newlistAcc){  // Create contentVersion 
            if(mapOfData.containsKey(iterateAcc.Id)){
                ContentVersion csvNew = new ContentVersion();
                csvNew.ContentLocation = 'S';
                csvNew.Title = iterateAcc.Name; 
                csvNew.PathOnClient = '.csv';     
                csvNew.IsMajorVersion = false; 
                csvNew.VersionData = Blob.valueOf(mapOfData.get(iterateAcc.Id)); 
                listOfConVer.add(csvNew);
            }  
        }        
        insert listOfConVer; //insert list of content version
        for(ContentVersion iterateCon : listOfConVer){  // Iterate inserted content version and put contentVersion Id in Set         
            setOfIdOfConVer.add(iterateCon.Id);            
        }          
        for(ContentVersion iterateConDocLink  :[SELECT Id, ContentLocation, ContentDocumentId FROM ContentVersion WHERE Id IN : setOfIdOfConVer ORDER BY CreatedDate ASC]){ // Iterate From ContentVerion and put LinkeEntityId and Create CondentDocLink       
            ContentDocumentLink newConDocLink = new ContentDocumentLink();               
            newConDocLink.LinkedEntityId = listOfAccId.get(Counter);
            newConDocLink.ContentDocumentId = iterateConDocLink.ContentDocumentId;
            newConDocLink.ShareType = 'I';          
            newConDoclinklist.add(newConDocLink);
            Counter++;
        } 
       // Database.insert(newConDoclinklist,false);       
    }
    
    public static void updateCSVfileAfterUpdate(List<Account> newAccUpdateList){
        List<Schema.FieldSetMember> fieldSetMemberList = SObjectType.Account.FieldSets.Account_Req_Fields.getFields();  
        Set<Id> setOfAccId = new Set<Id>();       
        Map<Id, String> mapOfAccData = new Map<Id, String>();
        Set<Id> contentDocId = new Set<Id>();        
        List<Id> contentVersionId = new List<Id>();   
        List<String> listofFields = new List<String>();
        String header = String.join(listofFields,',')+'\n';  //Define csv header 
        List<ContentVersion> listOfConVer = new List<ContentVersion>();
        Integer counter = 0;
        
        for(Account iterateAcc : newAccUpdateList){
            setOfAccId.add(iterateAcc.Id);
        }
        for(FieldSetMember itereateFieldSet : fieldSetMemberList){  //iterate FieldSetMember and add to a list
            listofFields.add(itereateFieldSet.getFieldPath());            
        }       
        for(Account iterateAcc : newAccUpdateList){   // iterate new Acc list and put AccId And put as Key Of Map and data put in MapValues
            List<String> listOfRecord = new List<String>();
            for(String iterateField : listofFields){               
                Object val = iterateAcc.get(iterateField); 
                listOfRecord.add(String.valueOf(val));                
            }
            String data = header + String.valueOf(String.join(listOfRecord, ','));
            mapOfAccData.put(iterateAcc.Id, data);           
        } 
        for(ContentDocumentLink iterateDocLink : [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN : setOfAccId]){ //iterate conDocLink find LinkedEntityId
            contentDocId.add(iterateDocLink.ContentDocumentId);                      
        }     
        for(ContentVersion iterateContVersion : [SELECT Id FROM ContentVersion WHERE ContentDocumentId IN:contentDocId ORDER BY CreatedDate ASC]){ //iterate contentVersion store conDocId
            contentVersionId.add(iterateContVersion.Id);                      
        }    
        for(Account iterateAcc : newAccUpdateList){ //iterate Acc for update ConVersion
            if(mapOfAccData.containsKey(iterateAcc.Id)){
                ContentVersion newConVer = new ContentVersion();
                newConVer.Id = contentVersionId[counter]; 
                newConVer.Title =  iterateAcc.Name;
                newConVer.VersionData = Blob.valueOf(mapOfAccData.get(iterateAcc.Id));                
                listOfConVer.add(newConVer);
                counter++;
            }           
        }  
        Database.update(listOfConVer, false);      
    }    
}