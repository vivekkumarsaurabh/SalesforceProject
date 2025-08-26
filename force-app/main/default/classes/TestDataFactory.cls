/*
* @Description : This class is used for Test Data Factory class for creating sObject Record.
* @author      : Vivek Kumar Saurabh
* @Created Date: 05/06/2024
*/
@isTest
public class TestDataFactory {
    /*
	* @description : This method is create Account Record.
	* @param : String name (Account has Name required field. so, It has to used be a param).
	* @return : Account (Return Insstace of Account Record).
	*/
    public static Account createAccountRecordInstance(String name){
        Account createRecord = new Account();
        createRecord.Name = name; 
        createRecord.Type = 'Customer';
        createRecord.Industry = 'Education';
        return createRecord;
    } 
    
    /*
	* @description : This method is create Permission Set.
	* @param : String name (Account has Name required field. so, It has to used be a param).
	* @return : Account (Return Insstace of Account Record).
	*/
    public static PermissionSet createPermissionSetInstance(String name, String label, String description){
        PermissionSet permissionSetRecord = new PermissionSet();
        permissionSetRecord.Name = name; 
        permissionSetRecord.Label = label; 
        permissionSetRecord.Description = description; 
        return permissionSetRecord;
    }
    /*
	* @description : This method is create Opportunity with Account and Contact.
	* @param : String name (Account has Name required field. so, It has to used be a param).
	* @return : Account (Return Insstace of Account Record).
	*/
    public static Opportunity createOpportunityInstance(String name, String stageName, String accountId, String contactId){
        Opportunity createOpportunityRecord = new Opportunity();
        createOpportunityRecord.Name = name;
        createOpportunityRecord.StageName = stageName;
        createOpportunityRecord.CloseDate = Date.today();
        createOpportunityRecord.AccountId = accountId;
        createOpportunityRecord.ContactId = contactId;
        return createOpportunityRecord;
    }
    
        /*
	* @description : This method is create Opportunity with Account.
	* @param : String name (Account has Name required field. so, It has to used be a param).
	* @return : Account (Return Insstace of Account Record).
	*/
    public static Opportunity createOpportunityWithoutContactInstance(String name, String stageName, String accountId){
        Opportunity createOpportunityRecord = new Opportunity();
        createOpportunityRecord.Name = name;
        createOpportunityRecord.StageName = stageName;
        createOpportunityRecord.CloseDate = Date.today();
        createOpportunityRecord.AccountId = accountId;
        return createOpportunityRecord;
    }
    
    
      /*
	* @description : This method is create Opportunity.
	* @param : String name (Account has Name required field. so, It has to used be a param).
	* @return : Account (Return Insstace of Account Record).
	*/
    public static Opportunity createOpportunity(String name, String stageName){
        Opportunity createOpportunityRecord = new Opportunity();
        createOpportunityRecord.Name = name;
        createOpportunityRecord.StageName = stageName;
        createOpportunityRecord.CloseDate = Date.today();
        return createOpportunityRecord;
    }
    
     /*
	* @description : This method is create Contact.
	* @param : String lastName (Contact has LastName required field. so, It has to used be a param).
	* @return : Contact (Return Insstace of Contact Record).
	*/
    public static Contact createContactInstance(String lastname, String accountId){
        Contact createContactRecord = new Contact();
        createContactRecord.LastName = lastname;
        createContactRecord.AccountId = accountId;
        return createContactRecord;
    }
    
      /*
	* @description : This method is create Contact.
	* @param : String lastName (Contact has LastName required field. so, It has to used be a param).
	* @return : Contact (Return Insstace of Contact Record).
	*/
    public static Contact createContactRecordInstance(String lastname, String email){
        Contact createContactRecord = new Contact();
        createContactRecord.LastName = lastname;
        createContactRecord.Email = email;
        return createContactRecord;
    }
    
    /*
	* @description : This method is create Group.
	* @param : String groupName (Grouo has Name required field. so, It has to used be a param).
	* @return : Group (Return Insstace of Group Record).
	*/
    public static Group createGroupInstance(String groupName){
        Group createGroupRecord = new Group();
        createGroupRecord.Name = groupName;
        createGroupRecord.DeveloperName = groupName;
        createGroupRecord.Type = 'Regular';
        return createGroupRecord;
    }

 /*
	* @description : This method is create Group.
	* @param : String groupName (Grouo has Name required field. so, It has to used be a param), String groupType (define ehich type of group).
	* @return : Group (Return Insstace of Group Record).
	*/
    public static Group createGroupsInstance(String groupName, String groupType){
        Group createGroupRecord = new Group();
        createGroupRecord.Name = groupName;
        createGroupRecord.DeveloperName = groupName;
        createGroupRecord.Type = groupType;
        createGroupRecord.Email = 'test@gmail.com';
        return createGroupRecord;
    }
    
    /*
	* @description : This method is create QueueSobject.
	* @param : String queueId (Grouo has Name required field. so, It has to used be a param), String groupType (define ehich type of group).
	* @return : QueueSobject (Return Instace of QueueSobject Record).
	*/
    public static QueueSobject createQueueSobjectInstance(String queueId, String sObjectType){
        QueueSobject createQueueSobjectRecord = new QueueSobject();
        createQueueSobjectRecord.QueueId = queueId;
        createQueueSobjectRecord.SobjectType = sObjectType;
        return createQueueSobjectRecord;
    }
     /*
	* @description : This method is create Task.
	* @param : String groupName (Grouo has Name required field. so, It has to used be a param), String groupType (define ehich type of group).
	* @return : Task (Return Insstace of Group Record).
	*/
    public static Task createTaskInstance(String groupId){
        Task createTaskRecord = new Task();
        createTaskRecord.OwnerId = groupId;
        createTaskRecord.Status = 'In Progress';       
        createTaskRecord.Subject = 'Email';
        createTaskRecord.Priority = 'High';
        return createTaskRecord;
    }
    


     /*
	* @description : This method is create User.
	* @param : String aliasName, String userEmail, String lastName, String profileId, String userName.
	* @return : User (Return Instace of User Record).
	*/
    public static User createUserInstance(String aliasName, String userEmail, String lastName, String profileId, String userName){
        User createUserRecord = new User();
        createUserRecord.Alias = aliasName;
        createUserRecord.Email = userEmail;
        createUserRecord.EmailEncodingKey = 'UTF-8';
        createUserRecord.LastName = lastName;
        createUserRecord.LanguageLocaleKey = 'en_US';
        createUserRecord.LocaleSidKey = 'en_US';
        createUserRecord.ProfileId = profileId;
        createUserRecord.TimeZoneSidKey = 'America/Los_Angeles';
        createUserRecord.Username = userName;
        return createUserRecord;
    }
    
    
     /*
	* @description : This method is create Case.
	* @param : String aliasName, String userEmail, String lastName, String profileId, String userName.
	* @return : User (Return Instace of User Record).
	*/

    public static Case createCaseInstance(String subject){
        Case createCaseRecord = new Case();
        createCaseRecord.Status = 'Working';        
        createCaseRecord.Origin = 'Phone';
        createCaseRecord.Subject = subject;
        return createCaseRecord;
    }
    

    
}