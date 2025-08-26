public with sharing class EnforceObjectAndFieldPermission {
    
    public static void meth(){
     /**   if (Schema.sObjectType.Contact.fields.Email.isCreateable()) {
   // Create new contact
}
if (Schema.sObjectType.Contact.isDeletable()) {
   // Delete contact
}
if (Schema.sObjectType.Contact.fields.Email.isUpdateable()) {
   // Update contact phone number
}

        **/
/**    if (Schema.sObjectType.Account.fields.Name.isAccessible()) {
      ID  Id='0015j00001CdPe0AAF';
   sObject c = [SELECT Name FROM Account WHERE Id= :Id];
        System.debug(c);
    }**/

 /**       List<Account> accounts = new List<Account>{
    new Account(Name='vivek123', AnnualRevenue=1000)
    
};

// Strip fields that are not updatable
SObjectAccessDecision decision = Security.stripInaccessible(
    AccessType.UPDATABLE,
    accounts);

// Print stripped records
for (SObject strippedAccount : decision.getRecords()) {
    System.debug(strippedAccount);
}

 Print modified indexes
System.debug(decision.getModifiedIndexes());**/
        
        List<Account> accountsWithContacts =
	[SELECT Id, Name, Phone, Rating,
	    (SELECT Id, LastName, Phone FROM Account.Contacts)
	FROM Account LIMIT 10];
  
   // Strip fields that are not readable
   SObjectAccessDecision decision = Security.stripInaccessible(
	                                   AccessType.READABLE,
	                                   accountsWithContacts);
 
// Print stripped records
   for (Integer i = 0; i < accountsWithContacts.size(); i++) 
  {
      System.debug('Insecure record access: '+accountsWithContacts[i]);
      System.debug('Secure record access: '+decision.getRecords()[i]);
   }
 
// Print modified indexes
  System.debug('Records modified by stripInaccessible: '+decision.getModifiedIndexes());
 
// Print removed fields
  System.debug('Fields removed by stripInaccessible: '+decision.getRemovedFields());
    
    }
}