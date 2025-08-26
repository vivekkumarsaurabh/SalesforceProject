/*
* @Description : This class is test class of MergeSObject where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 18/07/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 18/07/2024 
*/
@isTest
public class MergeSObjectTest {
    /*
* @description : This method is test setup method for creating test Records.
* @param : N/A.
* @return : N/A.
*/
    @testSetup
    static void testSetupMethod(){
        Account createAccountRecord = TestDataFactory.createAccountRecordInstance('Test Account');
        if(createAccountRecord != NULL){
            Database.insert(createAccountRecord, false); 
        }
        Opportunity createOpportunityRecord = TestDataFactory.createOpportunityWithoutContactInstance('Test Opportunity', 'Prospecting', createAccountRecord.Id); 
        if(createOpportunityRecord != NULL){
            Database.insert(createOpportunityRecord, false); 
        }
        Opportunity createAnotherOpportunityRecord = TestDataFactory.createOpportunityWithoutContactInstance('Test Opportunity2', 'Prospecting', createAccountRecord.Id); 
        if(createAnotherOpportunityRecord != NULL){
            Database.insert(createAnotherOpportunityRecord, false); 
        }
    }
    
    
    /*
* @description : This method is test method for positive test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testPositiveCases(){ 
        List<String> opportunityIds = new List<String>();
        String accountId;
        for(Opportunity iterateOpportunityRecord : [SELECT Id FROM Opportunity WHERE Name Like '%Test%' LIMIT 2]){
            opportunityIds.add(iterateOpportunityRecord.Id);
        }
        for(Account iterateAccountRecord : [SELECT Id FROM Account WHERE Name Like '%Test%' LIMIT 1]){
            accountId = iterateAccountRecord.Id;
        }
        String jsonWrapper = '[{"key":"AccountId","value":"'+accountId+'"},{"key":"IsPrivate","value":"false"},{"key":"Name","value":"New Test Opportunity"},{"key":"StageName","value":"Prospecting"},{"key":"CloseDate","value":"2024-07-24 00:00:00"},{"key":"Type","value":"Existing Customer - Upgrade"}]';
        List<MergeSObject.NewMergeRecord> wrapperList = (List<MergeSObject.NewMergeRecord>)JSON.deserialize(jsonWrapper, List<MergeSObject.NewMergeRecord>.class);
        String queryReturn = 'SELECT Name, Id FROM Opportunity'; 
        Test.startTest();
            List<Object> mergeFieldList = MergeSObject.getsObjectFieldsValues(opportunityIds);
            List<Object> retriveSelectedRecordNameList = MergeSObject.retriveRecordName(opportunityIds);
            List<Object> childWrapperList = MergeSObject.getChildObject('Opportunity');
            List<Object> childRecordWrapper = MergeSObject.queryChildRecords('Account', 'Opportunity', accountId);
            sObject createObject = MergeSObject.createRecord('Opportunity', wrapperList);
            List<Object> mergeChildObjectrecordList = MergeSObject.mergeChildRecords('Opportunity', opportunityIds, createObject.Id);
            List<Object> deleteChildRecordList = MergeSObject.deleteRecord(opportunityIds);
            String subQuery = MergeSObject.returnQueryWithName('Opportunity');
        Test.stopTest();        
        sObject testOppoertunnityRecord = [SELECT AccountId, IsPrivate, Name, StageName, CloseDate, Type, Id  FROM Opportunity WHERE Name = 'New Test Opportunity' LIMIT 1]; 
        Assert.areEqual(mergeFieldList.size(), 8, 'map fill their field list this map getting Opportunity field');
        Assert.areEqual(childWrapperList.size(), 27, 'this wrapper comes with sub child records behalf of parent');            
        Assert.areEqual(childRecordWrapper.size(), 2, 'child record wrapper list');
        Assert.areEqual(createObject, testOppoertunnityRecord, 'retrive selectedRecordNameList');
        Assert.areEqual(retriveSelectedRecordNameList.size(), 2, 'retrive selectedRecordNameList');
        Assert.areEqual(mergeChildObjectrecordList.size(), 1, 'merge child Object Record List');
        Assert.areEqual(deleteChildRecordList.size(), 2, 'Testing deleting child record which is merge');
        Assert.areEqual(subQuery, queryReturn, 'Testing return query with opportunity object');
    }
    
    /*
* @description : This method is test method for negative test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testNegativeCases(){ 
        List<String> opportunityIds = new List<String>();
        List<MergeSObject.NewMergeRecord> createWrapperList = new List<MergeSObject.NewMergeRecord>();
        String accountId;             
        Test.startTest();  
            List<Object> mergeFieldListNeg = MergeSObject.getsObjectFieldsValues(opportunityIds);
            List<Object> retriveSelectedRecordNameListNeg = MergeSObject.retriveRecordName(opportunityIds);
            List<Object> childWrapperListNeg = MergeSObject.getChildObject(' ');
            List<Object> childRecordWrapperNeg = MergeSObject.queryChildRecords(' ', ' ', accountId);
            List<Object> mergeChildObjectrecordList = MergeSObject.mergeChildRecords(' ', opportunityIds, accountId);
            List<Object> deleteChildRecordListNeg = MergeSObject.deleteRecord(opportunityIds); 
            String subQuery = MergeSObject.returnQueryWithName('');
        Test.stopTest(); 
        Assert.areEqual(mergeFieldListNeg.size(), 0, 'map fill their field list this map getting Opportunity field ');
        Assert.areEqual(childWrapperListNeg.size(), 0, 'this wrapper comes with sub child records behalf of parent for neg test');      
        Assert.areEqual(retriveSelectedRecordNameListNeg.size(), 0, 'this wrapper comes with selected record list neg test');
        Assert.areEqual(mergeChildObjectrecordList.size(), 0, 'this wrapper comes with merge child object list for neg test');
        Assert.areEqual(childRecordWrapperNeg.size(), 0, 'child record wrapper list for negative test');
        Assert.areEqual(deleteChildRecordListNeg.size(), 0, 'Testing Negaive deleting child record which is merge');
        Assert.areEqual(subQuery, 'SELECT ', 'Testing Negaive deleting child record which is merge');
    }
}