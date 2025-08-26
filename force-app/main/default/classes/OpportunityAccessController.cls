/*
* @Description : This class is used for restrict go through opportunity records in Visualforce Page;
* @Author      : Vivek Kumar Saurabh
* @Created Date: 21/06/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 21/06/2024
*/
public class OpportunityAccessController {
    private ApexPages.StandardSetController standardController;
    public Boolean validateProfileValue { get; set; }    
    
    /*
	* @description : This method is a contructor method for getting Apex controller record.
	* @param : ApexPages.StandardController stdController  In this we reload apex pages controller.
	* @return : N/A.
	*/
    public OpportunityAccessController(ApexPages.StandardSetController controller){
        this.standardController = controller;
    }  
    
    /*
	* @description : This method is controll a button when click to validate the user profile.
	* @param : N/A.
	* @return : PageReference in this we redirect on Opportunity Record .
	*/
    public PageReference checkHandler() {
        try {
            if(validateProfile()){
                standardController.save();
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You are not a System Admin'));
                return null;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Opportunities saved successfully.'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }
    
    /*
	* @description : This method is controll a cancel button.
	* @param : N/A.
	* @return : PageReference in this we redirect on Opportunity Record .
	*/
    public PageReference cancelHandler() {
        return standardController.cancel();
    }
    
    /*
	* @description : This method is used for validate profile.
	* @param : N/A.
	* @return :Boolean if profile match then that user save the record.
	*/
    private Boolean validateProfile() {
        Profile p = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        return p.Name == System.Label.Proflie;
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
        PageReference listViewRef = new PageReference('/lightning/o/Opportunity/list');
        listViewRef.getParameters().put('filterName', 'Recent'); 
        return listViewRef;
    }
    
    /*
	* @description : This method is used for set result of .
	* @param : N/A.
	* @return :Boolean if profile match then that user save the record.
	*/
    public Boolean getValidateProfileValue() {
        return validateProfile();
    }
    
}