/*
* @Description : This class is test class of OpportunityAccessController where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 21/06/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 24/06/2024 
*/
@isTest
public class OpportunityAccessControllerTest {

    /*
	* @description : This method is test method for positive test cases.
	* @param : N/A.
	* @return : N/A.
	*/      
    @isTest
    static void testPositiveCases(){   
        List<Opportunity> opportunityList = new List<Opportunity>();
        PageReference backtoPage = new PageReference('/lightning/o/Opportunity/list?filterName=Recent');
        PageReference cancelPage = new PageReference('/home/home.jsp');
        Test.startTest();  
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController(opportunityList);
        OpportunityAccessController controllerExtension = new OpportunityAccessController(controller);     
        PageReference pageReferCheckHandler = controllerExtension.checkHandler();
        PageReference pageReferCancel = controllerExtension.cancelHandler();
        controllerExtension.validate();
        PageReference backtoCurrentPage = controllerExtension.backtoPage();
        Boolean validateProfile = controllerExtension.getValidateProfileValue();
        controllerExtension.validateProfileValue = validateProfile;
        Test.stopTest(); 
        Assert.areEqual(pageReferCheckHandler, NULL, 'Testing that false then retuen NULL value');
        Assert.areEqual(backtoCurrentPage, backtoPage, 'Testing for back to main Page where you have perform action');
        Assert.areEqual(pageReferCancel, cancelPage, 'Testing for back to cancel page means current Page');
        Assert.areEqual(validateProfile, False, 'Testing for get result for profile is match or not');
        Assert.areEqual(controllerExtension.validateProfileValue, validateProfile, 'Testing for get Result');
    }
    
    /*
	* @description : This method is test method for negative test cases.
	* @param : N/A.
	* @return : N/A.
	*/      
    @isTest
    static void testNegativeCases(){ 
    List<Opportunity> opportunityList = new List<Opportunity>();
        PageReference backtoPage = new PageReference('/lightning/o//list?filterName=Recent');
        PageReference cancelPage = new PageReference('/home/home.jsp');
        Test.startTest();  
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController(opportunityList);
        OpportunityAccessController controllerExtension = new OpportunityAccessController(controller);     
        PageReference pageReferCheckHandler = controllerExtension.checkHandler();
        PageReference pageReferCancel = controllerExtension.cancelHandler();
        controllerExtension.validate();
        PageReference backtoCurrentPage = controllerExtension.backtoPage();
        Boolean validateProfile = controllerExtension.getValidateProfileValue();
        controllerExtension.validateProfileValue = validateProfile;
        Test.stopTest(); 
        Assert.areEqual(pageReferCheckHandler, NULL, 'Testing that false then retuen NULL value');
        Assert.areEqual(backtoCurrentPage, backtoPage, 'Testing for back to main Page where you have perform action');
        Assert.areEqual(pageReferCancel, cancelPage, 'Testing for back to cancel page means current Page');
        Assert.areEqual(validateProfile, False, 'Testing for get result for profile is match or not');
        Assert.areEqual(controllerExtension.validateProfileValue, validateProfile, 'Testing for get Result');    
    }
}