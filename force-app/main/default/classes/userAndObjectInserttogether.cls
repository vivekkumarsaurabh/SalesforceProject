public class userAndObjectInserttogether {
    
    public static void showError() {
        Account acc = new Account(Name='TEst');
        insert acc;
        
        Profile profId = [SELECT Id FROM Profile LIMIT 1];
        UserRole usrRole = [SELECT Id FROM UserRole LIMIT 1];
        
        
        User insertUser = new User();  
        
        insertUser.alias = 'VKsrbh';
        insertUser.lastname='Saurabh'; 
        insertUser.email='vivekkumarsaurabh59@gmail.com';
        insertUser.username='vivekkumarsaurabh59@gmail.com';
        insertUser.emailencodingkey='UTF-8';
        insertUser.languagelocalekey='en_US';
        insertUser.localesidkey='en_US';
        insertUser.profileid = profId.Id;
        insertUser.userroleid = usrRole.Id;
        insertUser.timezonesidkey='America/Los_Angeles';
       
        
        insert insertUser; //Show Mix DML Error (MIXED_DML_OPERATION)
        
    }
}