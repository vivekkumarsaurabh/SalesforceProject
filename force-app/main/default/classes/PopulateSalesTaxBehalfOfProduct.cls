public class PopulateSalesTaxBehalfOfProduct {
    public static void populateSalesTaxes(List<Product__c> listOfProduct){        
        Map<String,Product__c> mapOfprodetails=new Map<String,Product__c>();
        Set<String> city=new Set<String>();
        Set<String> state=new Set<String>();
        for(Product__c singleprod: listOfProduct){
            String key = singleprod.Bill_to_City__c+'/'+singleprod.Bill_to_State_Province__c;
            city.add(singleprod.Bill_to_City__c);
            state.add(singleprod.Bill_to_State_Province__c);
            mapOfprodetails.put(key,singleprod);
        }        
        for(Product__c prod1:[SELECT Bill_to_City__c,Bill_to_State_Province__c,Sales_Tax__c,Product__c.Sales_Tax__r.Sales_Tax__c,Product__c.Sales_Tax__r.State__c,Product__c.Sales_Tax__r.City__c FROM Product__c WHERE Bill_to_City__c IN:city AND Bill_to_State_Province__c IN :state]){  
                 String k=prod1.Bill_to_City__c+'/'+prod1.Bill_to_State_Province__c;          
            if(mapOfprodetails.containsKey(k)){
                if(mapOfprodetails.get(k).Bill_to_City__c==prod1.Sales_Tax__r.City__c && mapOfprodetails.get(k).Bill_to_State_Province__c==prod1.Sales_Tax__r.State__c){
                    Double price=mapOfprodetails.get(k).Product_Amount__c*mapOfprodetails.get(k).Quantity__c;
                    Double tax=prod1.Sales_Tax__r.Sales_Tax__c/100;
                    Double total=price+(price*tax);                
                    mapOfprodetails.get(k).Total_Price__c=total; 
                    mapOfprodetails.get(k).Sales_Tax__c=prod1.Sales_Tax__c;
                }             
            }
            
        }
        
    }
    
}