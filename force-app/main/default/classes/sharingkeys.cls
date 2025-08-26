public with sharing class sharingkeys {
 
    public static void methods(){
        System.debug('testing');
    }
    
    
/** public without sharing class Share{
    public void meth(){
        
        System.debug('test2');
    }
    
     
    }**/
    
    public static void getAccountRecord(){
        List<Account> acc = [SELECT Id FROM Account];
        System.debug('Account List Size For User Perspective => '+acc.size());
    }
  
   
    
}