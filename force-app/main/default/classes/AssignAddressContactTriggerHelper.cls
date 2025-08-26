public class AssignAddressContactTriggerHelper {    
    public static void beforeInsertUpdateAssignAddress(List<Contact> newContList){
        Map<String, Office_Address__mdt> storeMdt = new Map<String, Office_Address__mdt>();
        for(Office_Address__mdt iterateMdt :[SELECT MasterLabel, Address__c FROM Office_Address__mdt]){
            storeMdt.put(iterateMdt.MasterLabel, iterateMdt);
        }
        for(Contact newCont : newContList){
            if(storeMdt.containsKey(newCont.Office_Location__c)){
                newCont.Office_Address__c = storeMdt.get(newCont.Office_Location__c).Address__c;
            }
        }
        List<Office_Address__mdt> mcs = Office_Address__mdt.getAll().Values();
        system.debug('mcs---'+mcs);        
        String msg = Label.Error_Msg;
        System.debug(msg);
        String num = Label.Number_Label;
        System.debug(num);        
        Map<String, Office_Address__mdt> mapOfData = new  Map<String, Office_Address__mdt>();
        for(Office_Address__mdt iteration : [SELECT MasterLabel, Address__c, Email__c FROM Office_Address__mdt]){
            mapOfData.put(iteration.MasterLabel, iteration);
        }
        for(Contact newCon : newContList){
            if(mapOfData.containsKey(newCon.Phone)){
                newCon.Email = mapOfData.get(newCon.Phone).Email__c;
                newCon.Office_Address__c = mapOfData.get(newCon.Phone).Address__c;
            }
        }        
    }
    
    public static void beforeInsertAreaCodeInPhone(List<Contact> newContList){
        Map<String, Country__c> mapOfDataCustmSet = new Map<String, Country__c>();               
        for(Country__c iteratCountry: [SELECT Name, PhoneCode__c FROM Country__c]){
            mapOfDataCustmSet.put(iteratCountry.Name, iteratCountry);
        } 
        for(Contact  newConIterate: newContList){            
            if(mapOfDataCustmSet.containsKey(newConIterate.Country__c)){
                String areaCode = mapOfDataCustmSet.get(newConIterate.Country__c).PhoneCode__c;
                String phoneNumber = newConIterate.Phone;
                newConIterate.Phone = areaCode + phoneNumber;
            }                                     
        }                                 
    }
    
    public static void beforeInsertUpdateTotalAmtDsc(List<Contact> newListCon){
        Map<ID, amazonSale__c> mapOfDataCustmSet = new Map<ID, amazonSale__c>();
        for(amazonSale__c iterateAmzSale : [SELECT Name, Discount__c, SetupOwnerId FROM amazonSale__c]){
            mapOfDataCustmSet.put(iterateAmzSale.SetupOwnerId, iterateAmzSale);
        }       
        // amazonSale__c  vivekkumarsaurabh = amazonSale__c.getInstance('0055j000008GxTLAA0');
        // amazonSale__c  jenniferBetta = amazonSale__c.getInstance('0055j0000098dJRAAY');      
        for(Contact newContact : newListCon){
            if(mapOfDataCustmSet.containsKey(newContact.OwnerId)){
                Double total = (newContact.Ammount__c * mapOfDataCustmSet.get(newContact.OwnerId).Discount__c)/100; 
                newContact.Discount_On_Product__c = mapOfDataCustmSet.get(newContact.OwnerId).Discount__c;
                newContact.Total_Ammount__c = newContact.Ammount__c - total;
            }
        }        
    }
    
}