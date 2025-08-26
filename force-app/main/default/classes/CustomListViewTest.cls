/*
* @Description : This class is test class of CustomListView where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 11/09/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 12/09/2024 
*/
@isTest
public class CustomListViewTest {
    
    
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
                MetadataService.SaveResult listviewResult = new MetadataService.SaveResult();
                listviewResult.fullName = 'Tesing list view';
                listviewResult.success = true;
                res.result = new MetadataService.SaveResult[] {listviewResult};
                    response.put('response_x', res);
            }
            if (request instanceOf MetadataService.updateMetadata_element) {
                MetadataService.updateMetadataResponse_element res = new MetadataService.updateMetadataResponse_element();
                res.result = new MetadataService.SaveResult[] {};
                    response.put('response_x', res);
            }
            if (request instanceOf MetadataService.deleteMetadata_element) {
                MetadataService.deleteMetadataResponse_element res = new MetadataService.deleteMetadataResponse_element();
                res.result = new MetadataService.DeleteResult[] {};
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
        Opportunity createOpportunityRecord = TestDataFactory.createOpportunity('Test Opportunity', 'Prospecting');
        if(createOpportunityRecord != NULL){
            Database.insert(createOpportunityRecord, false); 
        }
        Group createGroupRecord = TestDataFactory.createGroupInstance('TestGroup1');
        if(createGroupRecord != NULL){
            Database.insert(createGroupRecord, false); 
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
        Object_Configration__mdt objectConfigration = [SELECT Id, MasterLabel FROM Object_Configration__mdt WHERE Id != NULL AND MasterLabel = 'Opportunity' LIMIT 1];
        Opportunity opportunityRecord = [SELECT Id, Name, StageName FROM Opportunity WHERE Name = 'Test Opportunity'];
        ListView listViewData = [SELECT Id, DeveloperName, Name, SobjectType FROM ListView WHERE SobjectType = 'Opportunity' LIMIT 1];
        String updateData  = '[{"attributes": {"type": "Opportunity"},"stageName": "Prospecting","Id": "'+opportunityRecord.Id+'"}]';   
        String filterData = '[{"displayClass": "custom1","fieldName": "Name","operator": "equals", "value": "Test Opportunity"}]';        
        String finnalFieldList = '[{"key":"Description","value":2},{"key":"StageName","value":3}]';
        String shareToList = '[{"name":"TestGroup", "icon":"utility:account", "groupType": "regular"}]';
        List<String> filterColumnsList = new List<String>{'OPPORTUNITY.NAME'};
            if(objectConfigration != NULL && opportunityRecord != NULL){
                Test.startTest();       
                List<MetadataService.SaveResult> metadataServiceSaveResultList =  CustomListView.createListView('OPPORTUNITY', 'Test List View', 'TestListView321', filterColumnsList);    
                List<MetadataService.SaveResult> metadataUpdateListView = CustomListView.updateListViewMetadata('OPPORTUNITY', 'TestListView', 'TestListView', filterColumnsList, filterData, shareToList, NULL);                 
                List<MetadataService.DeleteResult> metadataDeleteListView = CustomListView.deleteListViewMetadata('TestListView', 'OPPORTUNITY');
                List<Object> sObjectConfigrationList = CustomListView.retriveSobjectName();
                String sObjectAPlName = CustomListView.getsObjectApiName(objectConfigration.Id);        
                List<Object> columnsList = CustomListView.getColumns(objectConfigration.Id);
                List<sObject> dataList = CustomListView.getData(objectConfigration.Id, 'Opportunity');
                List<sObject>  dataSearchList = CustomListView.searchKey('Test', 'Opportunity', objectConfigration.Id);
                List<String> fieldConfigrationList = CustomListView.returnfields(objectConfigration.Id);
                List<Object> allFieldWrapper = CustomListView.getAllFields(objectConfigration.Id);
                String icon = CustomListView.objectIconMethod('Opportunity');
                List<Object> listViewList =  CustomListView.gettingListView('Opportunity');
                List<sObject> filterSobjectList = CustomListView.getfilterList(filterData, 'Opportunity', objectConfigration.Id);
                List<String> getRichTextFieldList = CustomListView.getRichTextFields('Opportunity');
                CustomListView.arrangeFiled(finnalFieldList, objectConfigration.Id, 'Opportunity');
                List<Object> filterWrapperList = CustomListView.gettingFilter(listViewData.DeveloperName, 'Opportunity');               
                List<Group> groupList = CustomListView.gettingRecords('regular', 'Test');
                List<sObject> updateSObjectList = CustomListView.updatesObjectRecord(updateData);
                List<sObject> sObjectDeletedList = CustomListView.deletesObjectRecord(opportunityRecord.Id, 'Opportunity');
                List<Object> timeIntervalList = CustomListView.timeInterval();
                Test.stopTest(); 
                Assert.areEqual(sObjectConfigrationList.size(), 2, 'configration of sObject in list');
                Assert.areEqual(sObjectAPlName, 'Opportunity', 'sObject Api name return');
                Assert.areEqual(columnsList.size(), 5, 'return column configration in columnList');
                Assert.areEqual(dataList.size(), 1, 'sObject records return in data list');
                Assert.areEqual(dataSearchList.size(), 1, 'when we search in records then return records behalf on keyword');
                Assert.areEqual(fieldConfigrationList.size(), 5, 'field configration of sObject in list');
                Assert.areEqual(updateSObjectList.size(), 1, 'update data in records then return updated record');
                Assert.areEqual(allFieldWrapper.size(), 5, 'all fields wrapper in list');
                Assert.areEqual(icon, 'standard:opportunity', 'return icon behalf on object');
                Assert.areEqual(filterSobjectList.size(), 1, 'filter data behalf on sObject');
                Assert.areEqual(sObjectDeletedList.size(), 1, 'delete list of Opportunity records');
                Assert.areEqual(listViewList.size(), 16, 'List view list return in this list');
                Assert.areEqual(filterWrapperList.size(), 0, 'map fill their field list this map getting Opportunity field ');
                Assert.areEqual(getRichTextFieldList.size(), 1, 'get Rich Text field list');
                Assert.areEqual(metadataServiceSaveResultList.size(), 1, 'metadata service create List view save results');
                Assert.areEqual(metadataUpdateListView.size(), 0, 'metadata service update List view save result');
                Assert.areEqual(metadataDeleteListView.size(), 0, 'metadata service delete List view save result');
                Assert.areEqual(timeIntervalList.size(), 3, 'metadata  time interval list size');
                
            }      
    }
    
    
    /*
* @description : This method is test method for negative test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testNegativeCases(){ 
                Test.startTest();
                List<MetadataService.SaveResult> metadataServiceSaveResultListNeg =  CustomListView.createListView(NULL, NULL, NULL, NULL);    
                //List<MetadataService.SaveResult> metadataUpdateListViewNeg = CustomListView.updateListViewMetadata(NULL, NULL, NULL, NULL, NULL, NULL);                 
                List<MetadataService.DeleteResult> metadataDeleteListViewNeg = CustomListView.deleteListViewMetadata(NULL, NULL);
                List<Object> sObjectConfigrationListNeg = CustomListView.retriveSobjectName();
                String sObjectAPlNameNeg = CustomListView.getsObjectApiName(NULL);        
                List<Object> columnsListNeg = CustomListView.getColumns(NULL);
                List<sObject> dataListNeg = CustomListView.getData(NULL, NULL);
                List<sObject> dataSearchListNeg = CustomListView.searchKey(NULL, NULL, NULL);
                List<String> fieldConfigrationListNeg = CustomListView.returnfields(NULL);
                List<Object> allFieldWrapperNeg = CustomListView.getAllFields(NULL);
                String iconNeg = CustomListView.objectIconMethod(NULL);
                List<Object> listViewListNeg =  CustomListView.gettingListView(NULL);
                List<sObject> filterSobjectListNeg = CustomListView.getfilterList(NULL, NULL, NULL);
                CustomListView.arrangeFiled(NULL, NULL, NULL);
                List<Object> filterWrapperListNeg = CustomListView.gettingFilter(NULL, NULL);               
                List<Group> groupListNeg = CustomListView.gettingRecords(NULL, NULL);
                List<sObject> updateSObjectListNeg = CustomListView.updatesObjectRecord(NULL);
                List<sObject> sObjectDeletedListNeg = CustomListView.deletesObjectRecord(NULL, NULL);
                Test.stopTest();
                Assert.areEqual(sObjectConfigrationListNeg.size(), 2, 'configration of sObject in Neg list');
                Assert.areEqual(sObjectAPlNameNeg, NULL, 'sObject Api name return in negative');
                Assert.areEqual(columnsListNeg.size(), 0, 'return column configration in Neg columnList');
                Assert.areEqual(dataListNeg.size(), 0, 'sObject records return data in Neg list');
                //Assert.areEqual(dataSearchListNeg.size(), 0, 'when we search in records then return zero records behalf on keyword because everything is null');
                Assert.areEqual(fieldConfigrationListNeg.size(), 0, 'field configration of sObject in list');
                Assert.areEqual(updateSObjectListNeg.size(), 0, 'update data in records then return updated record');
                Assert.areEqual(allFieldWrapperNeg.size(), 0, 'all fields wrapper in Neg list');
                Assert.areEqual(iconNeg, NULL, 'return icon behalf on object');
                Assert.areEqual(filterSobjectListNeg.size(), 0, 'filter data behalf on sObject');
                Assert.areEqual(sObjectDeletedListNeg.size(), 0, 'delete list of Opportunity records');
                Assert.areEqual(listViewListNeg.size(), 0, 'List view list return in this list');
                Assert.areEqual(filterWrapperListNeg.size(), 0, 'map fill their field list this map getting Opportunity field ');
                Assert.areEqual(metadataServiceSaveResultListNeg.size(), 0, 'metadata service create List view save results in Neg');
               // Assert.areEqual(metadataUpdateListViewNeg.size(), 0, 'metadata service update List view save result in Neg');
                Assert.areEqual(metadataDeleteListViewNeg.size(), 0, 'metadata service delete List view save result in Neg');
                
    }
    
}