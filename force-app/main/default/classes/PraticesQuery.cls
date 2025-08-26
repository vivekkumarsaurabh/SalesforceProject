public class PraticesQuery {
    public static void methods(){
        //parent to child
   /**   List<sObject> s=[SELECT Id,Name,(SELECT Name FROM Contacts) FROM Account LIMIT 10];
      
     //   Account s=new Account(Name='NewAcc1');
      //  inser
        for(sObject k: s){
            
      //  System.debug(k);
            
         
        }
        //custom parent to child
        List<sObject> ss=[SELECT Name,(SELECT Name FROM Floors__r) FROM Building__c];
       // System.debug(ss);**/
           
         
        LIST<Account> acc=[SELECT Id, Name FROM Account WHERE NAME = NULL LIMIT 1];
       // System.debug(acc);
        
            /**  List<sObject> op=[SELECT Opportunity.Account.Name,SUM(Amount) opor FROM Opportunity GROUP BY Opportunity.Account.Name HAVING SUM(Amount)>=20000];
        for(sObject o: op){
            System.debug(o);
        }**/
        
     /**   List<sObject> op=[SELECT Name,(SELECT Account.Name FROM Opportunities) FROM Account];
        for(Account o: op){
            for(Opportunity o1: o.Name){
                
            }
        }**/
      /**  for(sObject o1: op){
            
            System.debug(o);
        }**/
      Map<String, Account_Mapping__mdt> mapEd = Account_Mapping__mdt.getAll();
        System.debug('data-->'+mapEd);
        
    }
}