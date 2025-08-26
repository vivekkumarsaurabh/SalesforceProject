/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 23/02/2024
* @Description : LWC Apex Code of AlgoTyping.
******************************************************************/
public without sharing class AlgoTyping {
    /**************************************************************************************************************************
	* @description : This method is for login user.
	* @param : String name, String email.
	* @return : List<AlgoTyping_User__c>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<AlgoTyping_User__c> loginHandle(String name, String email){ 
        List<AlgoTyping_User__c> userlist = [SELECT Id, Name, User_mail__c FROM AlgoTyping_User__c WHERE User_mail__c =:email AND Name =:name];
        return userlist;
    }    
    
     /**************************************************************************************************************************
	* @description : This method is for create Record of Typing History.
	* @param : Date dt, String tim, String acc, String wpm, String corrChar, String inCorrChar, String userId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Typing_Record__c saveRecordHandle(Date dt, String tim, String acc, String wpm, String corrChar, String inCorrChar, String userId){
        Typing_Record__c createRec = new Typing_Record__c();
        createRec.AlgoTyping_User__c = userId;
        createRec.Accuracy__c = acc;
        createRec.Date__c = dt;
        createRec.Right_Char__c = corrChar;
        createRec.Time__c = tim;
        createRec.WPM__c = wpm;
        createRec.Wrong_Char__c = inCorrChar;
       insert createRec;
       return createRec;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for retrive Record of Typing History.
	* @param : String user.
	* @return : List<Typing_Record__c>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<Typing_Record__c> retriveRecordHandle(String user){
        List<Typing_Record__c> recList = [SELECT AlgoTyping_User__r.Name, Date__c, WPM__c, Time__c, Right_Char__c, Wrong_Char__c, Accuracy__c FROM  Typing_Record__c WHERE AlgoTyping_User__c = :user];
        return recList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is serch for duplicate email.
	* @param : String email.
	* @return : List<AlgoTyping_User__c>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<AlgoTyping_User__c> searchEmail(String email){
        return [SELECT Id, Name, User_mail__c FROM AlgoTyping_User__c WHERE	User_mail__c =:email];
    }
    
    /**************************************************************************************************************************
	* @description : This method is use for create User.
	* @param : String name, String email.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static AlgoTyping_User__c signUpHandle(String name, String email){
        AlgoTyping_User__c createUser = new AlgoTyping_User__c();
        createUser.Name = name;
        createUser.User_mail__c = email;
        insert createUser;
        return createUser;
    }
    

}