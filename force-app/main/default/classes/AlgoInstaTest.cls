/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 18/03/2023
* @Description : LWC Apex Code of AlgoInsta Test Class.
******************************************************************/
@isTest
public class AlgoInstaTest {
    /**************************************************************************************************************************
	* @description : This method is test setup method .
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @testSetup
    private static void createRecord(){ 
           InstaUser__c createUser = DataFactory.returnInstauser('lokesh', 'lokesh@email.com', '1234');
           Database.insert(createUser, false);
           
           ContentVersion conVerProfileImg = DataFactory.returnContentVersion(createUser.Id, '.png');
           Database.insert(conVerProfileImg, false);
        
           Post__c createPost = DataFactory.returnPost(createUser.Id);
           Database.insert(createPost, false);
        
           ContentVersion conVer = DataFactory.returnContentVersion(createPost.Id, '.png');
           Database.insert(conVer, false);
        
           ContentVersion conVerSec = DataFactory.returnContentVersion(createPost.Id, '.png');
           Database.insert(conVerSec, false);
        
                   
    } 	
    
    /**************************************************************************************************************************
	* @description : This method is test method for running method .
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    private static void runTestMethod(){  
       InstaUser__c user = [SELECT Id FROM InstaUser__c LIMIT 1];
       Post__c post = [SELECT Id FROM Post__c WHERE InstaUser__c = :user.Id LIMIT 1];
        
       Test.startTest();       
           InstaUser__c userCreateSec =  AlgoInsta.createUser('{"name":"Ajay","email":"ajay@gmail.com","pass":"12345"}');
           List<Object> getAllUser = AlgoInsta.getAllUsers(user.Id, 'lokesh@gmail.com');  
           List<Object> userSearch = AlgoInsta.searchUsers('Lokesh');
           Object userInfoWrapper = AlgoInsta.login('ajay@gmail.com');                
           Id postId = AlgoInsta.createPost(user.Id);        
           List<Object> imageWrapper = AlgoInsta.getImage(post.Id);
           Follower__c createFollower = AlgoInsta.createFollower(user.Id, 'Ajay', 'ajay@gmail.com');           
           Follower__c createFollowerSec = AlgoInsta.createFollower(String.valueOf(userCreateSec.Id), 'Lokesh', 'lokesh@gmail.com');
           Post__c  updatePost = AlgoInsta.updatePost('good post', post.Id);           
           comment__c cmt = AlgoInsta.postComment('very good post', post.Id, user.Id);           
           comment__c cmtOther = AlgoInsta.postComment('Excellent', post.Id, user.Id);        
           Like__c likePost = AlgoInsta.createLike(post.Id, user.Id);           
           Like__c likePostOther = AlgoInsta.createLike(post.Id, user.Id);
           List<Like__c> likeLists = AlgoInsta.removeLikePost(post.Id, user.Id);
           savePost__c savePost = AlgoInsta.createSavePost(user.Id, post.Id); 
           List<Object> retriveUserPostList = AlgoInsta.retriveUserPost(user.Id);           
           Object userDetails = AlgoInsta.getUserDetails(user.Id,'lokesh@gmail.com');  
           List<InstaUser__c> instaUser = AlgoInsta.verifyEmail('ajay@gmail.com');
           InstaUser__c userUpdate = AlgoInsta.updatePassword('ajay@gmail.com', '12345');
           List<Object> userProfileWrp = AlgoInsta.retriveSavePost(user.Id); 
           Object listOfPost = AlgoInsta.retriveAllrelativePost(user.Id);  
           Id msgId = AlgoInsta.createMsgHandler(user.Id, 'Hello', userCreateSec.Id);
           Id msgIdReceive = AlgoInsta.createMsgHandler(userCreateSec.Id, 'Hello', user.Id);
           String cdlId = AlgoInsta.uploadFile('data', 'new file', msgId);
           Object msg = AlgoInsta.returnUserMsg(user.Id, userCreateSec.Id);
           List<Object> msgUserProfile = AlgoInsta.returnMsgProfile(user.Id);
           String picUrl = AlgoInsta.profileImg(user.Id);
           List<InstaReel__c> reels = AlgoInsta.returnReels(user.Id, 'lokesh@gmail.com');
           InstaNotification__c notifaication = AlgoInsta.createNotificationHandler(userCreateSec.Id, 'is comment on your post', picUrl, user.Id, true);         
           List<Object> allnotification = AlgoInsta.retriveAllNotification(user.Id); 
           AlgoInsta.sendEmail('lokesh@gmail.com', '123456');
           ContentDocumentLink conDocLink = AlgoInsta.sendPost(post.Id, user.Id, userCreateSec.Id);         
           List<Object> retrivePostList = AlgoInsta.retrivePost(user.Id, 'lokesh@gmail.com');
           List<savePost__c> removePost = AlgoInsta.removeSavePost(user.Id, post.Id);            
           List<savePost__c> deleteSavePost = AlgoInsta.deleteSavePost(user.Id, post.Id);
           List<InstaMsg__c>  deleteMsg = AlgoInsta.deleteMsg(msgId);     
           List<Like__c>   deleteLike = AlgoInsta.removeLike(post.Id, user.Id);
           ContentDocumentLink deleteProfile = AlgoInsta.deleteProfilePic(user.Id);
           InstaUser__c updateProfile = AlgoInsta.updateProfile(userCreateSec.Id, 'Ritik', '12345');
           Post__c deletePost = AlgoInsta.deletePost(postId);
       Test.stopTest();        
       
        System.assert(userCreateSec != null);
        System.assert(!userSearch.isEmpty());
        System.assert(!getAllUser.isEmpty());
        System.assert(!imageWrapper.isEmpty());
        System.assert(userInfoWrapper != null);
        System.assert(postId != null);
        System.assert(updatePost != null);
        System.assert(cmt != null);
        System.assert(likePost != null);
        System.assert(likeLists != null);
        System.assert(savePost != null);
        System.assert(createFollower != null);
        System.assert(picUrl != null);
        System.assert(msgId != null);
        System.assert(msg != null);  
        System.assert(cdlId != null);
        System.assert(conDocLink != null);
        System.assert(notifaication != null);
        System.assert(!allnotification.isEmpty());
        System.assert(!retriveUserPostList.isEmpty());
        System.assert(userDetails != null);
        System.assert(!userProfileWrp.isEmpty());
        System.assert(listOfPost != null);  
        System.assert(reels != null);
        System.assert(instaUser != null);
        System.assert(userUpdate != null);
        System.assert(!retrivePostList.isEmpty());
        System.assert(!removePost.isEmpty()); 
        System.assert(!deleteSavePost.isEmpty());
        System.assert(!deleteLike.isEmpty());
        System.assert(deletePost != null);
        System.assert(!deleteMsg.isEmpty());
    }
   
     @isTest
    private static void runTestNullMethod(){ 
         Test.startTest();        
             InstaUser__c userCreateSec =  AlgoInsta.createUser('{"name":"Utpal","email":"1234567890","pass":"12345"}');
             Id postId = AlgoInsta.createPost('a165j000003YV7oAAG');
             Post__c postt = AlgoInsta.updatePost('ok', postId);  
             Follower__c follower = AlgoInsta.createFollower('a165j000003YV7oAAG', 'ok', '123456789');
             comment__c  cmt = AlgoInsta.postComment('ok', postId, 'a165j000003YV7oAAG');
             savePost__c savePost = AlgoInsta.createSavePost(postId, 'a165j000003YV7oAAG'); 
             Like__c creLike = AlgoInsta.createLike(postId, 'a165j000003YV7oAAG'); 
             InstaNotification__c notification = AlgoInsta.createNotificationHandler('a165j000003YV7oAAG', '', '', 'a165j000003YV7oAAG', false);
             List<Object> imageWrapper = AlgoInsta.getImage(null);             
             Id msgId = AlgoInsta.createMsgHandler('a165j000003YV7oAAG', 'msg', 'a165j000003YV7oAAG');
             String uploadFile = AlgoInsta.uploadFile('base64', 'file', 'a165j000003YV7oAAG');
             //InstaUser__c updatePro = AlgoInsta.updateProfile('', '1234123421', '1231232');
             //InstaUser__c negUserUpdation = AlgoInsta.updatePassword('a165j000003YV7oAAG', '12345');
             
             //System.debug(negUserUpdation);
         Test.stopTest(); 
         System.assertEquals(String.valueOf(userCreateSec),'InstaUser__c:{Name=Utpal, Email__c=1234567890, Password__c=*****}'); 
         System.assertEquals(postId, null); 
         System.assertEquals(String.valueOf(postt),'Post__c:{Id=null, Caption__c=ok}'); 
         System.assertEquals(String.valueOf(follower),'Follower__c:{Name=ok, InstaUser__c=a165j000003YV7oAAG, follow__c=true, Following_UserEmail__c=123456789}'); 
         System.assertEquals(String.valueOf(cmt),'comment__c:{Post__c=null, comments__c=ok, InstaUser__c=a165j000003YV7oAAG}'); 
         System.assertEquals(String.valueOf(savePost),'savePost__c:{InstaUser__c=null, Post__c=a165j000003YV7oAAG}'); 
         System.assertEquals(String.valueOf(creLike),'Like__c:{Post__c=null, InstaUser__c=a165j000003YV7oAAG}'); 
         System.assertEquals(String.valueOf(notification),'InstaNotification__c:{InstaUser__c=a165j000003YV7oAAG, userId__c=a165j000003YV7oAAG, PicUrl__c=, For_follow__c=false, Notification_Body__c=}'); 
         System.assertEquals(String.valueOf(msgId), null); 
         System.assert(uploadFile != null); 

    }    
   
    

}