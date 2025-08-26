/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 11/04/24
* @Description : Make a clone of Object with in params child related object list and fields of parent(clone) object. If we have same fields values of Object then we make thrir clone of their object;
******************************************************************/
public class SalesOrderLineItemHandler {
     /**************************************************************************************************************************
	* @description : This method is for create clone of object.
	* @param : List<Sales_Line_Item__c> salesLineItem, List<String> fieldList.
	* @return : N/A.
	***************************************************************************************************************************/
    public static void createSalesOrder(List<Sales_Line_Item__c> salesLineItem, List<String> fieldList){
        String str;
        List<Map<String, Object>> keysValueMapList = new List<Map<String, Object>>();
        List<Sales_Line_Item__c> salesLineItems = new List<Sales_Line_Item__c>();
        List<Sales_Order__c> salesOrderLst = new List<Sales_Order__c>();        
        List<Sales_Line_Item__c> salesLineItemList = new List<Sales_Line_Item__c>();
        Set<Id> idOfSalesOrder = new Set<Id>();        
        
        Map<String, Sales_Order__c> salesOrderMap = new Map<String, Sales_Order__c>();       
        Map<String, List<Sales_Line_Item__c>> childObjList = new Map<String, List<Sales_Line_Item__c>>(); 
        
        for(Sales_Line_Item__c iterateLineItem : salesLineItem){
            idOfSalesOrder.add(iterateLineItem.Sales_Order__c);
        }
        List<Sales_Order__c> salesOrderList = [SELECT Id, Distribution_Channel__c, Division__c  FROM Sales_Order__c WHERE ID IN : idOfSalesOrder];
        String saleList = JSON.serialize(salesOrderList); 
        List<Object> objList = (List<Object>)JSON.deserializeUntyped(saleList);
        for(Object iterateObj : objList){
            String obj = JSON.serialize(iterateObj);
            Map<String, Object> objMap = (Map<String, Object>) JSON.deserializeUntyped(obj);
            keysValueMapList.add(objMap);
        }            
        for(Map<String, Object> iterateMap : keysValueMapList){
            str+= '(';
            for(Integer k=0; k<fieldList.size(); k++){
                if(k == fieldList.size()-1){
                    str+=fieldList[k]+'= \''+JSON.serialize(iterateMap.get(fieldList[k])).remove('"')+'\'';
                }else{
                    str+=fieldList[k]+'= \''+JSON.serialize(iterateMap.get(fieldList[k])).remove('"')+'\' AND ';                    
                }                                
            }  
            str+=') OR ';           
        }
        str = str.removeStart('null');
        str = str.removeEnd('OR ');
        String query = 'SELECT SPlant__c, Sold_to_Party__c, ShiptoParty__c, Distribution_Channel__c, Division__c, (SELECT ID, Sales_Order__c, Name FROM Sales_Line_Items__r) FROM Sales_Order__c WHERE '+str;
        System.debug('query ===>'+query);
        List<Sales_Order__c> salesData = Database.query(query);       
        System.debug('queryData==>'+salesData);     
        //for uniqly fill lineItem Object from database
        for(Sales_Order__c iterate : salesData){
            String obj = JSON.serialize(iterate);
            Map<String, Object> objMap = (Map<String, Object>) JSON.deserializeUntyped(obj);      
            String key;
            for(Integer i = 0; i < fieldList.size(); i++){
                if(i == 0){
                    key = JSON.serialize(objMap.get(fieldList[i])).remove('"'); 
                }else{
                    key+= JSON.serialize(objMap.get(fieldList[i])).remove('"'); 
                }
            }            
            for(Sales_Line_Item__c iterateSaleItem : iterate.Sales_Line_Items__r){        
                if(childObjList.containsKey(key)){
                    salesLineItems = childObjList.get(key);
                }
                salesLineItems.add(iterateSaleItem);                
            } 
            childObjList.put(key, salesLineItems);
            Sales_Order__c salesOrder = new Sales_Order__c();
            salesOrder.Distribution_Channel__c = iterate.Distribution_Channel__c;
            salesOrder.Division__c = iterate.Division__c;
            salesOrder.Name = 'New Clone SalesOrder';
            salesOrder.ShiptoParty__c = iterate.ShiptoParty__c;
            salesOrder.Sold_to_Party__c = iterate.Sold_to_Party__c;
            salesOrder.SPlant__c = iterate.SPlant__c;
            salesOrderMap.put(key, salesOrder);            
        }       
        for(Sales_Order__c iterate : salesOrderMap.values()){
            salesOrderLst.add(iterate);            
        }        
        //insert salesOrderLst;        
        Integer count = 0;
        if(salesOrderLst.size() > count){ 
            for(String key : childObjList.keySet()){            
                for(Sales_Line_Item__c iterateLineItem : childObjList.get(key)){
                    iterateLineItem.Sales_Order__c = salesOrderLst[count].Id;
                    iterateLineItem.Id = null;
                    salesLineItemList.add(iterateLineItem);                
                }              
                // System.debug('key ===>'+key+'  values ===>'+childObjList.get(key));
                count++;
            }  
        } 
        //insert salesLineItemList;      
    }
    
