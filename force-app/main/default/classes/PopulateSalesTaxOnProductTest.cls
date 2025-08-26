@isTest
public class PopulateSalesTaxOnProductTest {    
    @isTest
    static void populateSalesTaxTest(){
        Test.startTest();
        List<SalesTax__c> listOfSalesTax = PopulateSalesTaxOnProdDataFactory.insertSalesTax(2, 'UP', 'Gaziabad', 10);
        Database.insert(listOfSalesTax, false);        
        List<Product__c> listOfProduct = PopulateSalesTaxOnProdDataFactory.populateSalesTaxMethod(listOfSalesTax, 2, 1000, 'UP', 'Gaziabad', 2);
        List<Database.saveResult> listOfSaveResult = Database.insert(listOfProduct, false);
        for(Database.saveResult iterateSaveRes : listOfSaveResult){
            System.assert(iterateSaveRes.isSuccess());
        }
        List<Product__c> listOfProductTr = PopulateSalesTaxOnProdDataFactory.insertProduct(2, 1500, 'UP', 'Gaziabad', 5);
        List<Database.saveResult> listOfSaveResults = Database.insert(listOfProductTr, false);
        for(Database.saveResult iterateSaveRes : listOfSaveResults){
            System.assert(iterateSaveRes.isSuccess());
        } 
        Test.stopTest();            
    }
    
}