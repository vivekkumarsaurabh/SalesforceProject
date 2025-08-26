/*
* @Description : This class is test class of InlineEditing where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 06/03/2025
*@modified by  : Vivek Kumar Saurabh
*@modified date: 06/03/2025 
*/
@isTest
public class InlineEditingTest {
    
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
        Contact createContactRecord = TestDataFactory.createContactInstance('Test Contact', createAccountRecord.Id);
        if(createContactRecord != NULL){
            Database.insert(createContactRecord, false);
        }
        /**Opportunity createOpportunityRecord = TestDataFactory.createOpportunityInstance('Test Opportunity', 'Prospecting', createAccountRecord.Id, createContactRecord.Id); 
if(createOpportunityRecord != NULL){
Database.insert(createOpportunityRecord, false); 
}**/
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
        Inline_Object_Mapping__mdt metadata = [SELECT Id, ObjectApiName__c FROM Inline_Object_Mapping__mdt WHERE ObjectApiName__c = 'Account'  LIMIT 1];
        Contact contactRecord = [SELECT Id, LastName, AccountId FROM Contact WHERE LastName = 'Test Contact' LIMIT 1];
        Account accountRecord =  [SELECT Id FROM Account WHERE Name Like '%Test%' LIMIT 1];
        //  List<String> filterFieldList = new List<String>{'LastName'};
        String updateData  = '[{"attributes": {"type": "Contact"},"Languages__c": "English","Id": "'+contactRecord.Id+'"}]';
        String finnalFieldList = '[{"key":"LastName","value":1},{"key":"Languages__c","value":2}]';
        Test.startTest();  
        List<Object> sObjectWrapperList = InlineEditing.retriveSobjectName();        
        if(metadata.Id != NULL && contactRecord.Id != NULL){
            String sObjectApiName = InlineEditing.getsObjectApiName(metadata.Id);
            List<Object> ColumnWrapperList = InlineEditing.getColumns(metadata.Id);  
            Object childDataWrapper = InlineEditing.getAllChildRecord(accountRecord.Id, 'Contact', 'Account');
            String accountIcon =  InlineEditing.objectIconMethod('Account');
            String sObjectLabelName = InlineEditing.returnObjectLabelName('Account');
            List<sObject> updatesObjectList = InlineEditing.updatesObjectRecord(updateData);
            List<Object> requiredFiltedList = InlineEditing.getRequiredFields('Account');
            String sObjectName = InlineEditing.getSObjectName(accountRecord.Id);  
            List<String> relatedObjectList = InlineEditing.getAllRelatedObject('Account');
            Object filterWrapper = InlineEditing.gettingFilter('Account');
            List<sObject> sObjectList = InlineEditing.getData(metadata.Id, NULL, 'Account', NULL, NULL);
            List<sObject> sObjectDataList = InlineEditing.deletesObjectRecord(accountRecord.Id, 'Account');        
            Test.stopTest();
            System.debug('childDataWrapper===>'+childDataWrapper);
            System.debug('filterWrapper-====>'+filterWrapper);
            Assert.areEqual(sObjectWrapperList.size(), 2, 'sObjectwrapper list of  Fields');
            Assert.areEqual(sObjectApiName, 'Account', 'getting sObjectApiName');
            Assert.areEqual(ColumnWrapperList.size(), 5, 'this is for column wrapper list'); 
            //  Assert.areEqual(sObjectRecordList.size(), 1, 'this is return sObject record list size');
            Assert.areEqual(accountIcon, 'standard:account', 'this is return icon ');
            Assert.areEqual(sObjectLabelName, 'Account', 'this is getting sObject Label name');
            Assert.areEqual(updatesObjectList.size(), 1, 'update sObjectList');
            Assert.areEqual(requiredFiltedList.size(), 7, 'getting sObject required field');
            Assert.areEqual(sObjectName, 'Account', 'getting sObejctName');
            Assert.areEqual(relatedObjectList.size(), 2, 'Testing for deleting records of sObject');
            Assert.areEqual(sObjectList.size(), 1, 'Testing for sObjectList for positive test');
            Assert.areEqual(sObjectDataList .size(), 1, 'Testing for sObjectDataList records test');
        }
    }
    
    /*
* @description : This method is test method for negative test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testNegativeCases(){
        String finnalFieldList;
        List<String> filterFieldList = new List<String>();
        Test.startTest();
        List<Object> sObjectWrapperListNeg = InlineEditing.retriveSobjectName();  
        String sObjectApiNameNeg = InlineEditing.getsObjectApiName(NULL);
        List<Object> ColumnWrapperListNeg = InlineEditing.getColumns(NULL);  
        Object childDataWrapper = InlineEditing.getAllChildRecord(NULL, NULL, NULL);
        String accountIconNeg =  InlineEditing.objectIconMethod(NULL);
        String sObjectLabelNameNeg = InlineEditing.returnObjectLabelName(NULL);
        List<sObject> updatesObjectListNeg = InlineEditing.updatesObjectRecord(NULL);
        List<Object> requiredFiltedListNeg = InlineEditing.getRequiredFields(NULL);
        String sObjectNameNeg = InlineEditing.getSObjectName(NULL);  
        List<String> relatedObjectListNeg = InlineEditing.getAllRelatedObject(NULL);
        Object filterWrapper = InlineEditing.gettingFilter(NULL);
        List<sObject> sObjectListNeg = InlineEditing.getData(NULL, NULL, NULL, NULL, NULL);
        List<sObject> sObjectDataListNeg = InlineEditing.deletesObjectRecord(NULL, NULL);       
        Test.stopTest(); 
        Assert.areEqual(sObjectWrapperListNeg.size(), 2, 'sObjectwrapper list of  Fields in Neg Test');
        Assert.areEqual(sObjectApiNameNeg, NULL, 'sObjectApiName is contact in Neg Test');
        Assert.areEqual(ColumnWrapperListNeg.size(), 0, 'this is for column wrapper list in Neg Test'); 
        Assert.areEqual(accountIconNeg, NULL, 'this is for icon in Neg Test'); 
        Assert.areEqual(sObjectLabelNameNeg, NULL, 'this is for label name  in Neg Test');
        Assert.areEqual(updatesObjectListNeg.size(), 0, 'this is for sObject Record List in Neg Test'); 
        Assert.areEqual(requiredFiltedListNeg.size(), 0, 'this is return all required field in Neg Test');
        Assert.areEqual(sObjectNameNeg, NULL, 'this is sObjectName of record list');
        Assert.areEqual(relatedObjectListNeg.size(), 0, 'all sObject related object list in Neg test');
        Assert.areEqual(sObjectListNeg.size(), 0, 'Testing for sObjectList for Neg test');
        Assert.areEqual(sObjectDataListNeg.size(), 0, 'Testing for getting sObjectDataList list in Neg test');
    }   
}