public class AccountUpdateRating implements Database.Batchable<sObject>, Database.stateful{
    public Database.QueryLocator start(Database.BatchableContext dc){
        String r = 'Warm';
        String query = 'SELECT Id,Rating FROM Account WHERE Rating = :r LIMIT 10';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext dc, List<Account> listOfAcc){
        for(Account iterateAcc: listOfAcc){
            iterateAcc.Rating = 'Cold';
        }
        update listOfAcc;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('Finish Job');
    }
}