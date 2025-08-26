/*
* @Description : This class is test class of SendEmailWithLWC where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 24/10/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 24/10/2024 
*/
@isTest
public class SendEmailWithLWCTest {
    
    
    /*
* @description : This method is test setup method for creating test Records.
* @param : N/A.
* @return : N/A.
*/
    @testSetup
    static void testSetupMethod(){
        Contact createContactRecord = TestDataFactory.createContactRecordInstance('Test Contact', 'saurabh.developer1@gmail.com');
        if(createContactRecord != NULL){
            Database.insert(createContactRecord, false); 
        }      
        Contact createSecondContactRecord = TestDataFactory.createContactRecordInstance('Second Contact', 'vivekkumarsaurabh59@gmail.com');
        if(createSecondContactRecord != NULL){
            Database.insert(createSecondContactRecord, false); 
        }  
    }
    
    /*
* @description : This method is test method for positive test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testPositiveCases(){
        String toUserList;
        String toCcUserList;         
        Contact contactRecord = [SELECT Id, Name, Email FROM Contact WHERE Email = 'saurabh.developer1@gmail.com' LIMIT 1];
        Contact secContactRecord = [SELECT Id, Name, Email FROM Contact WHERE Email = 'vivekkumarsaurabh59@gmail.com' LIMIT 1];
        System.debug('secContactRecord====>'+secContactRecord);
        if(contactRecord != NULL){
            toUserList = '[{"name" : "'+contactRecord.Name+'", "email": "'+contactRecord.Email+'", "id": "'+contactRecord.Id+'"}]';
        } 
        if(secContactRecord != NULL){
            toCcUserList = '[{"name" : "'+secContactRecord.Name+'", "email": "'+secContactRecord.Email+'", "id": "'+secContactRecord.Id+'"}]';
        }
        Test.startTest();       
        List<Object> allUserList = SendEmailWithLWC.getAllUsers();
        Boolean emailSender = SendEmailWithLWC.sendEmail('Subject Test', toUserList, '', 'vivek.saurabh@algocirrus.com', toCcUserList, NULL, NULL, NULL);
        List<Contact> conList = SendEmailWithLWC.getContact('Test Contact');
        List<Object> allFieldWrapperList = SendEmailWithLWC.getAllFields('Contact');   
        String fieldValue = SendEmailWithLWC.getFieldValue('Contact', 'Email', contactRecord.Id);
        List<Object> allRecords = SendEmailWithLWC.getAllRecords('Contact');
        List<Object> getAllsObject = SendEmailWithLWC.getAllsObject();                
        Test.stopTest();                  
        Assert.areEqual(allUserList.size(), 2, 'return all user list');    
        Assert.areEqual(emailSender, TRUE, 'return boolean for email send or not');
        Assert.areEqual(conList.size(), 0, 'return constact list');   
        Assert.areEqual(allFieldWrapperList.size(), 63, 'return constact list');  
        Assert.areEqual(fieldValue, 'saurabh.developer1@gmail.com', 'return field Value of sObject');                    
        Assert.areEqual(getAllsObject.size(),  2151, 'return all sObject Records');
    }
    
    
    /*
* @description : This method is test method for negative test cases.
* @param : N/A.
* @return : N/A.
*/      
    @isTest
    static void testNegativeCases(){ 
        Test.startTest();                    
        List<Object> allUserList = SendEmailWithLWC.getAllUsers();
        Boolean emailSenderNeg = SendEmailWithLWC.sendEmail(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
        List<Contact> conNegList = SendEmailWithLWC.getContact(NULL);
        List<Object> allFieldWrapperNegList = SendEmailWithLWC.getAllFields(NULL);   
        String fieldNegValue = SendEmailWithLWC.getFieldValue('Contact', NULL, NULL);
        List<Object> allNegRecords = SendEmailWithLWC.getAllRecords(NULL);
        List<Object> getAllsObject = SendEmailWithLWC.getAllsObject();             
        Test.stopTest(); 
        /**System.debug('allUserList-==>'+allUserList.size());
System.debug('sendEmail =====>'+emailSenderNeg);
System.debug('conNegList =====>'+conNegList.size());
System.debug('allFieldWrapperNegList =====>'+allFieldWrapperNegList.size());
System.debug('fieldNegValue =====>'+fieldNegValue);
System.debug('allNegRecords =====>'+allNegRecords.size());
System.debug('getAllsObject======>'+getAllsObject.size());**/
        // System.debug('sendEmail Neg =====>'+emailSender);
        Assert.areEqual(allUserList.size(), 2, 'return all user list');    
        Assert.areEqual(emailSenderNeg, false, 'return email sender in negative test');   
        Assert.areEqual(conNegList.size(), 0, 'return constact list in neg test');
        Assert.areEqual(allFieldWrapperNegList.size(), 0, 'return field Wrapper List in neg case');
        Assert.areEqual(fieldNegValue, NULL, 'return constact list in neg test');
        Assert.areEqual(allNegRecords.size(), 0, 'return records in negative case');
        Assert.areEqual(getAllsObject.size(), 2151, 'return sObject in Neg Case');
        
    }
    
}