/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 24/11/2023
* @Description : Class to create CSV of related contact On Account with Batch Apex .
******************************************************************/
public class CreateContactCsvOnAcc implements Database.Batchable<sObject>, Database.stateful {
    /**************************************************************************************************************************
	* @description : This method is start method use for filter Associated contact from Account.
	* @param : database.BatchableContext.
	* @return : List<Account>.
	***************************************************************************************************************************/    
    public Database.QueryLocator start(Database.BatchableContext batchContext){
        Set<String> allFields = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().keySet();
        String contactRec = 'SELECT '+String.join(allFields, ',')+' FROM Contact WHERE AccountId != NULL AND Account.CreateCsv__c = true';        
        return Database.getQueryLocator(contactRec);
    }
    
    /**************************************************************************************************************************
	* @description : This method is execute method use for create Csv on Account .
	* @param : Database.BatchableContext, List<Account>.
	* @return : N/A.
	***************************************************************************************************************************/
    public void execute(Database.BatchableContext batchContext, List<Contact> contactList){         
        Set<String> allFields = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().keySet();
        List<ContentVersion> listOfConVer = new List<ContentVersion>(); 
        Map<Id, List<String>> mapOfheader = new Map<Id, List<String>>();        
        Map<Id, String> mapOfListOfContactData = new Map<Id, String>();       
        List<ContentDocumentLink> newConDoclinklist = new List<ContentDocumentLink>(); 
        for(Contact iterateCon : contactList){
            List<String> listOffields = new List<String>();
            if(mapOfheader.containskey(iterateCon.AccountId)){
                listOffields = mapOfheader.get(iterateCon.AccountId);
            }
            for(String iterateField : allFields){
                if(iterateCon.get(iterateField) != NULL && !listOffields.contains(iterateField)){                    
                    listOffields.add(iterateField);
                } 
            }
            mapOfheader.put(iterateCon.AccountId, listOffields);
        }          
        for(Contact iterateCon : contactList){  
            String data = '';
            List<String> contactRecData = new List<String>();
            if(mapOfListOfContactData.containsKey(iterateCon.AccountId)){               
                data = mapOfListOfContactData.get(iterateCon.AccountId);             
            }
            for(String iterateField : mapOfheader.get(iterateCon.AccountId)){              
                Object val = iterateCon.get(iterateField); 
                String str = String.valueOf(val);    
                contactRecData.add(str);                
            }
            data += String.valueOf(String.join(contactRecData, ',')) + '\n';
            mapOfListOfContactData.put(iterateCon.AccountId, data);            
        }         
        for(Id accIdKey : mapOfListOfContactData.keySet()){  // Create contentVersion
            String header = String.join(mapOfheader.get(accIdKey), ',')+'\n';
            ContentVersion csvNew = new ContentVersion();
            csvNew.FirstPublishLocationId = accIdKey;
            csvNew.ContentLocation = 'S';
            csvNew.Title = accIdKey; 
            csvNew.PathOnClient = '.csv';     
            csvNew.IsMajorVersion = false;
            csvNew.VersionData = Blob.valueOf(header + mapOfListOfContactData.get(accIdKey)); 
            listOfConVer.add(csvNew);
        } 
        try { 
            if(listOfConVer != NULL){
                insert listOfConVer;
            }
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }       
        
        
    }
    
    /**************************************************************************************************************************
	* @description : This method is finish method used to know about our Batch execution are finish.
	* @param : Database.BatchableContext.
	* @return : N/A.
	***************************************************************************************************************************/
    public void finish(Database.BatchableContext batchContext){
        System.debug('Finish Our Batch Job');            
    }
}