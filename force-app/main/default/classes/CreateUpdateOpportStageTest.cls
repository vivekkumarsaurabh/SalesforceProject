@isTest
public class CreateUpdateOpportStageTest {  
    @isTest
    static void createUpdateStage(){
        Set<Id> setOfOppId = new Set<Id>();
        Date d1 = date.newInstance(2023, 11, 10);
        List<Opportunity> listOfOpp = CreateUpdateOpportOnStageDataFactory.createOpp(10, 'NewOpp', 'Prospecting', d1);
        List<Database.saveResult> listOfDatabaseResult = Database.insert(listOfOpp, false);
        for(Database.saveResult iterateResult : listOfDatabaseResult){
            System.assert(iterateResult.isSuccess());
        }        
        for(Opportunity iterationOpp :  listOfOpp){
            setOfOppId.add(iterationOpp.Id);
        }             
        List<Opportunity> listOfOppUpdate = CreateUpdateOpportOnStageDataFactory.updateOppList(setOfOppId, 'NewOppTest', 'Prospecting', d1);
        List<Database.saveResult> listOfDatabaseResults = Database.update(listOfOppUpdate, false);
        for(Database.saveResult iterateSaveResult : listOfDatabaseResults){
            if(!iterateSaveResult.isSuccess()) {
                String msg = 'Opportunity must be ' +iterateSaveResult.getErrors()[0].getMessage();             
                System.AssertEquals('Opportunity must be Qualification', msg);            
            } 
        }        
        List<Opportunity> listOfOppUpdated  = CreateUpdateOpportOnStageDataFactory.updateOppList(setOfOppId, 'NewOpp1', 'Qualification', d1);
        List<Database.saveResult> listOfDatabaseResultsUpdate = Database.update(listOfOppUpdated, false);
        for(Database.saveResult iterateResult : listOfDatabaseResultsUpdate){
            System.assert(iterateResult.isSuccess());
        }
        
    }
 
    @isTest
    static void createUpdateStageOtherStageName(){
        Date d1 = date.newInstance(2023, 11, 10);
        Set<Id> setOfIdUpdate = new Set<Id>();
        List<Opportunity> listOfOpp = CreateUpdateOpportOnStageDataFactory.createOpp(5, 'NewOpp', 'Qualification', d1);
        List<Database.saveResult> listOfDatabaseResult = Database.insert(listOfOpp, false);
        for(Database.saveResult iterateResult : listOfDatabaseResult){                   
            if(!iterateResult.isSuccess()) {
                String msg = iterateResult.getErrors()[0].getMessage();             
                Assert.areEqual('Opportunity stage Name is not Prospecting', msg);            
            }
        } 
    }  
}