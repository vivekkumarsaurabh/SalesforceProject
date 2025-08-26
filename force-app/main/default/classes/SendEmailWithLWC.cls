/*
* @Description : This class is used to send Email with LWC component.
* @author      : Vivek Kumar Saurabh
* @Created Date: 23/10/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 23/10/2024
*/
public class SendEmailWithLWC {
    
    /*
* @description : This method is used for getting all users from Database. 
* @param : N/A.
* @return : List<UserWrapper> getting all users and bind in wrapper list.
*/   
    @AuraEnabled
    public static List<UserWrapper> getAllUsers(){
        List<UserWrapper> userWrapperList = new List<UserWrapper>();
        try{
            for(OrgWideEmailAddress iterateUser : [SELECT Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName != NULL AND Address != NULL]){
                UserWrapper createWrapper = new UserWrapper();
                createWrapper.label = iterateUser.DisplayName+'  '+iterateUser.Address;
                createWrapper.value = iterateUser.Address;
                userWrapperList.add(createWrapper);
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('SendEmailWithLWC', 'getAllUsers', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return userWrapperList;
    }
    
    /*
* @description : This method is used for sending mail. 
* @param : N/A.
* @return : List<UserWrapper> getting all users and bind in wrapper list.
*/     
    @AuraEnabled
    public static Boolean sendEmail(String subject, String toUserList, String body, String fromUser, String toCcUserList, String toBccUserList, String fileBlobList, String relatedTo){
        Boolean sendingMsg = false;
        List<Messaging.SendEmailResult> sendMsgResult = new List<Messaging.SendEmailResult>();
        List<OrgWideEmailAddress> orgWideEmailAddressList = new List<OrgWideEmailAddress>();
        List<FileBlobWrapper> deserialiseBlobWrapperList = new List<FileBlobWrapper>(); 
        List<String> toMailList = new List<String>();
        List<String> cCMailList = new List<String>();
        List<String> bccMailList = new List<String>();
        try{  
            if(fromUser != NULL){
                orgWideEmailAddressList = [select Id from OrgWideEmailAddress where Address = :fromUser];
            }
            if(fileBlobList != NULL){
                deserialiseBlobWrapperList = (List<FileBlobWrapper>) JSON.deserialize(fileBlobList, List<FileBlobWrapper>.class);
            }
            
            if(toUserList != NULL){
                List<MailWrapper> toMailWrapperList = (List<MailWrapper>) JSON.deserialize(toUserList, List<MailWrapper>.class);
                if(!toMailWrapperList.isEmpty()){
                    for(MailWrapper iterateMail : toMailWrapperList){
                        toMailList.add(iterateMail.email);
                    }  
                }
                
            }
            if(toBccUserList != NULL){
                List<MailWrapper> bccMailWrapperList = (List<MailWrapper>) JSON.deserialize(toBccUserList, List<MailWrapper>.class);
                if(!bccMailWrapperList.isEmpty()){
                    for(MailWrapper iterateMail : bccMailWrapperList){
                        bccMailList.add(iterateMail.email);
                    }   
                }
            }
            if(toCcUserList  != NULL || toBccUserList != NULL){
                List<MailWrapper>  cCMailWrapperList = (List<MailWrapper>) JSON.deserialize(toCcUserList, List<MailWrapper>.class);
                if(!cCMailWrapperList.isEmpty()){
                    for(MailWrapper iterateMail : cCMailWrapperList){
                        cCMailList.add(iterateMail.email);
                    }
                }               
                
            }
            
            if(subject != NULL && !toMailList.isEmpty()){
                List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
                List<Messaging.EmailFileAttachment> attchments = new List<Messaging.EmailFileAttachment>();
                if(!deserialiseBlobWrapperList.isEmpty()){
                    for(FileBlobWrapper iterateWrapper : deserialiseBlobWrapperList){
                        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                        attachment.setContentType(iterateWrapper.filetype);      
                        attachment.setFileName(iterateWrapper.fileName);        
                        attachment.Body = iterateWrapper.blobBody; 
                        attchments.add(attachment);
                    } 
                }                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();           
                mail.setToAddresses(toMailList);
                mail.setCcAddresses(cCMailList);
                mail.setBccAddresses(bccMailList);
                mail.setSubject(subject);
                mail.setHtmlBody(body);
                mail.setOrgWideEmailAddressId(orgWideEmailAddressList.get(0).Id);
                mail.setFileAttachments(attchments);     
                mailsList.add(mail);    
                if(mailsList.size() > 0){            
                    sendMsgResult = Messaging.SendEmail(mailsList);                    
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('SendEmailWithLWC', 'sendEmail', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        System.debug(sendMsgResult);
        if(!sendMsgResult.isEmpty() && sendMsgResult.get(0).isSuccess()){ 
            Case createCaseEmail  = new Case();
            createCaseEmail.Priority = 'High';
            createCaseEmail.Origin = 'Email';
            createCaseEmail.Comments = body.stripHtmlTags();
            createCaseEmail.SuppliedEmail = fromUser;
            insert createCaseEmail;
            EmailMessage createEmailMessage = new EmailMessage();           
            createEmailMessage.FromName = subject;
            createEmailMessage.BccAddress = String.join(bccMailList, ',');
            createEmailMessage.CcAddress = String.join(cCMailList, ',');
            createEmailMessage.ToAddress = String.join(toMailList, ',');
            createEmailMessage.ParentId = createCaseEmail.Id;
            createEmailMessage.Subject = subject;
            createEmailMessage.HtmlBody = body;
            createEmailMessage.TextBody = body.stripHtmlTags();  
            createEmailMessage.RelatedToId = relatedTo;
            insert createEmailMessage;            
            sendingMsg = true;            
        }
        return sendingMsg;
    }
    
    /*
* @description : This method is used for getting all contacts. 
* @param : String conName contactName.
* @return : List<Contact> getting all contacts which belongs to searchKey.
*/   
    @AuraEnabled
    public static List<Contact> getContact(String searchContactName){   
        List<Contact> conList = new List<Contact>();
        try{
            if(searchContactName != NULL){
                String key = '%'+searchContactName+'%';
                conList = [SELECT Id, Name, Email FROM Contact WHERE Email != NULL AND Name != NULL AND Email Like :key];
            }       
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('SendEmailWithLWC', 'getContact', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return conList;
    }
    
    /*
* @description : This method is used for getting all fields. 
* @param : String objectName.
* @return :  List<OptionWrapper> getting all fields.
*/   
    @AuraEnabled
    public static List<OptionWrapper> getAllFields(String objectName){        
        List<OptionWrapper> optionWrapperList = new List<OptionWrapper>();
        try{
            Map <String, Schema.SObjectType> SObjectMap = Schema.getGlobalDescribe();
            Map<String, Schema.SObjectField> sObjectfieldMap = SObjectMap.get(objectName).getDescribe().fields.getMap();   
            if(sObjectfieldMap != NULL){  
                for(String iterateField : sObjectfieldMap.keySet()){
                    Schema.SObjectField field = sObjectfieldMap.get(iterateField);
                    Schema.DescribeFieldResult fieldResult = field.getDescribe();
                    if(fieldResult.isCreateable() && fieldResult.isUpdateable()){
                        OptionWrapper createWrapper = new OptionWrapper();
                        createWrapper.label = String.valueOf(fieldResult.getLabel());
                        createWrapper.value = iterateField;
                        optionWrapperList.add(createWrapper);
                    }
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('SendEmailWithLWC', 'getAllFields', e.getMessage(), e.getStackTraceString(), e.getLineNumber());             
        }
        return optionWrapperList;
    }
    
    /*
* @description : This method is used for getting all sObject 
* @param : N/A.
* @return : List<OptionWrapper> getting all sObject values.
*/   
    @AuraEnabled
    public static List<SobjectWrapper> getAllsObject(){
        Map <String, Schema.SObjectType> SObjectMap = Schema.getGlobalDescribe(); 
        List<SobjectWrapper> sObjectWrapperList = new List<SobjectWrapper>();
        try{
            if(SObjectMap != NULL){
                for(String iterateSObject : SObjectMap.keySet()){
                    Schema.SObjectType sObjectType = sObjectMap.get(iterateSObject);
                    Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();
                    String label = describeResult.getLabel();
                    SobjectWrapper createSObjectWrapper = new SobjectWrapper();
                    createSObjectWrapper.label = label;
                    createSObjectWrapper.value = iterateSObject;
                    createSObjectWrapper.icon = objectIconMethod(iterateSObject, sObjectType);
                    sObjectWrapperList.add(createSObjectWrapper);
                }      
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('SendEmailWithLWC', 'getAllsObject', e.getMessage(), e.getStackTraceString(), e.getLineNumber()); 
            
        }
        
        return sObjectWrapperList;
    }
    
    /*
* @description : This method is used for getting field value for bind variable. 
* @param : String sObjectName get sObject Name, String fieldApiName getFieldAPI name, String sObejctApiRefrenceId get sObejctApi Id.
* @return : String value return only value.
*/   
    
    @AuraEnabled
    public static String getFieldValue(String sObjectName, String fieldApiName, String sObejctApiRefrenceId){
        System.debug('sObejctApiRefrenceId---->'+sObejctApiRefrenceId);
        System.debug('fieldApiName--->'+fieldApiName);        
        String value; 
        if(sObjectName != NULL && fieldApiName != NULL && sObejctApiRefrenceId != NULL){
            String query = 'SELECT '+fieldApiName+' FROM '+sObjectName+' WHERE Id = :sObejctApiRefrenceId';
            List<sObject> queryList = Database.query(query);
            if(!queryList.isEmpty()){
            for(sObject iterate : queryList){
                value = String.valueOf(iterate.get(fieldApiName));
            } 
            }
        }  
        return value;   
    }
    
    /*
* @description : This method is used for return Query with Id and Name.
* @param : String objectName  In objectName checked if their any field of name or not on that object.
* @return : String return query of that object with Name and Id.
*/ 
    public static String returnQueryWithName(String objectName){
        String query;
        try{
            query ='SELECT ';
            if(objectName != NULL){
                Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
                if(objType != NULL){
                    Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
                    String fieldName = 'Name';
                    if (fieldMap.containsKey(fieldName)) {
                        query += fieldName+', Id';
                    } else {
                        query += 'Id';
                    }
                    query += ' FROM ' + objectName;
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('SendEmailWithLWC', 'returnQueryWithName', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return query;
    }
    
    /*
* @description : This method is used for getting all records. 
* @param : String sObjectName get sObject  as a params .
* @return : List<OptionWrapper> getting all sObject records.
*/   
    @AuraEnabled
    public static List<OptionWrapper> getAllRecords(String sObjectName){
        Boolean isName = false;        
        List<OptionWrapper> sObjectWrapperRecord =  new List<OptionWrapper>();
        List<sObject> sObjetRecordList = new List<sObject>();  
        try{      
            if(sObjectName != NULL){
                String query = returnQueryWithName(sObjectName);
                sObjetRecordList = Database.query(query);
            } 
            for(sObject iterateRecord : sObjetRecordList){
                OptionWrapper createWrapper = new OptionWrapper();
                if(iterateRecord.get('Name') != NULL){
                    createWrapper.label = String.valueOf(iterateRecord.get('Name'));
                    createWrapper.value = String.valueOf(iterateRecord.get('Id'));
                    sObjectWrapperRecord.add(createWrapper);
                }else{
                    createWrapper.label = String.valueOf(iterateRecord.get('Id'));
                    createWrapper.value = String.valueOf(iterateRecord.get('Id'));
                    sObjectWrapperRecord.add(createWrapper);
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('SendEmailWithLWC', 'getAllRecords', e.getMessage(), e.getStackTraceString(), e.getLineNumber()); 
            
        }        
        return sObjectWrapperRecord;
    }
    
    /*
* @description : This method is used for objectIcon.
* @param : String objectName (sObjectAPIName to take dynamically object Icon).Schema.SObjectType objToken objectToken for return icon. 
* @return : String (return dynamically icon). 
*/
    
    public static String objectIconMethod(String objectName, Schema.SObjectType objToken){
        String iconName;  
        try{
            if(objectName != NULL){
                if(objToken != NULL){
                    if(objToken.getDescribe().isCustom()){
                        iconName = System.Label.CustomIcon;
                    }else{
                        iconName = System.Label.StandardIcon+objectName.toLowerCase();
                    }
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('SendEmailWithLWC', 'objectIconMethod', e.getMessage(), e.getStackTraceString(), e.getLineNumber()); 
        }
        return iconName;
    }
    
    
    
    public class OptionWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class UserWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        
    }
    public class SobjectWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String icon;
    }
    
    public class MailWrapper{
        @AuraEnabled public String name;
        @AuraEnabled public String email;
        @AuraEnabled public String id;
        @AuraEnabled public String pillIdentifier;
    }
    
    public class FileBlobWrapper{
        @AuraEnabled public String fileName;        
        @AuraEnabled public String fileType; 
        @AuraEnabled public Blob blobBody; 
    }
    
}