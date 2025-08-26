/*
* @Description : This class is used for create Account Record using  Visualforce Page;
* @Author      : Vivek Kumar Saurabh
* @Created Date: 20/06/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 20/06/2024
*/
public with sharing class CustomListViewController {
    public Account newAccount { get; set; }
    public Account newAccountRecord {get; set;} 
    private ApexPages.StandardController stdController;
    private Boolean result { get; set; }
    
    /*
	* @description : This method is a contructor method for getting Apex controller record.
	* @param : ApexPages.StandardController stdController  In this we get Account record.
	* @return : N/A.
	*/
    public CustomListViewController(ApexPages.StandardController stdController) {
        this.stdController = stdController;        
        this.newAccount = (Account)stdController.getRecord();
    }    
    
    /*
	* @description : This method is used for set value in validate.
	* @param : N/A.
	* @return :N/A.
	*/
    public void validate(){
        validateProfile();
    }
    
    /*
	* @description : This method is used for back to page
	* @param : N/A.
	* @return :PageReference  redirect on current page.
	*/
    public PageReference backtoPage(){
        return new PageReference('/' + newAccount.Id);
    }
    
    
    /*
	* @description : This method is used for save Account record with validate our Profile.
	* @param : N/A.
	* @return : PageReference in this we redirect new Account Record .
	*/
    public PageReference saveAccount() {
        if(validateProfile()){
            try {
                newAccountRecord = new Account();
                newAccountRecord.Name = newAccount.Name;
                newAccountRecord.Type = newAccount.Type;
                newAccountRecord.Industry = newAccount.Industry;
                insert newAccountRecord;
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error creating account: ' + e.getMessage()));
                return null;
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You have not permission to create Account'));
            return null;
        }        
        return new PageReference('/' + newAccountRecord.Id);
    }
    
    /*
	* @description : This method is used for validate profile.
	* @param : N/A.
	* @return :Boolean if profile match then that user save the record.
	*/
    public Boolean validateProfile() {
        Profile p = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        return p.Name == System.Label.Proflie;
    }
    
    /*
	* @description : This method is used for set result of .
	* @param : N/A.
	* @return :Boolean if profile match then that user save the record.
	*/
    public Boolean getResult() {
        return validateProfile();
    }
}