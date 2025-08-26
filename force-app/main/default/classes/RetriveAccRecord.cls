/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 20/12/2023
* @Description : LWC Apex Code On Account Record Quick Action button CRUD Operation.
******************************************************************/
public with sharing class RetriveAccRecord {
    @Auraenabled
    public static List<Contact> retriveRecord(String accId){
        List<Contact> listOfCon = [SELECT Id, LastName, phone FROM Contact WHERE AccountId =:accId];           
        return listOfCon;
    }    
    @Auraenabled(cacheable=true)
    public static List<ContactWrapper> retriveRecordWrap(String accId){
        List<ContactWrapper> recList = new List<ContactWrapper>();
        for(Contact iterateRec : [SELECT Id, LastName, phone FROM Contact WHERE AccountId =:accId]){
            ContactWrapper createRec = new ContactWrapper();
            createRec.Id = iterateRec.Id;
            createRec.recordLink = '/'+ iterateRec.Id;
            createRec.LastName = iterateRec.LastName;
            createRec.Phone = iterateRec.phone;
            recList.add(createRec);
        }           
        return recList;
    } 
    
    @Auraenabled
    public static void deleteData(String recId){
        Contact conRec = [SELECT Id FROM Contact WHERE Id =:recId LIMIT 1]; 
        delete conRec;
    }
    
    @Auraenabled
    public static void deleteBulkData(List<Id> recIdList){
        List<Contact> conRecList = [SELECT Id FROM Contact WHERE Id IN : recIdList];
        System.debug('this id --->'+conRecList);
        delete conRecList;
    }
    
    @Auraenabled
    public static void insertData(String parentRecId, String conName, String conPhone){
        Contact createCon = new Contact();       
        createCon.AccountId = parentRecId;
        createCon.LastName = conName;
        createCon.Phone = conPhone;
        insert createCon;
    }

    @Auraenabled
    public static Contact retriveData(String recId){
        Contact record = [SELECT Id, LastName, Phone FROM Contact WHERE Id =:recId LIMIT 1];
        return record;
    } 
    
    @Auraenabled
    public static void updateData(String recId, String conName, String conPhone){
        Contact conUpdate = new Contact();
        conUpdate.Id = recId;
        conUpdate.LastName = conName;
        conUpdate.Phone = conPhone;
        update conUpdate;
        system.debug(conUpdate);
    }

    public class ContactWrapper{
        String Id;
        String recordLink;
        String LastName;
        String Phone;
    }
}