/*
* @Description : This class is used to phone Input field validate behalf on country Code in LWC.
* @author      : Vivek Kumar Saurabh
* @Created Date: 09/11/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 09/11/2024
*/
public class DynamicPhoneInputWithCountryCode { 
    /*
* @description : This method is used for getting all country behalf on configration. 
* @param : N/A.
* @return : List<ContriesConfiguration__mdt> getting all list of country metadata configration.
*/   
    @AuraEnabled
    public static List<ContriesConfiguration__mdt> getAllCountryConfiguration(){
        return [SELECT Id, Label, CountryAlphaCode__c FROM ContriesConfiguration__mdt WHERE Id != NULL AND Label != NULL AND CountryAlphaCode__c != NULL];
    }
    
    /*
* @description : This method is used for get all country Information using static resource JSON. 
* @param : N/A.
* @return : String  JSON of all coutry information.
*/   
    @AuraEnabled
    public static String getAllCountryInfo(){
        try{     
            StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'CountryInformation' LIMIT 1];
            return  sr.body.toString();
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('DynamicPhoneInputWithCountryCode', 'getAllCountryInfo', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return null;
    }
    
    /*
* @description : This method is used for save all records in database. 
* @param : String sObjectName get sObjectApiName from lwc as api decorator, String recordId get recordId from lwc as api decorator, String phoneNumber get phone number .
* @return : sObject record return after upsert.
*/   
    @AuraEnabled
    public static sObject updateRecord(String sObjectName, String recordId, String phoneNumber){        
        sObject createsObjectRecord;
        if(sObjectName != NULL && recordId != NULL && phoneNumber != NULL){        
            createsObjectRecord = Schema.getGlobalDescribe().get(sObjectName).newSObject();
            try{
                Schema.SObjectType objType = createsObjectRecord.getSObjectType();
                Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
                Schema.SObjectField field = fieldMap.get('Phone');
                if(field != NULL){
                    createsObjectRecord.put('Id', recordId);
                    createsObjectRecord.put('Phone' , phoneNumber);                             
                    upsert createsObjectRecord;
                }
                
            }catch(Exception e){
                ExceptionHandlingClass.exceptionLogRecords('DynamicPhoneInputWithCountryCode', 'updateRecord', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            }            
        }
        return createsObjectRecord;
    }
}