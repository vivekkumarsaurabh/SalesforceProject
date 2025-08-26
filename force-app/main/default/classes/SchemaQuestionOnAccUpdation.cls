public class SchemaQuestionOnAccUpdation {
    
    public static void mainMethod(){
        
       List<Account> listOfAllAccount=new List<Account>();
        List<Account> lisAcc=[SELECT Id,Name,Rating FROM Account WHERE Rating!=NULL LIMIT 5];
        for(Account acc: lisAcc){
            System.debug(acc);
            listOfAllAccount.add(updateName(acc));
            listOfAllAccount.add(updateRating(acc));
        }
     
        try{
            update listOfAllAccount;
        }catch(Exception e){
            if(e.getMessage().containsIgnoreCase('Duplicate Id')){
               updationHandling(listOfAllAccount);
            }
           
        }
       
        
    }         
    public static Account updateName(Account acc){
        Account ac=acc;
        String str=acc.Name.left(1);
        //System.debug(str);
        ac.Name = acc.Name+str;
        return ac;      
    }
    public static Account updateRating(Account acc){
         Account ac=acc;
        if(ac.Rating=='Hot'){
            ac.Rating='Cold';
        }else if(ac.Rating=='Cold'){
            ac.Rating='Warm';
        }else{
            ac.Rating='Warm';
        }
         
       return ac; 
    }
    
    public static void updationHandling(List<Account> listOfAccount){
      Map<Id,Account> mapOfvaObject=new Map<Id,Account>();
        mapOfvaObject.putAll(listOfAccount);       
        if(mapOfvaObject.size()>0){
          update mapOfvaObject.values();  
        }
               
    }
}