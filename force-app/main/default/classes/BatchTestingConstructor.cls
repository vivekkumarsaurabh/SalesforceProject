public class BatchTestingConstructor implements Database.Batchable<SObject>, Database.Stateful {
    
    public String q;
    
    public BatchTestingConstructor(String query){
        this.q = query;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(this.q);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> aspAccounts){
        System.debug(aspAccounts.size());
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('finish..');
            
            }
    
}