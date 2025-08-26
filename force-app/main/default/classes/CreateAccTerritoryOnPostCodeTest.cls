/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 23/11/2023
* @Description : Test Class on Create Account Territory behalf of Territory Mapping Postal Code and Business Segment with Batch Apex.
******************************************************************/
@isTest
private class CreateAccTerritoryOnPostCodeTest {
    /**************************************************************************************************************************
	* @description : This method is test method of create Account Territory for positive testing.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @testSetup
    static void setupdataofAccount(){        
        Account accRec = Datafactory.returnAcc('newAcc');
        insert accRec;
        Catelog__c catelogRec = Datafactory.returnCatelog('catelog1');
        insert catelogRec;
    }
    
    @isTest
    static void testforCreateTerritoryforPos(){
        Test.startTest();
        List<Catelog__c> catelogList = [SELECT Id FROM Catelog__c];        
        Territory_Mapping__c territoryMapRec = Datafactory.returnTerritoryMap('TerritoryMap1', catelogList[0].Id, 'Jan 2022');
        insert territoryMapRec;
        CreateAccTerritoryBehalfOnPostalCode runBatch = new CreateAccTerritoryBehalfOnPostalCode();
        Database.executeBatch(runBatch);
        Test.stopTest();
        List<Account_Territory__c> accountTerritoryList = [SELECT ID FROM Account_Territory__c WHERE Catelog__c = :catelogList[0].Id];
        System.assertEquals(1, accountTerritoryList.size());
    }
    /**************************************************************************************************************************
	* @description : This method is test method of create Account Territory for negative testing.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    
    @isTest
    static void testforCreateTerritoryforNeg(){
        Test.startTest();
        List<Catelog__c> catelogList = [SELECT Id FROM Catelog__c];        
        Territory_Mapping__c territoryMapRec = Datafactory.returnTerritoryMap('TerritoryMap2', catelogList[0].Id, 'Jan 2000');
        insert territoryMapRec;
        CreateAccTerritoryBehalfOnPostalCode runBatch = new CreateAccTerritoryBehalfOnPostalCode();
        Database.executeBatch(runBatch);
        Test.stopTest();
        List<Account_Territory__c> accountTerritoryList = [SELECT ID FROM Account_Territory__c WHERE Catelog__c = :catelogList[0].Id];
        System.assertEquals(0, accountTerritoryList.size());
    }
}