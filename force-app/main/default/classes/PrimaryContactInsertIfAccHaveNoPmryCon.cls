public class PrimaryContactInsertIfAccHaveNoPmryCon {
    public static void primaryContactInsert(List<Contact> listOfNewContactForInsert){
        Map<Id, Contact> mapOfCon = new Map<Id, Contact>();
        for(Contact con1: listOfNewContactForInsert){          
            if(con1.Primary_Contact__c){            
                if(mapOfCon.containskey(con1.AccountId)){              
                    mapOfCon.get(con1.AccountId).addError('Primary Contact Exist');                    
                }
                mapOfCon.put(con1.AccountId,con1); 
            }           
        }        
        for(Contact ConPrimary: [SELECT Id, Name, AccountId, Primary_Contact__c FROM Contact WHERE AccountId IN: mapOfCon.keySet() AND Primary_Contact__c = true]){
            if(mapOfCon.containskey(ConPrimary.AccountId)){                
                mapOfCon.get(ConPrimary.AccountId).addError('Primary Contact Exist');               
            }
        }        
    }
    
    public static void primaryContactUpdateMethod(List<Contact> listOfNewContactForUpdate){        
        Map<Id, Contact> mapOfCon = new Map<Id, Contact>();
        for(Contact conOflstOfCon: listOfNewContactForUpdate){          
            if(conOflstOfCon.Primary_Contact__c){            
                if(mapOfCon.containskey(conOflstOfCon.AccountId)){              
                    mapOfCon.get(conOflstOfCon.AccountId).addError('Primary Contact Exist');                    
                }                 
                mapOfCon.put(conOflstOfCon.AccountId,conOflstOfCon); 
            }          
        } 
        for(Contact ConPrimary: [SELECT Id, Name, AccountId, Primary_Contact__c FROM Contact WHERE AccountId IN: mapOfCon.keySet() AND Primary_Contact__c = true]){
            Contact conPre = mapOfCon.get(ConPrimary.AccountId); 
            if(mapOfCon.containskey(ConPrimary.AccountId)){
                if(listOfNewContactForUpdate.size()>1){
                    if(ConPrimary.Id == conPre.Id){
                        mapOfCon.get(ConPrimary.AccountId).addError('Primary Contact Exist'); 
                    }
                }else{
                    mapOfCon.get(ConPrimary.AccountId).addError('Primary Contact Exist');
                }
            }   
        }        
    }
    
    public static void primaryContactDeleteMethod(List<Contact> listOfOldContactForDelete){      
        Map<Id,Contact> mapOfCon = new Map<Id,Contact>();
        for(Contact con: listOfOldContactForDelete){
            if(con.Primary_Contact__c){
                mapOfCon.put(con.AccountId,con);
            }
        }
        List<Contact> listOfCon = new List<Contact>();        
        for(Contact singleCon: [SELECT Id, AccountId, Name, Primary_Contact__c FROM Contact WHERE AccountId IN: mapOfCon.keySet() AND Primary_Contact__c = false ORDER BY CreatedDate ASC LIMIT 1]){      
            Contact conUpdate=new Contact();
            if(mapOfCon.containsKey(singleCon.AccountId)){              
                conUpdate.Id=singleCon.Id; 
                conUpdate.Primary_Contact__c=true;               
            }
            listOfCon.add(conUpdate);          
        }
        update listOfCon; 
    }
    
}