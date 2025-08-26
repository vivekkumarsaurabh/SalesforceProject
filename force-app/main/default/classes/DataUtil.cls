@isTest
private class DataUtil {

    static testmethod void testLoadData(){
        List<SObject> ls = Test.LoadData(Account.sObjectType,'testAccounts');
        System.assert(ls.size() == 3);        
        Account a1 = (Account)ls[0];
        String accName = a1.Name;
        System.debug(accName);
    }
}