/*
* @Description : This class is test class of AssignUserIntoGroup where testing different positive scenario and negative scenario.
* @author      : Vivek Kumar Saurabh
* @Created Date: 05/12/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 05/12/2024 
*/
@isTest
public class AssignUserIntoGroupTest {

  	/*
	* @description : This method is test setup method for creating test Records.
	* @param : N/A.
	* @return : N/A.
	*/
    @testSetup
    static void  testSetupMethod(){
        Group createGroup = TestDataFactory.createGroupInstance('TestGroup');
        if(createGroup != NULL){
            Database.insert(createGroup, false);
        }        
        Profile profileInstance = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        if(profileInstance != NULL){
            User createUser = TestDataFactory.createUserInstance('testUser', 'testuser@testorg.com', 'Testing', profileInstance.Id, 'testuser1221@testorg.com');
            if(createUser != NULL){
               Database.insert(createUser, false);
            }
        }
    }
    
    /*
	* @description : This method is test method for positive test cases.
	* @param : N/A.
	* @return : N/A.
	*/    
    @isTest
    static void testPositiveCases(){
        Group groupRecord = [SELECT Id FROM Group WHERE Name = 'TestGroup' LIMIT 1]; 
        User userRecord = [SELECT Id FROM User WHERE LastName = 'Testing' LIMIT 1];
        System.debug('userRecord--->'+userRecord);
        Test.startTest();
         List<Object> groupList = AssignUserIntoGroup.getAllGroup();
         List<Object> userList = AssignUserIntoGroup.getAllUser();
         Group createGroupRecord = AssignUserIntoGroup.createPublicGroup('Test Group', 'GroupTest');
       	 List<Group> groupInsertList = new List<Group>();
        	if(createGroupRecord != NULL){
            	groupInsertList.add(createGroupRecord);
        	}        
         List<GroupMember> groupMemberList = AssignUserIntoGroup.getAssignAllUser(createGroupRecord.Id, new List<String>{userRecord.Id}); 
        Test.stopTest();
                Assert.areEqual(groupList.size(), 9,'testing positive cases for getting all group list');   
                Assert.areEqual(userList.size(), 21,'getting all user list for positive test cases');
                Assert.areEqual(groupInsertList.size(), 1,'testing positive cases for getting all group list');  
                Assert.areEqual(groupMemberList.size(), 1,'group Member assgin into a public group in positive test cases');
    }
    
    
    /*
	* @description : This method is test method for positive test cases.
	* @param : N/A.
	* @return : N/A.
	*/      
    @isTest
    static void testNegativeCases(){
        Test.startTest();
            Group createGroupRecordNeg = AssignUserIntoGroup.createPublicGroup(NULL, NULL);
            List<GroupMember> groupMemberListNeg = AssignUserIntoGroup.getAssignAllUser(NULL, NULL);
        Test.stopTest();
             Assert.areEqual(String.valueOf(createGroupRecordNeg), 'Group:{}','getting all user list for negative test cases');
             Assert.areEqual(groupMemberListNeg.size(), 0,'getting all user list for negative test cases');

    }
}