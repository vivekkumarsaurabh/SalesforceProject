public class AccountUpdateBatchEx implements Database.Batchable<sObject> {    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name FROM Account LIMIT 10';        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Account> scope){
        for(Account a : scope){
            a.Name = a.Name + 'Update Batch job';
            System.debug(a.Name);
        }
        update scope;
    }
    
    public void finish(Database.BatchableContext BC) {
        System.debug('Batch Job completed');
    }
   
}