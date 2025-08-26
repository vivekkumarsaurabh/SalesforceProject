@isTest
public class PrimaryConIfAccNoPrmyConDataFactory {
    public static List<Account> insertNewAcc(Integer noOfAcc, String Name, String Rating){
        List<Account> listOfAcc = new List<Account>();
        for(Integer i = 1; i <= noOfAcc; i++){
            Account createAcc = new Account();
            createAcc.Name = Name;
            createAcc.Rating = Rating;
            listOfAcc.add(createAcc);
        }
        Database.insert(listOfAcc, false);
        return listOfAcc;
    }
    public static List<Contact> insertNotPrimeryConinAcc(List<Account> listOfAcc, Integer noOfRecord, String LastName, Boolean primaryCon){
        List<Contact> listOfnewCon = new List<Contact>(); 
        List<Id> lisOfAccI = new List<Id>();
        for(Account accIterate : listOfAcc){
            lisOfAccI.add(accIterate.Id);
        }
        List<Contact> liOfCon = [SELECT AccountId FROM Contact WHERE AccountId IN :lisOfAccI AND Primary_Contact__c = true];       
        if(liOfCon.size()==0){
            for(Id accIterate : lisOfAccI){                
                for(Integer i = 1; i <= noOfRecord; i++){
                    Contact createCon = new Contact();
                    createCon.AccountId = accIterate;
                    createCon.LastName = LastName;
                    createCon.Primary_Contact__c = primaryCon;
                    listOfnewCon.add(createCon);                    
                }                
            }
        }else if(noOfRecord == 1){
            for(Id accIterate : lisOfAccI){ 
                Contact createCon = new Contact();
                createCon.AccountId = accIterate;
                createCon.LastName = LastName;
                createCon.Primary_Contact__c = primaryCon;
                listOfnewCon.add(createCon);
            }
        }
        return listOfnewCon;    
    }   
    
    public static List<Contact> insertPrimeryConinAcc(List<Account> listOfAcc, Integer noOfRecord, String LastName, Boolean primaryCon){
        List<Contact> listOfnewCon = new List<Contact>();
        List<Id> liOfId = new List<Id>(); 
        for(Contact iterateObj : [SELECT AccountId,Primary_Contact__c FROM Contact WHERE AccountId IN:listOfAcc AND Primary_Contact__c = true]){
            liOfId.add(iterateObj.AccountId);
        } 
        if(liOfId.size()>0){
            for(Id iterateId : liOfId){
                for(Integer i = 1; i <= noOfRecord; i++){
                    Contact createCon = new Contact();
                    createCon.AccountId = iterateId;
                    createCon.LastName = LastName;
                    createCon.Primary_Contact__c = primaryCon;
                    listOfnewCon.add(createCon);                    
                }
            }
        }
        return listOfnewCon;    
    }  
    public static List<Contact> updateContact(Set<Id> listOfConId, String LastName, Boolean primaryCon){
        List<Contact> listOfConforUpdate = new List<Contact>();        
        for(Contact con :[SELECT Id FROM Contact WHERE Id IN: listOfConId]){
            Contact createCon = new Contact();
            createCon.Id = con.Id;
            createCon.LastName = LastName;
            createCon.Primary_Contact__c = primaryCon;
            listOfConforUpdate.add(createCon);
        }                 
        return listOfConforUpdate;        
    }
    
    public static List<Contact> updateContactPrimry(Set<Id> listOfConId, String LastName, Boolean primaryCon){          
        List<Contact> listOfConforUpdate = new List<Contact>();                  
        for(Contact con :[SELECT Id FROM Contact WHERE Id IN: listOfConId]){
            Contact createCon = new Contact();
            createCon.Id = con.Id;
            createCon.LastName = LastName;
            createCon.Primary_Contact__c = primaryCon;
            listOfConforUpdate.add(createCon);
        }
        return  listOfConforUpdate;
    } 
    
    public static List<Contact> updateContacts(List<Contact> listOfCon, Boolean primaryCon){          
        List<Contact> listOfConforUpdate = new List<Contact>();                  
        for(Contact con : listOfCon){
            Contact createCon = new Contact();
            createCon.Id = con.Id;
            createCon.LastName = con.LastName;
            createCon.Primary_Contact__c = primaryCon;
            listOfConforUpdate.add(createCon);
        }
        return  listOfConforUpdate;
    }
    
    
}