@isTest
private class createCSVfileOnInsertAccTest {   
    Private static Set<Id> setOfId = new Set<Id>();
    
    @isTest
    static void InsertCsvAttachTest(){
        List<Account> listOfAcc = createCSVfileOnInsertAccDataFactory.insertAccRec(10, 'TestAccount');
        List<Database.saveResult> accInsertResult = Database.insert(listOfAcc, false);
        for(Database.saveResult iterateResult : accInsertResult){
            System.assert(iterateResult.isSuccess());
            //System.debug(iterateResult.isSuccess());
        }
        for(Account iterateAcc : listOfAcc){
            setOfId.add(iterateAcc.Id);         
        }
        
        List<Account> listOfAccUpdated = createCSVfileOnInsertAccDataFactory.updateAccRec(setOfId, 'TestACC');      
        List<Database.saveResult> accUpdateResult = Database.update(listOfAccUpdated, false);
        for(Database.saveResult iterateResult : accUpdateResult){
            System.assert(iterateResult.isSuccess());
        }
    }    
}