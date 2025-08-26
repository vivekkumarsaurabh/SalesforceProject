/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 23/02/2023
* @Description : LWC Apex Code of AlgoTyping Test Class.
******************************************************************/
@isTest
public class AlgoTypingTest {
    /**************************************************************************************************************************
* @description : This method is test setup method .
* @param : N/A.
* @return : N/A.
***************************************************************************************************************************/
    @testSetup
    static void createRecord(){
        AlgoTyping_User__c iterateUser = DataFactory.insertAlgoUser();
        Database.insert(iterateUser, false);
    }    
    /**************************************************************************************************************************
* @description : This method is test method for running method .
* @param : N/A.
* @return : N/A.
***************************************************************************************************************************/
    @isTest
    static void runTestMethod(){
        Test.startTest(); 
        AlgoTyping_User__c  algoUser = [SELECT Id, User_mail__c FROM AlgoTyping_User__c LIMIT 1];
        List<AlgoTyping_User__c> alUsers =  AlgoTyping.loginHandle('saurabh', 'saurabh@gmail.com');
        System.assert(!alUsers.isEmpty()); //positive Test  
        List<AlgoTyping_User__c> alUsersNeg =  AlgoTyping.loginHandle('kumar', 'kumar@gmail.com');
        System.assertEquals(0, alUsersNeg.size()); //Negative Test 
        Date dt = Date.today();        
        List<Typing_Record__c> tyList = new List<Typing_Record__c>();       
        Typing_Record__c typeRec =  AlgoTyping.saveRecordHandle(dt, '15', '85', '45', '10', '5', String.valueOf(algoUser.Id));
        tyList.add(typeRec);
        System.assert(!tyList.isEmpty()); //positive Test 
        List<Typing_Record__c> typeRecList = AlgoTyping.retriveRecordHandle(String.valueOf(algoUser.Id));
        System.assert(!typeRecList.isEmpty()); //positive Test
        List<Typing_Record__c> typeRecListNeg = AlgoTyping.retriveRecordHandle(' ');
        System.assertEquals(0, typeRecListNeg.size()); //negative Test     
        List<AlgoTyping_User__c> userList =  AlgoTyping.searchEmail(String.valueOf(algoUser.User_mail__c));        
        System.assert(!userList.isEmpty()); //positive Test
        List<AlgoTyping_User__c> userListNeg =  AlgoTyping.searchEmail('lokesh@gmail.com');        
        System.assertEquals(0, userListNeg.size()); //Negative Test 
        List<AlgoTyping_User__c> users = new List<AlgoTyping_User__c>(); 
        AlgoTyping_User__c user =  AlgoTyping.signUpHandle('ajay', 'ajay@gmail.com');
        users.add(user);
        System.assert(!users.isEmpty()); //positive Test 
        Test.stopTest(); 
    }
    
}