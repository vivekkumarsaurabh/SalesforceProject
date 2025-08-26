@isTest
public class createCSVfileOnInsertAccDataFactory {    
    public static List<Account> insertAccRec(Integer noOfRec, String Name){
        List<Account> accList = new List<Account>();
        for(Integer i = 1; i <= noOfRec; i++){
            Account singleAcc = new Account();
            singleAcc.Name = Name + i;
            singleAcc.Rating = 'Hot';
            singleAcc.State__c = 'Delhi';
            singleAcc.City__c = 'Delhi';           
            accList.add(singleAcc);
        }
        return accList;
    } 
    
    public static List<Account> updateAccRec(Set<Id> setOfId, String NameofAcc){
        List<Account> accForUpdate = new List<Account>();
        for(Account accIterate :  [SELECT Id, Name FROM Account WHERE Id IN : setOfId]){
            Account SingleAcc = new Account();
            SingleAcc.Id = accIterate.Id;
            SingleAcc.Name = NameofAcc;            
            accForUpdate.add(SingleAcc);
        }
        return accForUpdate;
    }
}