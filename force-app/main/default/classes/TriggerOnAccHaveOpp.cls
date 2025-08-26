public class TriggerOnAccHaveOpp {
    
    //that question given by dileep sir  Ques- If an account have opportunity then and delete that account then show error but in this  scenario if an account have  not any opportunity then that account also do not delete and rollback because of "Adderror". so we use database.delete to handle that scenario.
    public static void deleteAccHandler(Map<Id, Account> accMap){
        for(Account iterateAcc : [SELECT ID, (SELECT ID FROM Opportunities) FROM Account WHERE ID = :accMap.keyset()]){
            Integer countId = iterateAcc.Opportunities.size();
            if(countId > 0){
               accMap.get(iterateAcc.Id).addError('Account have opportunity');
            }
        }
        //here always run database.delete because when multiple account comes to delete then fire error but which have no account that also not deleted so we can use database.delete 
    }
}