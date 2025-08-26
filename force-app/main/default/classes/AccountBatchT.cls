public class AccountBatchT  implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        return Database.getQueryLocator([SELECT Id, Name FROM Account WHERE Id != NULL AND Name != NULL]);
        
    }
    
    
    public void execute(Database.BatchableContext bc, List<Account> accountList){
        List<Contact> contactList = new List<Contact>();
        if(!accountList.isEmpty()){
            for(Account iterateAccountRecord : accountList){
                Contact createNewContact = new Contact();
                createNewContact.LastName = iterateAccountRecord.Name;
                createNewContact.AccountId = iterateAccountRecord.Id;
                contactList.add(createNewContact);
            }
        }
         System.debug('contList'+contactList );
       /** if(!contactList.isEmpty()){
            Database.insert(contactList, FALSE);
        }**/
        
    }
    
    
    public void finish(Database.BatchableContext bc){
        System.debug('finish....');
        
    }
}