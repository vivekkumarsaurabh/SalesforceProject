/*
* @Description : This class is used to Assign User into Public Group;
* @author      : Vivek Kumar Saurabh
* @Created Date: 04/12/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 04/12/2024 
*/
public class AssignUserIntoGroup {
    
    /*
* @description : This method is used for retrive all public group.
* @param : N.A.
* @return : List<GroupWrapper> return public group wrapper list for combo box.
*/  
    @AuraEnabled
    public static List<GroupWrapper> getAllGroup(){
        List<GroupWrapper> groupWrapperList = new List<GroupWrapper>();
        try{
            for(Group iterateGroup : [SELECT Id, Name FROM Group WHERE Type = 'Regular' AND Type != NULL]){
                GroupWrapper createGroupWrapper = new GroupWrapper();
                createGroupWrapper.label = iterateGroup.Name;
                createGroupWrapper.value = iterateGroup.Id;
                groupWrapperList.add(createGroupWrapper);
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('AssignUserIntoGroup', 'getAllGroup', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return groupWrapperList;
    }
    
    /*
* @description : This method is used for retrive all users.
* @param : N.A.
* @return : List<GroupWrapper> return user wrapper list.
*/  
    @AuraEnabled
    public static List<GroupWrapper> getAllUser(){
        List<GroupWrapper> userWrapperList = new List<GroupWrapper>();
        try{
            for(User iterateGroup : [SELECT Id, Name FROM User WHERE Name != NULL AND Id != NULL]){
                GroupWrapper createUserWrapper = new GroupWrapper();
                createUserWrapper.label = iterateGroup.Name;
                createUserWrapper.value = iterateGroup.Id;
                userWrapperList.add(createUserWrapper);
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('AssignUserIntoGroup', 'getAllUser', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return userWrapperList;        
    }
    
    /*
* @description : This method is used for retrive all users behalf of key.
* @param : String key (search name like key).
* @return : List<GroupWrapper> return user wrapper list.
*/
    @AuraEnabled
    public static List<GroupWrapper> searchUserHandler(String key){
        String searchKey = '%'+key+'%';
        List<GroupWrapper> userWrapperList = new List<GroupWrapper>();
        try{
            for(User iterateGroup : [SELECT Id, Name FROM User WHERE Name != NULL AND Id != NULL AND Name LIKE :searchKey]){
                GroupWrapper createUserWrapper = new GroupWrapper();
                createUserWrapper.label = iterateGroup.Name;
                createUserWrapper.value = iterateGroup.Id;
                userWrapperList.add(createUserWrapper);
            }            
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('AssignUserIntoGroup', 'searchUserHandler', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        }
        return userWrapperList; 
    }
    /*
* @description : This method is used for assign all user into public group.
* @param : String publicGroupId get public group Id, String userId get userId from org.
* @return : List<GroupMember> return all group members created after assigning user into public group.
*/  
    @AuraEnabled
    public static List<GroupMember> getAssignAllUser(String publicGroupId, List<String> userIds){
        List<GroupMember> groupMemberList = new List<GroupMember>();
        try{
            if(publicGroupId != NULL && !userIds.isEmpty()){
                for(String iterateUserId : userIds){
                    GroupMember createGroupMember = new GroupMember();
                    createGroupMember.GroupId = publicGroupId;
                    createGroupMember.UserOrGroupId = iterateUserId;
                    groupMemberList.add(createGroupMember);
                }
            }
            if(!groupMemberList.isEmpty()){
                insert groupMemberList;
                System.debug('groupMemberList===>'+groupMemberList);
            }
        }catch(Exception e){
            // ExceptionHandlingClass.exceptionLogRecords('AssignUserIntoGroup', 'getAssignAllUser', e.getMessage(), e.getStackTraceString(), e.getLineNumber());            
        }
        return groupMemberList;
    }
    
    /*
* @description : This method is used for create public group.
* @param : String publicGroupName.
* @return : List<GroupMember> return all group members created after assigning user into public group.
*/   
    @AuraEnabled
    public static Group createPublicGroup(String publicGroupLabel, String publicGroupName){
        Group createGroup = new Group();
        try{
            if(publicGroupName != NULL){
                createGroup.Name = publicGroupLabel;
                createGroup.DeveloperName = publicGroupName;
                createGroup.Type = 'Regular';
                insert createGroup;
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('AssignUserIntoGroup', 'getAssignAllUser', e.getMessage(), e.getStackTraceString(), e.getLineNumber());            
        }
        return createGroup;
    }
    
    public class GroupWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
}