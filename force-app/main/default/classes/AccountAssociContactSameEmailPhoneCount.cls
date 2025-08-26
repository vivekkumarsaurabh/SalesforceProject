public class AccountAssociContactSameEmailPhoneCount {
    
    public static void accountWithContactSameEmailPhoneCount(){       
        
        
        // System.debug(Database.query('SELECT AccountId,Name,Email,Phone FROM Contact WHERE AccountId!= NULL AND Email!=NULL AND Phone!=NULL'));
        
        
        //   Account ac=new Account(Name='V1',TableOfDetails__c='<table width="200" border="1" cellspacing="10" cellpadding="0"><tr><th>Contact Name</th><th>Emails</th><th>Phone</th><th>Count</th> </tr><tbody><td>Kumar</td><td>Kumar@gmail.com</td><td>123231</td><td>3</td></tbody></table>');
        //  insert ac;
        
        
        
        Map<Id,Map<String,List<String>>> mapOfAccIdWithConSameEmailPhone=new Map<Id,Map<String,List<String>>>();
        
        for(Contact con: [SELECT AccountId,Name,Id,Email,Phone FROM Contact WHERE AccountId!= NULL AND Email!=NULL AND Phone!=NULL]){
            String key=con.Email+'/'+con.Phone;
            String NamesWithId=con.Name+'/'+con.Id;
            Map<String,List<String>> mapOfAccIdWithContactKey =new Map<String,List<String>>();
            List<String> listOfContact=new List<String>();
            if(mapOfAccIdWithConSameEmailPhone.containsKey(con.AccountId)){
                mapOfAccIdWithContactKey=mapOfAccIdWithConSameEmailPhone.get(con.AccountId);
                if(mapOfAccIdWithContactKey.containsKey(key)){
                    listOfContact=mapOfAccIdWithContactKey.get(key);
                }
            }
            listOfContact.add(NamesWithId);
            mapOfAccIdWithContactKey.put(key,listOfContact);
            mapOfAccIdWithConSameEmailPhone.put(con.AccountId,mapOfAccIdWithContactKey);
                       
        }
        
        
        Map<Id,String> mapOfTableString=new Map<Id,String>();
        
        List<Account> listOfUpdateAccount=new List<Account>(); 
        
        for(Id keysOfAccountId:mapOfAccIdWithConSameEmailPhone.keySet()){          
            
            Map<String,List<String>> mapOfKeyAndContact =mapOfAccIdWithConSameEmailPhone.get(keysOfAccountId);   
            
            for(String keyOfEmail: mapOfKeyAndContact.keySet()){
                String tableString='';
                Account ac=new Account();         
                ac.id=keysOfAccountId;
                listOfUpdateAccount.add(ac);                
                if(mapOfTableString.containsKey(keysOfAccountId)){                    
                    tableString=mapOfTableString.get(keysOfAccountId);
                } 
                
                List<String> emailPhone=KeyOfEmail.split('/');   
                List<String> listOfContact=mapOfKeyAndContact.get(keyOfEmail);
                
                String link='';
                
                for(Integer i=0; i<listOfContact.size(); i++){
                    
                    String listOfSingleContact=listOfContact.get(i);
                    List<String> listOfConID=listOfSingleContact.split('/');
                    String nameOfcontact=listOfConID.get(0);
                    String idOfContact=listOfConID.get(1);
                   // System.debug(idOfContact);
                    link+='<p><ul><a href="https://algocirruspvtltd-6d-dev-ed.develop.lightning.force.com/lightning/r/Contact/'+idOfContact+'/view" style="text-align:center; text-decoration:none;">'+ nameOfcontact+'</a></ul></p><br>';     
                    //System.debug(link);
                }
                
                
                
                tableString+='<tr><td>'+link+'</td><td>'+emailPhone.get(0)+'</td><td>'+emailPhone.get(1)+'</td><td>'+mapOfKeyAndContact.get(keyOfEmail).size()+'</td></tr>';
                
                mapOfTableString.put(keysOfAccountId,tableString);       
                
            }           
            
        }
        
        List<Account> updateAccountList=new List<Account>();
        for(Account acc: listOfUpdateAccount){
            acc.TableOfDetails__c='<table  width="50"  border="1" cellspacing="15" cellpadding="0"><tr style="background-color:#ede9e8; color:#000; align-items:center;"><th>Contact Name</th><th>Email</th><th>Phone</th><th>Count Of Contact</th> </tr><tbody>'+mapOfTableString.get(acc.id)+'</tbody></table>';
            updateAccountList.add(acc);
        }
        
        Map<id,Account> mapOfAcc = new Map<id,Account>();
        mapOfAcc.putall(updateAccountList);
        
        if(mapOfAcc.size()>0){
            update mapOfAcc.values();
        }
        
        
        
        
        
    
        
    }
}