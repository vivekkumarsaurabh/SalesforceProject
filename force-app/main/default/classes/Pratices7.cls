public class Pratices7 {

    //delete record
    
 {
  Account acc=[SELECT Id,Name From Account WHERE Name ='TTEST1' LIMIT 1];
      //  System.debug(acc);
   // delete acc; 
        
        //undelete k;
        
        Account p=[SELECT Id,Name From Account WHERE Name ='TTEST0' LIMIT 1];
       // System.debug(p);
       //merge p acc;
        
   
     // List<Account> k=[SELECT Id From Account WHERE Name ='higgh' ALL ROWS];
      //  undelete k;
        Account acc021 = new Account(Name= 'Vivek5');
       // insert acc021;
      //  delete acc021;
      //  undelete acc021;
    /**    List<Account> savedAccts = [SELECT Id, Name FROM Account WHERE Name = 'Vivek5' ALL ROWS];
        try{
            undelete savedAccts;  
        }catch(Exception e){
            System.debug('invalid '+e);
        }**/
      
        
    }
 
    public static void mthoodUndelete(){
      // Account acc=new Account(Name='acc12');
       // insert acc;
       Opportunity acc1=[SELECT Id , Name FROM Opportunity WHERE Name='Oppr1' ALL ROWS];
      // delete acc1;
        undelete  acc1;
    }
    
    public static void Coo(){
      //  Integer k=[SELECT COUNT() FROM Account];    
      //  System.debug(k);
        
     List<Contact> c=[SELECT FIELDS(STANDARD) FROM Contact];
       // System.debug(c);
        
  /**  LIST<Contact> co=[SELECT Firstname,Account.Name FROM Contact];
        for(Contact g:co){
            System.debug(g);
           
        } **/
      //  System.debug(co);
     /** String s='SELECT Account.Name, (SELECT Contact.LastName FROM Account.Contacts) FROM Account';
        List<Account> k= Connection.query(s);
        **/
     // List<Account> l= [SELECT Account.Name, (SELECT Contact.LastName FROM Account.Contacts) FROM Account]; 
      //  System.debug(l);
        
    //  List<Account> l=[SELECT FIELD(CUSTOM) FROM Account LIMIT 100]; //it is not use in apex . run only query editor
      //  System.debug(l);
      //  
      
      
       
        
        
    }
    
    
    
    
    
  
    
}