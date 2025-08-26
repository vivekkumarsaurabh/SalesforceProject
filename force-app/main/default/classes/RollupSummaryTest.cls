/*
* @Description : This class is test class of RollupSummary where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 18/11/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 18/11/2024 
*/
@isTest
public class RollupSummaryTest {
    
       public class MetadataServiceMock implements WebServiceMock {
        /*
* @description : This method is WebServiceMock for Metadata Api because we callout in WebServiceCallout.
* @param : Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName,String responseNS, String responseName,String responseType.
* @return : N/A.
*/
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction,
                             String requestName,String responseNS, String responseName,String responseType)
        {
            if (request instanceOf MetadataService.createMetadata_element) {
                MetadataService.createMetadataResponse_element res = new MetadataService.createMetadataResponse_element();
                MetadataService.SaveResult customField = new MetadataService.SaveResult();
                customField.fullName = 'Account.CustomField__c';  //Account.CustomField_c             
                customField.success = true;               
                res.result = new MetadataService.SaveResult[] {customField};
                    response.put('response_x', res);
            }     
             if (request instanceOf MetadataService.upsertMetadata_element) {
                MetadataService.upsertMetadataResponse_element res = new MetadataService.upsertMetadataResponse_element();
                 MetadataService.UpsertResult result = new MetadataService.UpsertResult(); 
                 result.fullName = 'Account.CustomField__c';
                 result.success = true; 
                 res.result = new MetadataService.UpsertResult[] {result};
                 System.debug('result upsert----->'+res);
                response.put('response_x', res);
            }
        }
    }
    
     /*
* @description : This method is test setup method for creating test Records.
* @param : N/A.
* @return : N/A.
*/
    @testSetup
    static void testSetupMethod(){
        Account accountRecordInstance = TestDataFactory.createAccountRecordInstance('Test Account');
        if(accountRecordInstance != NULL){
            Database.insert(accountRecordInstance, false);
        }
        Opportunity opportunityInstance = TestDataFactory.createOpportunityWithoutContactInstance('Test Opportunity', 'Prospecting', accountRecordInstance.Id);
         if(opportunityInstance != NULL){
            Database.insert(opportunityInstance, false);
        }
    }
    
     /*
* @description : This method is test method for positive test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testPositiveCases(){    
        Test.setMock(WebServiceMock.class, new MetadataServiceMock());
             Account accountRecord = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
             Opportunity opportunityRecord = [SELECT Id, AccountId, Name FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
             String realValuesList = '[{"AccountId":"'+accountRecord.Id+'","exp":2},{"AccountId":"0015j000013N5MKAA0","exp":1},{"AccountId":"0015j000013N5MLAA0","exp":1}]';
            if(accountRecord != NULL && opportunityRecord != NULL){
                Test.startTest();       
                List<AggregateResult> aggregateResList = RollupSummary.getFieldValue('Account', NULL, 'Opportunity', 'COUNT', accountRecord.Id);
                for(AggregateResult iterate: aggregateResList){   
                    realValuesList = '[{"AccountId":"'+iterate.get('AccountId')+'", "exp": '+iterate.get('exp')+'}]';
                }
                List<MetadataService.SaveResult> metadataServiceSaveResultList =  RollupSummary.createCustomField('Customer Test Data', 'Account.Coustomer__c', 'description', 'helpText', realValuesList, 'Opportunity');    
                List<Object> configrationsData =  RollupSummary.getsObjectWithConfigration();
                List<Object> childsObject = RollupSummary.getChildObject('Account');
                List<Object> integratedFields = RollupSummary.getFieldIntegrated('Opportunity');
             
                Test.stopTest(); 
                Assert.areEqual(configrationsData.size(), 1, 'get configrations from custom metadata');
                Assert.areEqual(childsObject.size(), 80, 'get all child sObject behalf of parent object');
                Assert.areEqual(integratedFields.size(), 6, 'get Integrated field size test in positive test case');
                Assert.areEqual(aggregateResList.size(), 1, 'get field Value with positive test case');
                
                System.debug('configrationsData--->'+configrationsData.size());
                System.debug('childsObject---->'+childsObject.size());
                System.debug('integratedFields----->'+integratedFields.size());
                System.debug('fieldValue---->'+aggregateResList.get(0));
               
                
            }      
    }
    
     /*
* @description : This method is test method for positive test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testNegativeCases(){    
                Test.startTest();       
                List<MetadataService.SaveResult> metadataServiceSaveResultList =  RollupSummary.createCustomField(NULL, NULL, NULL, NULL, NULL, NULL);    
                List<Object> configrationsDataNeg =  RollupSummary.getsObjectWithConfigration();
                List<Object> childsObjectNeg = RollupSummary.getChildObject(NULL);
                List<Object> integratedFieldsNeg = RollupSummary.getFieldIntegrated(NULL);
                List<AggregateResult> aggregateResListNeg = RollupSummary.getFieldValue(NULL, '', NULL, NULL, NULL);
                Test.stopTest(); 
                Assert.areEqual(configrationsDataNeg.size(), 1, 'get configrations from custom metadata in neg test case');
                Assert.areEqual(childsObjectNeg.size(), 0, 'get all child sObject behalf of parent object in neg test case');
                Assert.areEqual(integratedFieldsNeg.size(), 0, 'get Integrated field size test in negative test case');
                Assert.areEqual(aggregateResListNeg.size(), 0, 'get field Value with negative test case');
    }
    
    

}