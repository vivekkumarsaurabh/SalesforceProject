/*
* @Description : This class is test class of ObjectHistoryTracking where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 29/05/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 05/06/2024 
*/
@isTest
private class ObjectHistoryTrackingTestClass {
	/*
	* @description : This method is test setup method for creating test Records.
	* @param : N/A.
	* @return : N/A.
	*/
    @testSetup
     static void testSetupMethod(){
       Account createAccountRecord = TestDataFactory.createAccountRecordInstance('Test Account'); // You can't use DataFactory name for testRecord Creation.
        if(createAccountRecord != NULL){
        Database.insert(createAccountRecord, false); // Don't make any DML without null check
        }
    }
    
    /*
	* @description : This method is test method for positive test cases.
	* @param : N/A.
	* @return : N/A.
	*/    
    // Method name should be more relevant 
    // And add proper positive and negative test cases.    
    @isTest
    static void testPositiveCases(){        
        Account accountRecord = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1]; 
        List<ObjectHistoryColumnMapping__mdt> metaDataColumnList =  [SELECT Id, label, FieldName__c, type__c, sortable__c, (SELECT label, target__c FROM typeAttributes__r WHERE label != NULL AND target__c != NULL) FROM ObjectHistoryColumnMapping__mdt WHERE label != NULL AND FieldName__c != NULL AND type__c != NULL]; 
        Test.startTest();  
        String objectName = 'Account';
        String standardObjectIcon = 'standard:'+objectName.toLowerCase();
        String customObjIcon = 'custom:custom68';
        Account updateAccRec = new Account(); 
        updateAccRec.Id = accountRecord.Id;
        updateAccRec.Name = 'Test Account Update';
        if(updateAccRec != NULL){
        update updateAccRec;   // Don't make any DML without null check  
        }        
        List<Object> historyWrapperList = ObjectHistoryTracking.retriveObjectHistory(10, objectName, String.valueOf(accountRecord.Id), 0);        
        String objectIcon = ObjectHistoryTracking.objectIconMethod(objectName);
        String objLabelName = ObjectHistoryTracking.returnObjectLabelName(objectName);
        Integer lengthOfRecords = ObjectHistoryTracking.returnLengthObjectHistoryRecords(objectName, String.valueOf(accountRecord.Id));
        String customObjectName;
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        for(String iterateObject : globalDescribe.keySet()){
         Schema.SObjectType objToken = globalDescribe.get(iterateObject);
            if(objToken.getDescribe().isCustom()){
                customObjectName = iterateObject;
            }
        }
        String customObjectIcon = ObjectHistoryTracking.objectIconMethod(customObjectName);
        List<Object> objectMetaDataWrapperList = ObjectHistoryTracking.objectHistoryColumn();
       
        Test.stopTest(); 
        //This is not the right way add assert 
        Assert.areEqual(historyWrapperList.size(), 1, 'Testing for retrive history');
        Assert.areEqual(lengthOfRecords, 1, 'return length of Object History records');
        Assert.areEqual(objLabelName, objectName, 'Return Object Label Name'); 
        Assert.areEqual(objectIcon, standardObjectIcon, 'standard icon of Account Object');   
        Assert.areEqual(customObjectIcon, customObjIcon, 'Custom icon of Custom Object');
        Assert.areEqual(objectMetaDataWrapperList.size(), metaDataColumnList.size(), 'Testing for retrive history');
    }
    
     /*
	* @description : This method is test method for negative test cases.
	* @param : N/A.
	* @return : N/A.
	*/
    @isTest
    static void testNegativeCases(){
        Test.startTest();
        List<Object> historyWrapperNegTestList = ObjectHistoryTracking.retriveObjectHistory(5, '', '', 0);
        Integer lengthOfRecordsNegTest = ObjectHistoryTracking.returnLengthObjectHistoryRecords('', '');        
        String objectIconNegTest = ObjectHistoryTracking.objectIconMethod(''); 
        String objLabelNameNegTest = ObjectHistoryTracking.returnObjectLabelName('');        
        Test.stopTest();
        Assert.areEqual(historyWrapperNegTestList.size(), 0, 'historyList for negative test');  
        Assert.areEqual(lengthOfRecordsNegTest, 0, 'return length of Object History records size is zero');
        Assert.areEqual(objLabelNameNegTest, NULL, 'Object Label Name is null'); 
        Assert.areEqual(objectIconNegTest, NULL, 'Object Icon is null'); 
    }
}