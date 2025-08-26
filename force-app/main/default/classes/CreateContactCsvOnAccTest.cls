/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 24/11/2023
* @Description : Test Class on Create Contact Csv On Account with Batch Apex.
******************************************************************/
@isTest
public class CreateContactCsvOnAccTest {  
    
    /**************************************************************************************************************************
	* @description : This method is test method of create contact Csv on Account for positive testing.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void testforCreateCsvforPos(){
        Test.startTest();
        Account createAcc = Datafactory.returnAcc('Acc1', true);
        insert createAcc;
        Contact createCon = Datafactory.returnContact('con1', createAcc.Id);
        insert createCon;
        Contact createCon2 = Datafactory.returnContact('con1', createAcc.Id);
        insert createCon2;
        CreateContactCsvOnAcc runBatch = new CreateContactCsvOnAcc();
        Database.executeBatch(runBatch);
        Test.stopTest();
        List<ContentDocument> listOfContenVer = [SELECT Id FROM ContentDocument];
        System.debug(listOfContenVer);
        System.assertEquals(1, listOfContenVer.size());
    }
    
    /**************************************************************************************************************************
	* @description : This method is test method of create contact Csv on Account for negative testing.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void testforCreateCsvforNeg(){
        Test.startTest();
        Account createAcc = Datafactory.returnAcc('Acc1', false);
        insert createAcc;
        Contact createCon = Datafactory.returnContact('con1', createAcc.Id);
        insert createCon;
        Contact createCon2 = Datafactory.returnContact('con1', createAcc.Id);
        insert createCon2;
        CreateContactCsvOnAcc runBatch = new CreateContactCsvOnAcc();
        Database.executeBatch(runBatch);
        Test.stopTest();
        List<ContentDocument> listOfContenVer = [SELECT Id FROM ContentDocument]; 
        System.assertEquals(0, listOfContenVer.size());
    }
    
    
    
    
    
}