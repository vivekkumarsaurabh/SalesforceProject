@isTest
public class PopulateSalesTaxOnProdDataFactory {  
    public static List<SalesTax__c> insertSalesTax(Integer noOfRec, String state, String city,Integer per){
        List<SalesTax__c> listOfSales = new List<SalesTax__c>();
        for(Integer i =1; i <= noOfRec; i++){
          SalesTax__c createSalesTax = new SalesTax__c();
          createSalesTax.City__c = city;
           createSalesTax.State__c = state;
            createSalesTax.Sales_Tax__c = per;            
          listOfSales.add(createSalesTax);  
        }        
        return listOfSales;
    }
  
   public static List<Product__c> populateSalesTaxMethod(List<SalesTax__c> salesTaxList, Integer noOfRecord, Decimal amt, String state, String city,Integer quantity){
         List<Product__c> lisOfProduct = new List<Product__c>();
        for(SalesTax__c iterateSales :  salesTaxList){
        for(Integer i=1; i <= noOfRecord; i++){
            Product__c createProduct = new Product__c();
            createProduct.Sales_Tax__c = iterateSales.Id;
            createProduct.Bill_to_City__c = city;
            createProduct.Bill_to_State_Province__c = state;
            createProduct.Product_Amount__c = amt;
            createProduct.Quantity__c = quantity;
           lisOfProduct.add(createProduct);             
        }
        } 
       return lisOfProduct;
    }
    public static List<Product__c> insertProduct(Integer noOfRec, Decimal amt, String state, String city,Integer quantity){
        List<Product__c> lisOfProduct = new List<Product__c>();
        for(Integer i=1; i<=noOfRec; i++){
           Product__c createProduct = new Product__c();           
            createProduct.Bill_to_City__c = city;
            createProduct.Bill_to_State_Province__c = state;
            createProduct.Product_Amount__c = amt;
            createProduct.Quantity__c = quantity;
           lisOfProduct.add(createProduct);  
        }        
        return lisOfProduct;
    }
}