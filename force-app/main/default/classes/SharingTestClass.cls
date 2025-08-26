@isTest(seeAllData=true)
    public with sharing class SharingTestClass {
    /**    public static void getAccountRecord(){
            List<Account> ll=[SELECT Id FROM Account];
               
            System.debug(ll.size());
        }**/
        
        @isTest
        public static void methodofThisClass(){
            
            
            User user1=[SELECT Id FROM USER WHERE UserName='vivekkumarsaurabh59@gmail.com'];
            System.debug('Run For User1');  
            
            System.runAs(user1){
              Account accc=new Account(Name='newAcc12Sharing');
                Database.insert(accc, AccessLevel.User_mode);
               // Assert.fail(); 
                
             
               // getAccountRecord();
              List<Account> accountsWithContacts =[SELECT Id, Name, Phone, Rating,(SELECT Id, LastName, Phone FROM Account.Contacts) FROM Account LIMIT 10];
      
       // Strip fields that are not readable
       SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE,accountsWithContacts);
     
    // Print stripped records
       for (Integer i = 0; i < accountsWithContacts.size(); i++) 
      {
         System.debug('Insecure record access: '+accountsWithContacts[i]);
         System.debug('Secure record access: '+decision.getRecords()[i]);
       }
                
            
         List<Account> act1 = [SELECT Id,Name,Rating, (SELECT LastName FROM Contacts),(SELECT Description FROM Opportunities) FROM Account WITH USER_MODE];
                    for(Account ac: act1){
                         System.debug(ac); 
                    }
                    
                
                
             sharingkeys.getAccountRecord();
            }
           
            
            
            User user2=[SELECT Id FROM USER WHERE UserName='vivek.21scse2030235@galgotiasuniversity.edu.in'];
            System.debug('Run For User2'); 
            System.runAs(user2){
              //  getAccountRecord();
               
    
                
             sharingkeys.getAccountRecord();
            }
            
            
            
            System.debug('Run for Other User');
           // List<Account> d=[SELECT Id FROM Account WHERE Name='New Account Flow'];
           // delete d;
            sharingkeys.getAccountRecord();
            
                  
                          
            
            
        }
           
        
    }