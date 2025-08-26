/*
* @Description : This class is test class of DataExpoter where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 26/11/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 26/11/2024 
*/
@isTest
public class DataExpoterTest {
    
    @testSetup
    static void testSetupMethod(){
       PermissionSet createPermissionSetInstance = TestDataFactory.createPermissionSetInstance('TestPermissionSet', 'Test PermissionSet', 'create test permisison set');
        if(createPermissionSetInstance != NULL){
            Database.insert(createPermissionSetInstance, false);
        }
    }
    
     /*
* @description : This method is test method for positive test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testPositiveCases(){    
                List<PermissionSet> permissionSetList = [SELECT Id FROM PermissionSet WHERE Name = 'TestPermissionSet'];
                Test.startTest();       
                List<Object> configrationsData = DataExpoter.getsObjectWithConfigration();
                List<sObject> dataList = DataExpoter.getAllData('PermissionSet');                
                Test.stopTest(); 
               Assert.areEqual(configrationsData.size(), 3, 'get configrations from custom metadata');
              Assert.areEqual(dataList.size(), 141, 'get all records in datalist in positive case');
    }
    
     /*
* @description : This method is test method for negative test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testNegativeCases(){    
                Test.startTest();       
                List<Object> configrationsDataNeg = DataExpoter.getsObjectWithConfigration();
                List<sObject> dataNegList = DataExpoter.getAllData(NULL);                
                Test.stopTest(); 
                Assert.areEqual(configrationsDataNeg.size(), 3, 'get configrations from custom metadata in negative');
                Assert.areEqual(dataNegList.size(), 0, 'get all records in dataNegList in negative case');           
          }  

}