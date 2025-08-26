public class PracticesOnSoQl14 {
    
    public static void restrictedPicklist(){
        Account acc=new Account(Name='Restricted Picklist', Rating='Vivek');
        // insert acc;
        
        Account acc2=new Account(Name='Restricted Picklist_ON', Restricted_Picklist__c='OF');
        // insert acc2;
        
        /**   Map<Id,Map<String,Integer>> TotalContactONPhone =new Map<Id,Map<String,Integer>>();

for(Contact con:[SELECT AccountId,Phone FROM Contact WHERE AccountId!=NULL AND Phone!=NULL]){
Map<String,Integer> TotalContact = new Map<String,Integer>();
Integer Count=0;
if(TotalContactONPhone.containsKey(con.AccountId)){
TotalContact=TotalContactONPhone.get(con.AccountId);
if(TotalContact.containsKey(con.Phone)){
Count=TotalContact.get(con.Phone);

}
TotalContact.put(con.Phone,Count+1);

}else{
TotalContact.put(con.Phone,1);
}
TotalContactONPhone.put(con.AccountId,TotalContact);


}
for(Id Key: TotalContactONPhone.keySet()){
System.debug(key+'----->'+TotalContactONPhone.get(key));
}**/
        
  /**      Map<String,Map<String,List<String>>> MapOfAccountOfContactOfOpportunity = new Map<String,Map<String,List<String>>>();
        
        for(Contact cont :[SELECT Name,Account.Name,(SELECT Name FROM Opportunities WHERE AccountId!=NULL) FROM Contact WHERE AccountId!=NULL]){
            for(Opportunity oppor: cont.Opportunities){
                Map<String,List<String>> ItemsOfContactRelatedOpoortunity = new Map<String,List<String>>();        
                List<String> lstOfOpportunity=new List<String>();
                if(MapOfAccountOfContactOfOpportunity.containsKey(cont.Account.Name)){
                    ItemsOfContactRelatedOpoortunity=MapOfAccountOfContactOfOpportunity.get(cont.Account.Name);
                    if(ItemsOfContactRelatedOpoortunity.containsKey(cont.Name)){
                        lstOfOpportunity=ItemsOfContactRelatedOpoortunity.get(cont.Name);
                        lstOfOpportunity.add(oppor.Name);
                        ItemsOfContactRelatedOpoortunity.put(cont.Name,lstOfOpportunity);
                    }else{
                        ItemsOfContactRelatedOpoortunity.put(cont.Name,new List<String>{oppor.Name});
                    }
                }else{
                    ItemsOfContactRelatedOpoortunity.put(cont.Name,new List<String>{oppor.Name});  
                }
                MapOfAccountOfContactOfOpportunity.put(cont.Account.Name,ItemsOfContactRelatedOpoortunity);   
            }
        }
        for(String Key : MapOfAccountOfContactOfOpportunity.keySet()){
            System.debug(key+'------>'+MapOfAccountOfContactOfOpportunity.get(key));
        }
        
        
    }**/
        
   /** public static void subMapOfPractice(){
        Map<String,Map<String,List<String>>> MapOfAccountOfContactOfOpportunity = new Map<String,Map<String,List<String>>>();
        
        for(Contact cont :[SELECT Name,Account.Name,(SELECT Name FROM Opportunities WHERE AccountId!=NULL) FROM Contact WHERE AccountId!=NULL]){
            for(Opportunity oppor: cont.Opportunities){
                Map<String,List<String>> ItemsOfContactRelatedOpoortunity = new Map<String,List<String>>();        
                List<String> lstOfOpportunity=new List<String>();
                if(MapOfAccountOfContactOfOpportunity.containsKey(cont.Account.Name)){
                    ItemsOfContactRelatedOpoortunity=MapOfAccountOfContactOfOpportunity.get(cont.Account.Name);
                    if(ItemsOfContactRelatedOpoortunity.containsKey(cont.Name)){
                        lstOfOpportunity=ItemsOfContactRelatedOpoortunity.get(cont.Name);
                    }
                }
                lstOfOpportunity.add(oppor.Name);
                ItemsOfContactRelatedOpoortunity.put(cont.Name,lstOfOpportunity);
                MapOfAccountOfContactOfOpportunity.put(cont.Account.Name,ItemsOfContactRelatedOpoortunity);   
            }
        }
        for(String Key : MapOfAccountOfContactOfOpportunity.keySet()){
            System.debug(key+'------>'+MapOfAccountOfContactOfOpportunity.get(key));
        }
        }**/
        
    }
/**  public static void mapOfTotalOpportunity(){
        Map<String,Map<Id,List<String>>> mapOfaccWithconWithOpportunity=new Map<String,Map<Id,List<String>>>();
          
        for(Opportunity oppor : [SELECT Name,Account.Name, ContactId FROM Opportunity WHERE AccountId!=NULL AND ContactId!=NULL]){ 
            Map<Id,List<String>> mapOfContactWithOpportunity=new  Map<Id,List<String>>();
            List<String> OpportunityName=new List<String>();
            if(mapOfaccWithconWithOpportunity.containsKey(oppor.Account.Name)){
               mapOfContactWithOpportunity=mapOfaccWithconWithOpportunity.get(oppor.Account.Name);
                if(mapOfContactWithOpportunity.containsKey(oppor.ContactId)){
                  OpportunityName=mapOfContactWithOpportunity.get(oppor.ContactId);
                   OpportunityName.add(oppor.Name);
                    mapOfContactWithOpportunity.put(oppor.ContactId,OpportunityName);
                }else{
                    mapOfContactWithOpportunity.put(oppor.ContactId,new List<String>{oppor.Name});
                }                           
              
            }else{
                OpportunityName.add(oppor.Name);
                mapOfContactWithOpportunity.put(oppor.ContactId,OpportunityName);
                mapOfaccWithconWithOpportunity.put(oppor.Account.Name,mapOfContactWithOpportunity);
                
            }
            
        }
      for(String Key : mapOfaccWithconWithOpportunity.keySet()){
            System.debug('AccountId -->'+key+'---ContactID-->'+mapOfaccWithconWithOpportunity.get(key));
        }
 }**/
    //Not Completed
 /** public static void findOpportunity(){
        Map<String,Map<Id,List<String>>> mapOfAccWithConWithOpp = new  Map<String,Map<Id,List<String>>>();
       
        for(Contact con: [SELECT Id,AccountId(SELECT Name,AccountId FROM Opportunities WHERE AccountId!=NULL) FROM Contact WHERE AccountId!=NULL]){
            for(Opportunity oppor: con.Opportunities){
             if(oppor.AccountId=con.AccountId){
                List<String> ListOfOpportunity=new List<String>();
                Map<Id,List<String>> mapOfConOfOpp=new Map<Id,List<String>>();
                if(mapOfAccWithConWithOpp.containsKey(oppor.AccountId)){
                    mapOfConOfOpp=mapOfAccWithConWithOpp.get(oppor.Account.Name);
                    if(mapOfConOfOpp.containsKey(con.id)){
                        ListOfOpportunity=mapOfConOfOpp.get(con.id);
                                             
                    }                                         
                }
                    ListOfOpportunity.add(oppor.Name);
                    mapOfConOfOpp.put(con.Id,ListOfOpportunity);
                    mapOfAccWithConWithOpp.put(oppor.AccountId,mapOfConOfOpp);
                 }
            }
        }**/
       
      /** for(String Key : mapOfAccWithConWithOpp.keySet()){
           System.debug('Account Name-->'+Key+'---->'+mapOfAccWithConWithOpp.get(key));
       }**/
    //}
    
 /**   public static void findOpportunityWIthTwoQuery(){
        Map<String,Map<Id,List<String>>>
    }**/

}