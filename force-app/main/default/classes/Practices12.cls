public class Practices12 {
            public static void method(){
                   //  List<Contact> acc=[SELECT Id,Contact.Account.Rating FROM Contact WHERE AccountId!=NULL AND Email !=NULL];
                     // Map<String,Integer> mapval = new Map<String,Integer>();
                   // Integer count=0;
                  /** for(Contact c: acc){            
                        if(mapval.containsKey(c.Account.Rating)){              
                            mapval.put(c.Account.Rating,mapval.get(c.Account.Rating)+1);
                        }else{             
                            mapval.put(c.Account.Rating,count+1);
                        }           
                    }**/
                    //System.debug(mapval);
                    
                    
                 /**  for(String key : mapval.keySet()){   
                System.debug(key+'---->'+mapval.get(Key));  
                }**/
                    
                    
                List<Contact> con=[SELECT AccountId, Email FROM Contact WHERE AccountId !=null AND Email != null];
                    Map<Id,Map<String,Integer>> mainmap = new Map<Id,Map<String,Integer>>();
              
                   
                               for(Contact c:con){  
                                    integer count=0;
                                   Map<String,Integer> innermap=new Map<String,Integer>();
                                   
                                       if(mainmap.containsKey(c.AccountId)){      
                                           
                                        innermap=mainmap.get
                                            (c.AccountId);
                                           
                                               if(innermap.containsKey(c.Email)){
                                                 count=innermap.get(c.Email); 
                                                   innermap.put(c.Email,count+1);
                                               }else{
                                                 count=1;
                                               innermap.put(c.Email,count);  
                                               }                                     
                                           mainmap.put(c.AccountId,innermap);
                                       }       
                                      innermap.put(c.Email,1);
                                   mainmap.put(c.AccountId,innermap);                                      
                                       
                             }
                    
                for(Id Key : mainmap.keySet()){
                            System.debug(key+'---->'+mainmap.get(key));
                }
             
            }
        }