     /**************************************************************************************************************************
	* @description : This method is for create clone of object (Optimize solution).
	* @param : List<Sales_Line_Item__c> salesLineItem, List<String> fieldList.
	* @return : N/A.
	***************************************************************************************************************************/
    public static void cloneRecord(List<Sales_Line_Item__c> salesLineItem, List<String> fieldList){ 
        Set<Id> salesOrderIds = new Set<Id>();
        Map<Id, String> keyFieldMap = new Map<Id, String>();
        Map<String, Sales_Order__c> idKeyMap = new Map<String, Sales_Order__c>();        
        Map<String, List<Sales_Line_Item__c>> salesLineItemsMap = new Map<String, List<Sales_Line_Item__c>>();
        Map<String, Id> salesOrderMap = new Map<String, Id>();
        
        List<Sales_Line_Item__c> salesLineItemList = new List<Sales_Line_Item__c>();
        List<Sales_Order__c> salesOrders = new List<Sales_Order__c>();
        
        for(Sales_Line_Item__c iterateLineItem : salesLineItem){
            salesOrderIds.add(iterateLineItem.Sales_Order__c);
        }         
        String query = 'SELECT ID, '+String.join(fieldList,',')+' From Sales_Order__c WHERE ID IN :salesOrderIds';
        List<Sales_Order__c> salesOrderList = Database.query(query);
        for(Sales_Order__c iterateSalesOrder : salesOrderList){
            String key = '';
            for(String iterateField : fieldList){
                key += iterateSalesOrder.get(iterateField);
            }
            keyFieldMap.put(iterateSalesOrder.Id, key); 
            idKeyMap.put(key, iterateSalesOrder); 
        }
        for(Sales_Order__c iterateSalesOrder  : idKeyMap.values()){
            iterateSalesOrder.Name = 'New Clone SalesOrder';
            iterateSalesOrder.Id = null;
            salesOrders.add(iterateSalesOrder);
        } 
        insert salesOrders;
        for(Sales_Line_Item__c iterateLineItem : salesLineItem){
            if(keyFieldMap.containsKey(iterateLineItem.Sales_Order__c) && idKeyMap.containsKey(keyFieldMap.get(iterateLineItem.Sales_Order__c))){
                List<Sales_Line_Item__c> lineItems = new List<Sales_Line_Item__c>();
                if(salesLineItemsMap.containsKey(keyFieldMap.get(iterateLineItem.Sales_Order__c))){
                    lineItems = salesLineItemsMap.get(keyFieldMap.get(iterateLineItem.Sales_Order__c));
                }
                lineItems.add(iterateLineItem);
                salesLineItemsMap.put(keyFieldMap.get(iterateLineItem.Sales_Order__c), lineItems);  
            }
        }
        for(Sales_Order__c iterateSalesOrder : salesOrders){
            String key = '';
            for(String iterateField : fieldList){
                key += iterateSalesOrder.get(iterateField);
            }
            salesOrderMap.put(key, iterateSalesOrder.Id);
        }        
        for(String key : salesLineItemsMap.keySet()){ 
            if(salesOrderMap.containsKey(key)){
                for(Sales_Line_Item__c iterateLineItem : salesLineItemsMap.get(key)){
                    iterateLineItem.Sales_Order__c = salesOrderMap.get(key);
                    iterateLineItem.Id = null;
                    salesLineItemList.add(iterateLineItem);                
                } 
            } 
        }        
       insert salesLineItemList;
    }
}