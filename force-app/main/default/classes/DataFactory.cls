@isTest
public class DataFactory {
    public static Class__c returnClassRec(String name){
        Class__c createClassRec = new Class__c();
        createClassRec.Name = name;
        return createClassRec;
    } 
    
    public static Schedule__c returnScheduleRec(String name, Id idOfClass, Id recordTypeId){
        Schedule__c createScheduleRec = new Schedule__c();
        createScheduleRec.Name = name;
        createScheduleRec.RecordTypeId = recordTypeId;
        createScheduleRec.Class__c = idOfClass;      
        return createScheduleRec;
    }
    
    public static Lead_file__c returnLeadFile(String name, Id idOfClass, String stageName){
        Lead_file__c createLeadFileRec = new Lead_file__c();
        createLeadFileRec.Name = name;
        createLeadFileRec.Stage__c = stageName;
        createLeadFileRec.Class__c = idOfClass;
        return createLeadFileRec;
    }
    
    public static AHJ__c returnAHJ(String name){
        AHJ__c createAHjRec = new AHJ__c();
        createAHjRec.Name = name;
        return createAHjRec;
    }
    public static RP__c returnRP(String name, Id idOfAhj){
        RP__c createRPRec = new RP__c();
        createRPRec.Name = name;
        createRPRec.AHJ__c = idOfAhj;
        return createRPRec;
    }
    
    public static PT__c returnPT(String name, Id idOfPT){
        PT__c createPTRec = new PT__c();
        createPTRec.Name = name;
        createPTRec.RP__c = idOfPT;
        createPTRec.Start_Date__c = date.newinstance(2023,8,10);
        createPTRec.End_Date__c = date.newinstance(2023,8,20);
        return createPTRec;
    }
    
    public static Account returnAcc(String name){
        Account createAccRec = new Account();
        createAccRec.Name = name;
        //createAccRec.ShippingPostalCode = '101';
        //createAccRec.Business_Segment__c = 'School';
        //createAccRec.Support_Tier__c = 'Bronze'; 
        //createAccRec.CreateCsv__c = createCsvchekBox;
        //createAccRec.Email_External_Id__c = exId;
        //createAccRec.Rating = rating;
        return createAccRec;     
    }
    
    public static Catelog__c returnCatelog(String name){
        Catelog__c createCatelogRec = new Catelog__c();
        createCatelogRec.Name = name;
        return createCatelogRec;
    }
    
    public static Territory_Mapping__c returnTerritoryMap(String name, Id idOfCatelog, String effectivePeriod){
        Territory_Mapping__c createTerritoryMap = new Territory_Mapping__c();
        createTerritoryMap.Name = name;
        createTerritoryMap.Catelog__c = idOfCatelog;
        createTerritoryMap.Effective_Period__c = effectivePeriod;
        createTerritoryMap.Postal_Code__c = '101,102';
        createTerritoryMap.Business_Segment__c = 'School';        
        return createTerritoryMap;
    }
    
    public static Contact returnContact(String name, Id idOfAcc){
        Contact createCon = new Contact();
        createCon.LastName = name;
        createCon.AccountId = idOfAcc;
        return createCon;
    }
          
    public static ContentVersion returnContentVersion(Id recId, String extension){
        ContentVersion conVer = new ContentVersion();
        String data  = 'Name\nAccount1\nAccount2\nAccount3';
        conVer.FirstPublishLocationId = recId;  
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = extension;
        conVer.IsMajorVersion = false;
        conVer.Title = 'new file';
        conVer.versionData = Blob.valueOf(data);
        return conVer;
    }
    
    public static ContentDocument returnContentDoc(Id recId){
        ContentDocument conDoc = new ContentDocument();        
        conDoc.Title = 'image';
        return conDoc;        
    }        
    
    public static ContentDocumentLink returnContentDocLink(Id recId, Id conDocId){
        ContentDocumentLink createRec = new ContentDocumentLink();
        createRec.ContentDocumentId = conDocId;
        createRec.LinkedEntityId = recId;
        return createRec;
    }
    
    public static InstaUser__c returnInstauser(String name, String email, String pass){
            InstaUser__c createuser = new InstaUser__c();
            createuser.Name = name;
            createuser.Email__c = email;
            createuser.Password__c = pass;
            return createuser;
    }
    
    public static Post__c returnPost(String userId){
        Post__c createPost = new Post__c();
        createPost.InstaUser__c = userId;
        return createPost;
    }
    
    public static Attendence_User__c returnAttendenceUserRec(){
        Attendence_User__c createRec = new Attendence_User__c();
        createRec.Name = 'TestName';
        return createRec;
    } 
    
    public static Attendence_Record__c returnAttendenRec(Id userId){
        Attendence_Record__c createRec = new Attendence_Record__c();
        Date dt = date.newinstance(2024, 1, 20);
        createRec.Attendence_Date__c = dt;
        createRec.Present_Absent__c = true;
        createRec.Attendence_User_Name__c = userId;
        return createRec;
    }
    
    public static Salon_Man__c returnSalonMan(){
        Salon_Man__c createRec = new Salon_Man__c();
        createRec.Name = 'John';
        createRec.Email__c = 'john@gmail.com';
        createRec.Password__c = '12345';
        createRec.Phone__c = '9685746342';
        return createRec;
    }
    
    public static Salon_Categories__c insertSalonCategory(){
        Salon_Categories__c createRec = new Salon_Categories__c();
        createRec.Name = 'Hair Trim';
        createRec.Price__c = 200.00;
        createRec.Booking_Hours__c = '2.0 Hours';
        return createRec;
    }
    
    public static WhatsApp_Contact__c createWhatsAppUser(){
        WhatsApp_Contact__c createuser = new WhatsApp_Contact__c();
        createuser.Name = 'TestUser';
        createuser.Phone__c = '918252295919';
        return createuser;
    }
    
    public static WhatsApp_Message__c createWhatsAppMsg(){
        WhatsApp_Message__c createMsg = new WhatsApp_Message__c();
        createMsg.CustomerPhone__c = '918252295919';
        return createMsg;
    }
    
    
    public static AlgoTyping_User__c insertAlgoUser(){
        AlgoTyping_User__c createRec = new AlgoTyping_User__c();
        createRec.Name = 'Saurabh';
        createRec.User_mail__c = 'saurabh@gmail.com';
        return createRec;
    }
    
     
    
}