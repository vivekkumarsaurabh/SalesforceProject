/*
* @Description : This class is used for override Standard Button;
* @author      : Vivek Kumar Saurabh
* @Created Date: 04/10/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 08/10/2024
*/
public class OverrideBtnHandler {
    /*
* @description : This method is for return Record Type with their RecordTypeId.
* @param : String objectName.
* @return : Map<String, String>.
*/  
    @AuraEnabled
    public static List<sObject> getRecordType(String objectName, String recordId) {
        List<sObject> recordTypeId = new List<sObject>();
        try{       
            if(objectName != NULL && recordId != NULL){
                String query = 'SELECT Name, RecordTypeId FROM '+objectName+' WHERE Id=\''+recordId+'\'';
                recordTypeId = Database.query(query);
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('OverrideBtnHandler', 'getRecordType', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return recordTypeId; 
    }
    
    /*
* @description : This method is for return label name.
* @param : String objectName.	
* @return : String.
*/  
    @AuraEnabled
    public static String returnObjectLable(String objectName) {
        String label;
        try{
            if(objectName != NULL){
                Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
                Schema.SObjectType sobjType = globalDescribe.get(objectName);
                Schema.DescribeSObjectResult objResult = sobjType.getDescribe();  
                label = String.valueOf(objResult.getLabel());
               }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('OverrideBtnHandler', 'returnObjectLable', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return label; 
    }
    
    /*
* @description : This method is for return child.
* @param : String objectName.	
* @return : String.
*/  
    @AuraEnabled
    public static Product_Mapping__c returnProductMapping(String recordId, String division, String splant, String distibution, Integer quantity) {
        String idofRec = recordId.remove('"');      
        return [SELECT Id, Distribution_Channel__c, SPlant__c, Division__c, Quantit__c FROM  Product_Mapping__c WHERE Id = :idofRec LIMIT 1];     
    }
    
    @AuraEnabled
    public static Sales_Order__c returnSalesOrder(String recordId){   
        return [SELECT Id, Distribution_Channel__c, Division__c, Quantity__c, SPlant__c, Product_Mapping__c FROM Sales_Order__c WHERE Id =: recordId LIMIT 1];
    }
    
    /*
* @description : This method is trigger method for update quantity after create.
* @param : List<Sales_Order__c> salesOrderList.	
* @return : N/A.
*/ 
    public static void updateQunatityProductMapHandler(List<Sales_Order__c> salesOrderList){
        Map<Id, Integer> productMap = new Map<Id, Integer>();
        for(Sales_Order__c iterateSalesOrder : salesOrderList){
            if(iterateSalesOrder.Product_Mapping__c != null){
                productMap.put(iterateSalesOrder.Product_Mapping__c, Integer.valueOf(iterateSalesOrder.Quantity__c));                
            }
        }
        List<Product_Mapping__c> productList = new List<Product_Mapping__c>();
        for(Product_Mapping__c iterateProduct : [SELECT Id, Distribution_Channel__c, SPlant__c, Division__c, Quantit__c FROM Product_Mapping__c WHERE Id IN : productMap.keySet()]){
            if(productMap.containsKey(iterateProduct.Id)){
                iterateProduct.Quantit__c = Integer.valueOf(iterateProduct.Quantit__c) - productMap.get(iterateProduct.Id);
                productList.add(iterateProduct);
            }                     
        }
        System.debug('data===>'+productList);
        if(productList.size() != 0){
            upsert productList;
        }        
    }
    
    /*
* @description : This method is trigger method for update quantity before edit.
* @param : List<Sales_Order__c> salesOrderList.	
* @return : N/A.
*/ 
    public static void updateExitedSalesOrderHandler(Map<Id, Sales_Order__c> salesOrderOldMap, Map<Id, Sales_Order__c> salesOrderNewMap){        
        Set<Id> productMapId = new Set<Id>();
        for(Sales_Order__c iterateSalesOrder : salesOrderOldMap.Values()){
            productMapId.add(iterateSalesOrder.Product_Mapping__c);
        }
        Map<Id, Product_Mapping__c> productMap = new Map<Id, Product_Mapping__c>();        
        for(Product_Mapping__c iterateRec : [SELECT Id, Quantit__c FROM Product_Mapping__c WHERE Id IN : productMapId]){
            productMap.put(iterateRec.Id, iterateRec);
        }
        List<Product_Mapping__c> productList = new List<Product_Mapping__c>();
        for(Id iterateSalesOrder : salesOrderOldMap.keySet()){
            if(Integer.valueOf(salesOrderOldMap.get(iterateSalesOrder).Quantity__c) > Integer.valueOf(salesOrderNewMap.get(iterateSalesOrder).Quantity__c)){
                Product_Mapping__c CreateProductMap = new Product_Mapping__c();
                if(productMap.containsKey(salesOrderOldMap.get(iterateSalesOrder).Product_Mapping__c)){
                    CreateProductMap = productMap.get(salesOrderOldMap.get(iterateSalesOrder).Product_Mapping__c);
                    CreateProductMap.Quantit__c = productMap.get(salesOrderOldMap.get(iterateSalesOrder).Product_Mapping__c).Quantit__c + salesOrderNewMap.get(iterateSalesOrder).Quantity__c;
                    productList.add(CreateProductMap);
                }
            }else{
                Product_Mapping__c CreateProductMap = new Product_Mapping__c();
                if(productMap.containsKey(salesOrderOldMap.get(iterateSalesOrder).Product_Mapping__c)){
                    CreateProductMap = productMap.get(salesOrderOldMap.get(iterateSalesOrder).Product_Mapping__c);
                    CreateProductMap.Quantit__c = productMap.get(salesOrderOldMap.get(iterateSalesOrder).Product_Mapping__c).Quantit__c - (salesOrderNewMap.get(iterateSalesOrder).Quantity__c - salesOrderOldMap.get(iterateSalesOrder).Quantity__c);
                    productList.add(CreateProductMap); 
                } 
            }
        }
        if(productList.size() != 0){
            upsert productList;
        }
    }
    
    
}