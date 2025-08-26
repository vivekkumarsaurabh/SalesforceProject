@isTest
public class primaryConInsrtUpdtIfAccNoPrimaryConTest {
   @isTest 
    static void insertAccCreateCon(){
        Test.startTest();
        List<Account> listOfAcc = PrimaryConIfAccNoPrmyConDataFactory.insertNewAcc(5, 'NewAcc', 'Hot');        
        //for one contact on Acc
        List<Contact> listOfCon = PrimaryConIfAccNoPrmyConDataFactory.insertNotPrimeryConinAcc(listOfAcc, 2, 'NewCon', false);
        List<Database.saveResult> listOfSaveCon= Database.insert(listOfCon, false);
        for(Database.saveResult iterateSaveResult : listOfSaveCon){
            System.assert(iterateSaveResult.isSuccess());
        }
        Set<Id> setOfConId = new Set<Id>();
        for(Contact con : listOfCon){
            setOfConId.add(con.Id);
        }        
        //for false contact on Acc After Primary Contact or for true first rec on Acc
        List<Contact> listOfConFlsPryCon = PrimaryConIfAccNoPrmyConDataFactory.insertNotPrimeryConinAcc(listOfAcc, 1, 'NewCon', true);
        List<Database.saveResult> listOfSaveConfls = Database.insert(listOfConFlsPryCon, false);
        for(Database.saveResult iterateSaveResult : listOfSaveConfls){
            System.assert(iterateSaveResult.isSuccess());
        }
        Set<Id> setOfConIdPry = new Set<Id>();
        for(Contact con : listOfConFlsPryCon){
            setOfConIdPry.add(con.Id);
        }               
        //for contact insert on Acc Where Acc have Primary Contact
        List<Contact> listOfConAfterPrimry = PrimaryConIfAccNoPrmyConDataFactory.insertPrimeryConinAcc(listOfAcc, 3, 'NewContrue', true);
        List<Database.saveResult> listOfSaveConPry= Database.insert(listOfConAfterPrimry, false);
        for(Database.saveResult iterateSaveResult : listOfSaveConPry){
            if(!iterateSaveResult.isSuccess()) {
                String msg = iterateSaveResult.getErrors()[0].getMessage();             
                System.AssertEquals('Primary Contact Exist', msg);            
            } 
        }                
        //for first time update false
        List<Contact> listOfConUpdate = PrimaryConIfAccNoPrmyConDataFactory.updateContact(setOfConId, 'NewConUpdate', false);
        List<Database.saveResult> listOfSaveConUp= Database.update(listOfConUpdate, false);
        for(Database.saveResult iterateSaveResult : listOfSaveConUp){            
            System.assert(iterateSaveResult.isSuccess());  
        } 
        //for first time update true
        List<Contact> listOfConUpdatefalse = PrimaryConIfAccNoPrmyConDataFactory.updateContact(setOfConId, 'NewConUpdate', true);
        List<Database.saveResult> listOfSaveConUpfal= Database.update(listOfConUpdatefalse, false);
        for(Database.saveResult iterateSaveResult : listOfSaveConUpfal){    
            System.assert(iterateSaveResult.isSuccess());
        }        
        List<Contact> listOfConUpdatetrue = PrimaryConIfAccNoPrmyConDataFactory.updateContact(setOfConIdPry, 'NewConUpdate', true);
        List<Database.saveResult> listOfSaveConUptrue= Database.update(listOfConUpdatetrue, false);
        for(Database.saveResult iterateSaveResult : listOfSaveConUptrue){    
            if(!iterateSaveResult.isSuccess()) {
                String msg = iterateSaveResult.getErrors()[0].getMessage();             
                System.AssertEquals('Primary Contact Exist', msg);            
            } 
        }          
        List<Contact> listOfConUpdatefal = PrimaryConIfAccNoPrmyConDataFactory.updateContact(setOfConIdPry, 'NewConUpdate', false);
        List<Database.saveResult> listOfSaveConUpfald= Database.update(listOfConUpdatefal, false);
        for(Database.saveResult iterateSaveResult : listOfSaveConUpfald){    
            System.assert(iterateSaveResult.isSuccess());
        }  
        Test.stopTest();
        
        
    }  
    
    @isTest
    static void updateRecordbulk(){
        Test.startTest();
        List<Account> listOfAcc = PrimaryConIfAccNoPrmyConDataFactory.insertNewAcc(2, 'NewAcc', 'Hot');
        List<Contact> listOfCon = PrimaryConIfAccNoPrmyConDataFactory.insertNotPrimeryConinAcc(listOfAcc, 1, 'NewCon', true);
        List<Database.saveResult> liOfSaveRes =  Database.insert(listOfCon, false);
        for(Database.saveResult iterateSaveRes : liOfSaveRes){
           System.assert(iterateSaveRes.isSuccess());
        }
                
        List<Contact> listOfConUpdatefal = PrimaryConIfAccNoPrmyConDataFactory.updateContacts(listOfCon, true);
        List<Database.saveResult> saveResult =  Database.update(listOfConUpdatefal, false);
        for(Database.saveResult iterateSaveRes : saveResult){
           if(!iterateSaveRes.isSuccess()) {
                String msg = iterateSaveRes.getErrors()[0].getMessage();             
                System.AssertEquals('Primary Contact Exist', msg);            
            } 
        } 

        Test.stopTest();
    }
  
    
    @isTest
    static void updateRecordSingle(){
        Test.startTest();
        List<Account> listOfAcc = PrimaryConIfAccNoPrmyConDataFactory.insertNewAcc(1, 'NewAcc', 'Hot');
        List<Contact> listOfCon = PrimaryConIfAccNoPrmyConDataFactory.insertNotPrimeryConinAcc(listOfAcc, 1, 'NewCon', true);
        List<Database.saveResult> liSaveRes = Database.insert(listOfCon, false);
        for(Database.saveResult  iterateSaveResult : liSaveRes){
            System.assert(iterateSaveResult.isSuccess());
         }
                       
        List<Contact> listOfConFalse = PrimaryConIfAccNoPrmyConDataFactory.insertNotPrimeryConinAcc(listOfAcc, 1, 'NewCon', false);
        List<Database.saveResult> listOfsaveRes  = Database.insert(listOfConFalse, false);
        for(Database.saveResult  iterateSaveResult : listOfsaveRes){
            System.assert(iterateSaveResult.isSuccess());
        }
        
     List<Contact> listOfConUpdatefal = PrimaryConIfAccNoPrmyConDataFactory.updateContacts(listOfCon, true);
        List<Database.saveResult> listOfsaveResul =  Database.update(listOfConUpdatefal, false);
        for(Database.saveResult  iterateSaveResult : listOfsaveResul){
            System.assert(iterateSaveResult.isSuccess());
        } 
        
        List<Contact> listOfConUpdatefalup = PrimaryConIfAccNoPrmyConDataFactory.updateContacts(listOfConFalse, false);
        List<Database.saveResult> listOfsaveResults = Database.update(listOfConUpdatefalup, false);
        for(Database.saveResult  iterateSaveResult : listOfsaveResults){
            System.assert(iterateSaveResult.isSuccess());
        }        
        List<Database.deleteResult> listOfDelResult = Database.delete(listOfCon, false);        
       for(Database.deleteResult iteratedelRes : listOfDelResult){          
          System.assert(iteratedelRes.isSuccess());
       }
        Test.stopTest();
    }
    
}