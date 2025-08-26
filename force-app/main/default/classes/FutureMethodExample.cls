public class FutureMethodExample {
    @future
    public static void insertUserWithRole(
        String uname, String al, String em, String lname) {            
            Profile profileOfUser = [SELECT Id FROM Profile WHERE Name='Vivekkumarsaurabh59@gmail.com'];
            UserRole userRoleName = [SELECT Id FROM UserRole WHERE Name='HR'];            
            User u = new User(alias = al, email=em, 
                              emailencodingkey='UTF-8', lastname=lname, 
                              languagelocalekey='en_US', 
                              localesidkey='en_US', profileid = profileOfUser.Id, userroleid = userRoleName.Id,
                              timezonesidkey='America/Los_Angeles', 
                              username=uname);
            insert u;
        }
    
    
}