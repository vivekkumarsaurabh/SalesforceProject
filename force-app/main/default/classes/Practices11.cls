public class Practices11 {

    public static void methods(){
       /** Account acc=[SELECT Name,Owner.Name,Createddate FROM Account WHERE Name='Vivek' LIMIT 1];
        
       System.debug(acc);**/
        
   /**     String s='vivek';
       integer l=0;
       
           String[] st=s.split('');
        for(string g:st){
            l++;
            
        }
      System.debug(l);**/
        
       // List<sObject> acc=[SELECT Rating,(SELECT LastName FROM Contacts) FROM Account];
    
      //  integer hot=0,warm=0,cold=0,nl=0;
     /**   for(sObject s: acc){
            if(s.get('Rating')=='Hot'){
                hot++;
            }else if(s.get('Rating')=='Warm'){
                warm++;
            }else if(s.get('Rating')=='Cold'){
                cold++;
            }else{
                nl++;
            }
            
        }**/
          List<Contact> acc=[SELECT Id,Contact.Account.Rating FROM Contact];
        Map<String,Integer> mapval = new Map<String,Integer>();
        integer count=0;
        
        for(Contact s: acc){
            
          mapval.put(s.Account.Rating,count++);
               
        }
    
       
        for(Contact s: acc){
            
        }
        
            
     
        
        //System.debug('Hot -->'+hot+'warm--->'+warm+'cold-->'+cold+'Null Values--->'+nl);
     
    }
}