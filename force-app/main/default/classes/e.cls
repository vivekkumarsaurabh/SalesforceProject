public class e {

    public static void methodOfAccountIdWithContactEmailCount(){
        Map<Id,Map<String,Integer>> MapOfAccountIdWithContactEmailCount=new Map<Id,Map<String,Integer>>();
         
        for(Contact con: [SELECT AccountId,Email FROM Contact WHERE AccountId!=NULL AND Email!=NULL]){
            Map<String,Integer> MapOfContactEmailCount =new  Map<String,Integer>();
            Integer Count=0;
            if(MapOfAccountIdWithContactEmailCount.containsKey(con.AccountId)){
                MapOfContactEmailCount=MapOfAccountIdWithContactEmailCount.get(con.AccountId);
                
                if(MapOfContactEmailCount.containsKey(con.Email)){
                    Count=MapOfContactEmailCount.get(con.Email);                 
                }
                    MapOfContactEmailCount.put(con.Email,Count+1);
                              
            }else{
                MapOfAccountIdWithContactEmailCount.put(con.AccountId,MapOfContactEmailCount);
            }           
            
          
        }
        
        for(Id Key :MapOfAccountIdWithContactEmailCount.keySet()){
            System.debug('keys--->'+Key+'Values---->'+MapOfAccountIdWithContactEmailCount.get(Key));
        }
       

    }
}