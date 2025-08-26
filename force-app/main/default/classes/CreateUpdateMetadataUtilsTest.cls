/*
* @Description : This class is test class of InlineEditing where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 06/08/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 06/08/2024 
*/
@isTest
public class CreateUpdateMetadataUtilsTest {
   
     @IsTest public static void configSetupTest() {
         Map<String, Object> updateMetadataMap = new Map<String, Object>();
         updateMetadataMap.put('editable__c', true);
         updateMetadataMap.put('FieldName__c', 'Last_Name');
         updateMetadataMap.put('InlineEditingObjectName__c', 'Contact');
         updateMetadataMap.put('Sequence__c', 1);
         updateMetadataMap.put('sortable__c', true);    
         updateMetadataMap.put('type__c', 'text');
         updateMetadataMap.put('visible__c', false);
         String fullName = 'Account_Mapping.Last_Name';                           
        Test.startTest();
         CreateUpdateMetadataUtils.createUpdateMetadata(fullName, 'Last Name', updateMetadataMap);
        Test.stopTest();
    }
    
    @IsTest public static void CreateUpdateMetadataUtilsTest() {
        CreateUpdateMetadataUtils metadata = new CreateUpdateMetadataUtils();
        Test.startTest();
        metadata.handleResult(new Metadata.DeployResult(), new Metadata.DeployCallbackContext());
        Test.stopTest();
    }
    

}