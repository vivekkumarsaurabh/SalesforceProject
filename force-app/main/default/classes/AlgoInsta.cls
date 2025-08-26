/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 26/02/2024
* @Description : LWC Apex Code of AlgoInstagram;
******************************************************************/
public class AlgoInsta {
    public static String baseUrl = URL.getOrgDomainURL().toExternalForm()+'/'; 
    public static String contentUrl = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=';
    /**************************************************************************************************************************
	* @description : This method is for create user.
	* @param : String user.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static InstaUser__c createUser(String user){
        Map<String, Object> obj =  (Map<String, Object>) JSON.deserializeUntyped(user);
        InstaUser__c createRec = new InstaUser__c();
        createRec.Name = JSON.serialize(obj.get('name')).remove('"');
        createRec.Email__c = JSON.serialize(obj.get('email')).remove('"');
        createRec.Password__c = JSON.serialize(obj.get('pass')).remove('"');
        try{
             insert createRec;
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());  
        } 
        return createRec;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for login.
	* @param : String userMail.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static userInfoWrapper login(String userMail){
        userInfoWrapper createWrap = new userInfoWrapper();
        if(userMail != null){
        for(InstaUser__c iterateRec : [SELECT Id, Password__c, Name FROM InstaUser__c WHERE Email__c =:userMail]){           
            createWrap.Name = iterateRec.Name;
            createWrap.password = iterateRec.Password__c;
            createWrap.Id = iterateRec.Id;
        }}
        return createWrap;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for create post.
	* @param : String userId.
	* @return : Id.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Id createPost(String userId){
        Post__c createPost = new Post__c();
        createPost.InstaUser__c = userId;       
        try{
            insert createPost;            
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());  
        } 
        return createPost.Id;
    }
    
    /**************************************************************************************************************************
	* @description : This method is updatePost.
	* @param : String caption, String postId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Post__c updatePost(String caption, String postId){ 
        Post__c create = new Post__c();
        create.Id = postId;
        create.Caption__c = caption;
        try{
            update create;
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());  
        }  
        return create;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for delete post.
	* @param : String postId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled 
    public static Post__c deletePost(String postId){
        Post__c iterateRec =  [SELECT Id FROM Post__c WHERE Id = :postId];
        try{
             delete iterateRec;
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());  
        } 
        return iterateRec;
    }
    
    /**************************************************************************************************************************
	* @description : This method is get All Image.
	* @param : String objectId.
	* @return : List<ImageWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<ImageWrapper> getImage(String postId){
        if(postId == null || String.isBlank(postId)){
            return NULL;
        }
        List<ContentDocumentLink> conVerList = [SELECT contentDocumentId, ContentDocument.FileType, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :postId];       
        List<ImageWrapper> imageWrapperList = new List<ImageWrapper>();          
        for(ContentDocumentLink iterateConVer : conVerList){ 
            if(iterateConVer.ContentDocument.FileType == 'PNG' || iterateConVer.ContentDocument.FileType == 'JPG' || iterateConVer.ContentDocument.FileType == 'JPEG'){ 
                ImageWrapper createWrapper = new ImageWrapper();
                createWrapper.image = baseUrl + contentUrl + iterateConVer.ContentDocument.LatestPublishedVersionId;   
                createWrapper.link = '#';
                imageWrapperList.add(createWrapper); 
            }
        }
        return imageWrapperList;
    }
    
    /**************************************************************************************************************************
* @description : This method is retrive all post.
* @param : String userId.
* @return : List<PostMapWrapper>.
***************************************************************************************************************************/
    @AuraEnabled
    public static List<PostMapWrapper> retrivePost(String userId, String userEmail){
        
        Map<Id, List<String>> mapOfpost = new Map<Id, List<String>>();
        Map<Id, String> mapOfProfilePic = new Map<Id, String>();
        Map<Id, List<CommentWrapper>> mapOfCommentPost = new Map<Id, List<CommentWrapper>>();
        Map<Id, List<LikeWrapper>> likeMap = new Map<Id, List<LikeWrapper>>();
        Map<Id, Boolean> likePostsMap = new Map<Id, Boolean>();
        Map<Id, Boolean> savePostMap = new Map<Id, Boolean>();
        
        List<PostWrapper> postList = new List<PostWrapper>(); 
        List<PostMapWrapper> createPostList = new List<PostMapWrapper>();  
        
        Set<Id> postIds = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        Set<String> emailList = new Set<String>();
        
        for(Follower__c iterate : [SELECT Following_UserEmail__c FROM Follower__c WHERE InstaUser__c = :userId]){
            emailList.add(iterate.Following_UserEmail__c);
        }
        
        for(Follower__c iterate : [SELECT InstaUser__c FROM Follower__c WHERE Following_UserEmail__c =:userEmail]){
            userIdSet.add(iterate.InstaUser__c);
        }
        
        for(InstaUser__c iterate : [SELECT Id FROM InstaUser__c WHERE Email__c IN : emailList]){
            userIdSet.add(iterate.Id); 
        }       
        for(Post__c iterateRec : [SELECT Id, InstaUser__c FROM Post__c WHERE InstaUser__c IN : userIdSet OR InstaUser__c =: userId]){
            postIds.add(iterateRec.Id);            
        }
        for(Like__c iterate : [SELECT Id, Post__c, InstaUser__r.Name FROM Like__c WHERE Post__c IN : postIds AND InstaUser__c =:userId  AND Post__c != NULL]){
            likePostsMap.put(iterate.Post__c, true);
        }
        for(savePost__c iterateSave : [SELECT Id, Post__c FROM savePost__c WHERE InstaUser__c =:userId]){
            savePostMap.put(iterateSave.Post__c, true);
        }        
        if(postIds.size() != 0){
            for(ContentDocumentLink iterateRec : [SELECT ContentDocument.LatestPublishedVersionId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId  IN :postIds]){
                List<String> urlLinks = new List<String>();            
                if(mapOfpost.containsKey(iterateRec.LinkedEntityId)){
                    urlLinks = mapOfpost.get(iterateRec.LinkedEntityId);
                }
                urlLinks.add(baseUrl + contentUrl + iterateRec.ContentDocument.LatestPublishedVersionId);
                mapOfpost.put(iterateRec.LinkedEntityId, urlLinks);  
            }  
        }        
        if(userIdSet.size() != 0){
            userIdSet.add(userId);
            mapOfProfilePic = AlgoInsta.returnUserProfilePic(userIdSet);            
        }
        for(comment__c iterate : [SELECT Id, Post__c, comments__c, InstaUser__r.Name, InstaUser__c FROM comment__c WHERE Post__c IN : postIds AND comments__c != NULL AND InstaUser__c != NULL AND Post__c != NULL]){
            List<commentWrapper> createCmtList = new List<commentWrapper>();
            if(mapOfCommentPost.containsKey(iterate.Post__c)){
                createCmtList = mapOfCommentPost.get(iterate.Post__c);
            }
            commentWrapper cmt = new commentWrapper();
            cmt.userName = iterate.InstaUser__r.Name;
            cmt.comments = iterate.comments__c;
            cmt.userProfile = mapOfProfilePic.get(iterate.InstaUser__c);
            createCmtList.add(cmt);
            mapOfCommentPost.put(iterate.Post__c, createCmtList);
        }
        for(Like__c iterate : [SELECT Id, Post__c, InstaUser__r.Name FROM Like__c WHERE Post__c IN : postIds AND InstaUser__c != NULL AND Post__c != NULL]){
            List<LikeWrapper> likeWrapperList = new List<LikeWrapper>();
            if(likeMap.containsKey(iterate.Post__c)){
                likeWrapperList = likeMap.get(iterate.Post__c); 
            }
            LikeWrapper lik = new LikeWrapper();
            lik.userName = iterate.InstaUser__r.Name;
            likeWrapperList.add(lik);
            likeMap.put(iterate.Post__c, likeWrapperList);
        }
        for(Post__c iterateRec : [SELECT Id, Caption__c, InstaUser__r.Name, InstaUser__c FROM Post__c WHERE InstaUser__c IN : userIdSet OR InstaUser__c = :userId]){                        
            PostWrapper createWrapper = new PostWrapper();
            String picURL;
            List<ImageWrapper> imgList = new List<ImageWrapper>();
            List<commentWrapper> cmtWrp = new List<commentWrapper>();
             if(mapOfpost.containsKey(iterateRec.Id)){
            for(String iterate : mapOfpost.get(iterateRec.Id)){               
                ImageWrapper imgUrl = new ImageWrapper();
                imgUrl.image = iterate;
                imgUrl.link = '#';
                imgList.add(imgUrl);
                picURL = iterate;                   
            }    
             }
            Integer count;
            if(likeMap.get(iterateRec.Id) == null){
                count = 0;
            }else{
                count = likeMap.get(iterateRec.Id).size();
            }
            createWrapper.Id = iterateRec.Id;
            createWrapper.caption = iterateRec.Caption__c;
            createWrapper.imagesList = imgList; 
            createWrapper.userId = iterateRec.InstaUser__c;
            createWrapper.userName = iterateRec.InstaUser__r.Name;
            createWrapper.profileImg = mapOfProfilePic.get(iterateRec.InstaUser__c);   
            createWrapper.commentsList = mapOfCommentPost.get(iterateRec.Id);
            createWrapper.likeList = likeMap.get(iterateRec.Id);          
            createWrapper.likeCount = count;
            createWrapper.postPicUrl = picURL;
            if(savePostMap.containsKey(iterateRec.Id)){
                createWrapper.savePost = savePostMap.get(iterateRec.Id);   
            }else{
                createWrapper.savePost = false; 
            }
            if(likePostsMap.containsKey(iterateRec.Id)){
                createWrapper.likePost = likePostsMap.get(iterateRec.Id);
            }else{
               createWrapper.likePost = false; 
            }
            PostMapWrapper createPost = new PostMapWrapper();
            createPost.Id = iterateRec.Id;
            createPost.post = createWrapper;
            createPostList.add(createPost);                       
        } 
        return createPostList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is retrive all save posts.
	* @param : String userId.
	* @return : List<UserProfileWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled 
    public static List<UserProfileWrapper> retriveSavePost(String userId){
        Integer count = 0;
        String urlLinks;
        
        Map<Id, String> mapOfpost = new Map<Id, String>();         
        Map<Id, Integer> postCommentMap = new Map<Id, Integer>();
        Map<Id, Integer> likeMap = new Map<Id, Integer>();
        
        Set<Id> postIds = new Set<Id>();
        List<UserProfileWrapper> createPostList = new List<UserProfileWrapper>(); 
       
        for(savePost__c iterateRec : [SELECT Id, Post__c  FROM savePost__c WHERE InstaUser__c = :userId]){
            postIds.add(iterateRec.Post__c);            
        }
        if(!postIds.isEmpty()){
        for(ContentDocumentLink iterateRec : [SELECT ContentDocument.LatestPublishedVersionId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId  IN :postIds]){                     
            urlLinks = baseUrl + contentUrl + String.valueOf(iterateRec.ContentDocument.LatestPublishedVersionId);
            mapOfpost.put(iterateRec.LinkedEntityId, urlLinks);  
        }
        for(Like__c iterate : [SELECT Id, Post__c FROM Like__c WHERE Post__c IN : postIds AND InstaUser__c != NULL AND Post__c != NULL]){            
            count = 0;
            if(likeMap.containsKey(iterate.Post__c)){
                count = likeMap.get(iterate.Post__c); 
            }           
            likeMap.put(iterate.Post__c, count + 1);
        }
        for(comment__c iterate : [SELECT Id, Post__c, comments__c, InstaUser__r.Name, InstaUser__c FROM comment__c WHERE Post__c IN : postIds AND comments__c != NULL AND InstaUser__c != NULL AND Post__c != NULL]){
            count = 0;
            if(postCommentMap.containsKey(iterate.Post__c)){
                count = postCommentMap.get(iterate.Post__c);
            }           
            postCommentMap.put(iterate.Post__c, count + 1);
        }
        }
        for(Post__c iterateRec : [SELECT Id, Caption__c, InstaUser__r.Name, InstaUser__c FROM Post__c WHERE Id IN : postIds]){             
            PostWrapperOther createWrapper = new PostWrapperOther();                     
            createWrapper.Id = iterateRec.Id;
            createWrapper.caption = iterateRec.Caption__c;
            createWrapper.imageUrl = mapOfpost.get(iterateRec.Id);   
            createWrapper.likeCount = likeMap.get(iterateRec.Id);
            createWrapper.cmtCount =  postCommentMap.get(iterateRec.Id);
            UserProfileWrapper createPost = new UserProfileWrapper();
            createPost.postId = iterateRec.Id;
            createPost.post = createWrapper;            
            createPostList.add(createPost);            
        }              
        return createPostList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is retrive user posts.
	* @param : String userId.
	* @return : List<UserProfileWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled 
    public static List<UserProfileWrapper> retriveUserPost(String userId){
        Integer count = 0; 
        String urlLinks;
        
        Map<Id, String> mapOfpost = new Map<Id, String>();          
        Map<Id, Integer> postCommentMap = new Map<Id, Integer>();
        Map<Id, Integer> likeMap = new Map<Id, Integer>();
        
        Set<Id> postIds = new Set<Id>();
        List<UserProfileWrapper> createPostList = new List<UserProfileWrapper>();        
        
        for(Post__c iterateRec : [SELECT Id, InstaUser__c FROM Post__c WHERE InstaUser__c = :userId]){
            postIds.add(iterateRec.Id);            
        }
        if(!postIds.isEmpty()){
        for(ContentDocumentLink iterateRec : [SELECT ContentDocument.LatestPublishedVersionId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId  IN :postIds]){                     
            urlLinks = baseUrl + contentUrl + String.valueOf(iterateRec.ContentDocument.LatestPublishedVersionId);
            mapOfpost.put(iterateRec.LinkedEntityId, urlLinks);  
        } 
        for(Like__c iterate : [SELECT Id, Post__c FROM Like__c WHERE Post__c IN : postIds AND InstaUser__c != NULL AND Post__c != NULL]){            
            count = 0;
            if(likeMap.containsKey(iterate.Post__c)){
                count = likeMap.get(iterate.Post__c); 
            }           
            likeMap.put(iterate.Post__c, count + 1);
        }
        for(comment__c iterate : [SELECT Id, Post__c, comments__c, InstaUser__r.Name, InstaUser__c FROM comment__c WHERE Post__c IN : postIds AND comments__c != NULL AND InstaUser__c != NULL AND Post__c != NULL]){
            count = 0;
            if(postCommentMap.containsKey(iterate.Post__c)){
                count = postCommentMap.get(iterate.Post__c);
            }           
            postCommentMap.put(iterate.Post__c, count + 1);
        }
        }
        
        for(Post__c iterateRec : [SELECT Id, Caption__c, InstaUser__r.Name, InstaUser__c FROM Post__c WHERE InstaUser__c =:userId]){             
            PostWrapperOther createWrapper = new PostWrapperOther();                     
            createWrapper.Id = iterateRec.Id;
            createWrapper.caption = iterateRec.Caption__c;
            createWrapper.imageUrl = mapOfpost.get(iterateRec.Id);   
            createWrapper.likeCount = likeMap.get(iterateRec.Id);
            createWrapper.cmtCount =  postCommentMap.get(iterateRec.Id);
            UserProfileWrapper createPost = new UserProfileWrapper();
            createPost.postId = iterateRec.Id;
            createPost.post = createWrapper;            
            createPostList.add(createPost);            
        }   
        return createPostList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is create follower.
	* @param : String followerId, String name, String email.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Follower__c createFollower(String followerId, String name, String email){
        Follower__c creteFollower = new Follower__c();
        creteFollower.Name = name;
        creteFollower.InstaUser__c = followerId; //user id who have followed
        creteFollower.follow__c = true;
        creteFollower.Following_UserEmail__c = email; //user who have follow by        
        try{
             insert creteFollower;
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());  
        }
        return creteFollower;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for post comments.
	* @param : String comment, String postId, String userId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static comment__c postComment(String comment, String postId, String userId){        
        comment__c createPost = new comment__c();
        createPost.Post__c = postId;
        createPost.comments__c = comment;
        createPost.InstaUser__c = userId;        
        try{
             insert createPost;
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());  
        }
        return createPost;
    }
    
    /**************************************************************************************************************************
	* @description : This method is get All Users.
	* @param : String userId, String email.
	* @return : List<UsersWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled 
    public static List<UsersWrapper> getAllUsers(String userId, String email){        
        Map<Id, String> mapOfProfilePic = new Map<Id, String>();
        
        Set<Id> userSet = new Set<Id>();
        Set<Id> followerId = new Set<Id>();
        List<UsersWrapper> userList = new List<UsersWrapper>();
        
        for(InstaUser__c iterate : [SELECT Id FROM InstaUser__c WHERE Id != :userId]){
            userSet.add(iterate.Id);
        }        
        for(Follower__c iterateFollower : [SELECT InstaUser__c FROM Follower__c WHERE Following_UserEmail__c =:email]){          
            followerId.add(iterateFollower.InstaUser__c);         
        }  
        for(InstaUser__c iterateRec : [SELECT Id, (SELECT InstaUser__c FROM followers__r) FROM  InstaUser__c WHERE Id = : userId]){
            for(Follower__c iterate : iterateRec.followers__r){
                followerId.add(iterate.InstaUser__c);
            }
        }
        mapOfProfilePic = AlgoInsta.returnUserProfilePic(userSet);
        for(InstaUser__c iterate : [SELECT Id, Name, (SELECT ID FROM Posts__r), (SELECT ID FROM followers__r) FROM InstaUser__c WHERE Id != :userId AND Id NOT IN : followerId]){
            UsersWrapper createWrapper = new UsersWrapper();
            createWrapper.Id = iterate.Id;
            createWrapper.Name = iterate.Name;
            createWrapper.profileImg = mapOfProfilePic.get(iterate.Id);
            createWrapper.post = iterate.Posts__r.size();
            createWrapper.follower = iterate.followers__r.size();
            createWrapper.following = 0;
            userList.add(createWrapper);
        }
        return userList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for create save posts.
	* @param : String userId, String postId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static savePost__c createSavePost(String userId, String postId){
        savePost__c savePost = new savePost__c();
        savePost.InstaUser__c = userId;
        savePost.Post__c = postId;        
        try{
             insert savePost;
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now()); 
        }
        return savePost;
    } 
    
    /**************************************************************************************************************************
	* @description : This method is for delete save post.
	* @param : String userId, String postId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<savePost__c> deleteSavePost(String userId, String postId){
        List<savePost__c> savePostList = [SELECT Id, InstaUser__c, Post__c FROM savePost__c WHERE Post__c = :postId AND InstaUser__c = :userId]; 
        try{
             Database.delete(savePostList, false);
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now()); 
        }
        return savePostList;
    }    
    
    /**************************************************************************************************************************
	* @description : This method is for remove save post.
	* @param : String userId, String postId.
	* @return : List<savePost__c>.
	***************************************************************************************************************************/
    @AuraEnabled 
    public static List<savePost__c> removeSavePost(String userId, String postId){   
        return [SELECT Id, InstaUser__c, Post__c FROM savePost__c WHERE Post__c = :postId AND InstaUser__c = :userId];
    }
    
    /**************************************************************************************************************************
	* @description : This method is for retrive likes on that post behalf on user.
	* @param : String userId, String postId.
	* @return : List<Like__c>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<Like__c> removeLikePost(String userId, String postId){
        return [SELECT Id, InstaUser__c, Post__c FROM Like__c WHERE Post__c = :postId AND InstaUser__c = :userId];
    }
    
    /**************************************************************************************************************************
	* @description : This method is get All details of user.
	* @param : String userId, String userEmail.
	* @return : UserDetails.
	***************************************************************************************************************************/
    @AuraEnabled
    public static UserDetails getUserDetails(String userId, String userEmail){
        Map<Id, String> mapOfProfilePic = new Map<Id, String>();
        
        Set<Id> userFollowingId = new Set<Id>();
        Set<String> emailFollowerList = new Set<String>();
        Set<Id> userFollowerId = new Set<Id>();
        
        List<FollowerWrapper> followerList = new List<FollowerWrapper>();
        List<FollowingWrapper> followingList = new List<FollowingWrapper>();
        
        List<Post__c> postList = [SELECT Id, InstaUser__c FROM Post__c WHERE InstaUser__c = :userId];  
        for(Follower__c iterateFollowers : [SELECT InstaUser__c, Following_UserEmail__c FROM Follower__c WHERE InstaUser__c = :userId]){
            emailFollowerList.add(iterateFollowers.Following_UserEmail__c); //followers               
        }       
        for(Follower__c iterateFollowing : [SELECT InstaUser__c FROM Follower__c WHERE Following_UserEmail__c = :userEmail]){
            userFollowingId.add(iterateFollowing.InstaUser__c); //following
        }
        for(InstaUser__c iterateUser : [SELECT Id, Email__c, Name FROM InstaUser__c WHERE Email__c =:emailFollowerList]){
            userFollowerId.add(iterateUser.Id);
        }
        userFollowerId.add(userId);        
        mapOfProfilePic = AlgoInsta.returnUserProfilePic(userFollowerId);        
        for(Follower__c iterateFollowing : [SELECT Id, Name, follow__c, Follow_Back__c, InstaUser__r.Name, Following_UserEmail__c FROM Follower__c WHERE Following_UserEmail__c = :userEmail]){
            FollowingWrapper createWrapper = new FollowingWrapper();
            createWrapper.userId = iterateFollowing.InstaUser__c;
            createWrapper.name = iterateFollowing.InstaUser__r.Name;
            createWrapper.profileImg = mapOfProfilePic.get(iterateFollowing.InstaUser__c);
            followingList.add(createWrapper);
        }
        
        for(InstaUser__c iterateUser : [SELECT Id, Email__c, Name FROM InstaUser__c WHERE Email__c =:emailFollowerList]){
            FollowerWrapper createWrapper = new FollowerWrapper();
            createWrapper.userId = iterateUser.Id;
            createWrapper.name = iterateUser.Name;
            createWrapper.email = iterateUser.Email__c;
            createWrapper.profileImg = mapOfProfilePic.get(iterateUser.Id);
            followerList.add(createWrapper);
        }    
        String username;
        for(InstaUser__c iterateName : [SELECT Name FROM InstaUser__c WHERE Email__c = :userEmail]){
            username = String.valueOf(iterateName.Name);
        }
        UserDetails createFinalWrapper = new UserDetails();
        createFinalWrapper.posts = postList.isEmpty()?0:postList.size();
        createFinalWrapper.name = username;
        createFinalWrapper.profileImg = mapOfProfilePic.get(Id.valueOf(userId));
        createFinalWrapper.following = followingList.size();
        createFinalWrapper.follower = followerList.size();
        createFinalWrapper.followerList = followerList;
        createFinalWrapper.followingList = followingList;
        return createFinalWrapper;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for profile image.
	* @param : String user.
	* @return : String.
	***************************************************************************************************************************/
    @AuraEnabled 
    public static String profileImg(String user){        
        String picUrl = '';
        
        for(ContentDocumentLink iterateRec : [SELECT ContentDocument.LatestPublishedVersionId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :user]){
            picUrl = baseUrl + contentUrl + String.valueOf(iterateRec.ContentDocument.LatestPublishedVersionId);           
        }
        return picUrl;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for create like.
	* @param : String postId, String userId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Like__c createLike(String postId, String userId){
        Like__c createLike = new Like__c();
        createLike.Post__c = postId;
        createLike.InstaUser__c = userId;        
        try{
             insert createLike;
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now()); 
        }
       return createLike; 
    }
    
    /**************************************************************************************************************************
	* @description : This method is retrive all relative post.
	* @param : String userId.
	* @return : ListOfPostIdWrapper.
	***************************************************************************************************************************/
    @AuraEnabled
    public static ListOfPostIdWrapper retriveAllrelativePost(String userId){
        ListOfPostIdWrapper createWrapper = new ListOfPostIdWrapper();
        List<Id> idOfPost = new List<Id>();
        for(Post__c iterateId : [SELECT Id FROM Post__c WHERE InstaUser__c =:userId]){
            idOfPost.add(String.valueOf(iterateId.Id));
        }
        createWrapper.ids = idOfPost;
        return createWrapper;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for create notification.
	* @param : String userId, String body, String picUrl, String userIdOfpost, Boolean forfollow.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static InstaNotification__c createNotificationHandler(String userId, String body, String picUrl, String userIdOfpost, Boolean forfollow){       
        InstaNotification__c createNotification = new InstaNotification__c();
        createNotification.InstaUser__c = userIdOfpost;        
        createNotification.userId__c = userId;
        createNotification.PicUrl__c = picUrl;
        createNotification.For_follow__c = forfollow;
        createNotification.Notification_Body__c = body;        
        try{
             insert createNotification;
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());  
        }
        return createNotification;
    }
    
    /**************************************************************************************************************************
	* @description : This method is retrive all notification.
	* @param : String userId.
	* @return : List<NotificationWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<NotificationWrapper> retriveAllNotification(String userId){
        List<NotificationWrapper> notificationList = new List<NotificationWrapper>(); 
        
        Set<Id> userPic = new Set<Id>();        
        
        Map<Id, String> mapOfProfilePic = new Map<Id, String>();
        Map<Id, String> userNameMap = new Map<Id, String>();
        
        for(InstaNotification__c iterate: [SELECT Id, InstaUser__c, InstaUser__r.Name, PicUrl__c, Notification_Body__c, userId__c FROM InstaNotification__c WHERE InstaUser__c = :userId]){
            userPic.add(iterate.userId__c); 
        }
        mapOfProfilePic = AlgoInsta.returnUserProfilePic(userPic);
        for(InstaUser__c iterateRec :  [SELECT Id, Name FROM InstaUser__c WHERE Id IN : userPic]){
            userNameMap.put(iterateRec.Id, iterateRec.Name);
        }
        for(InstaNotification__c iterateRec: [SELECT Id, InstaUser__c, InstaUser__r.Name, PicUrl__c, Notification_Body__c, userId__c, For_follow__c FROM InstaNotification__c WHERE InstaUser__c = :userId ORDER BY CreatedDate DESC]){
            NotificationWrapper createWrapper = new NotificationWrapper();
            createWrapper.picUrl = iterateRec.PicUrl__c;
            createWrapper.body = iterateRec.Notification_Body__c;
            createWrapper.userPic = mapOfProfilePic.get(iterateRec.userId__c);
            createWrapper.userName = userNameMap.get(iterateRec.userId__c);
            createWrapper.follow = iterateRec.For_follow__c;
            notificationList.add(createWrapper);
        }
        return notificationList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is return msg profile.
	* @param : String userId.
	* @return : List<MsgUserProfileWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<MsgUserProfileWrapper> returnMsgProfile(String userId){        
        Set<Id> userIdSet = new Set<Id>();
        Set<Id> profileId = new Set<Id>();
        
        Map<Id, String> mapOfProfilePic = new Map<Id, String>(); 
        
        List<MsgUserProfileWrapper> wrapperList = new List<MsgUserProfileWrapper>();
        
        for(InstaMsg__c  iterateRec : [SELECT InstaUserReceiver__c, InstaUserSender__c FROM InstaMsg__c WHERE InstaUserSender__c =:userId OR InstaUserReceiver__c = :userId ORDER BY CreatedDate DESC]){
            if(iterateRec.InstaUserReceiver__c == userId){
                userIdSet.add(iterateRec.InstaUserSender__c);  
            }else if(iterateRec.InstaUserSender__c == userId){
                userIdSet.add(iterateRec.InstaUserReceiver__c); 
            }            
        }
        mapOfProfilePic = AlgoInsta.returnUserProfilePic(userIdSet);    
        for(InstaMsg__c  iterateRec : [SELECT Id, msg__c, InstaUserReceiver__c, InstaUserReceiver__r.Name, InstaUserSender__c, InstaUserSender__r.Name FROM InstaMsg__c WHERE InstaUserSender__c IN : userIdSet OR InstaUserReceiver__c IN : userIdSet  ORDER BY CreatedDate DESC]){
            MsgUserProfileWrapper createWrapper = new MsgUserProfileWrapper();
            if(iterateRec.InstaUserReceiver__c == userId){ 
                if(!profileId.contains(iterateRec.InstaUserSender__c)){
                    createWrapper.profileImg = mapOfProfilePic.get(iterateRec.InstaUserSender__c);
                    createWrapper.name = iterateRec.InstaUserSender__r.Name;
                    createWrapper.userId = iterateRec.InstaUserSender__c;
                    createWrapper.msg = iterateRec.msg__c;   
                    profileId.add(iterateRec.InstaUserSender__c);  
                    wrapperList.add(createWrapper);
                }            
            }else if(iterateRec.InstaUserSender__c == userId){
                if(!profileId.contains(iterateRec.InstaUserReceiver__c)){
                    createWrapper.profileImg = mapOfProfilePic.get(iterateRec.InstaUserReceiver__c);
                    createWrapper.name = iterateRec.InstaUserReceiver__r.Name;
                    createWrapper.userId = iterateRec.InstaUserReceiver__c;
                    createWrapper.msg = iterateRec.msg__c;  
                    profileId.add(iterateRec.InstaUserReceiver__c);
                    wrapperList.add(createWrapper);
                }            
            }           
        }       
        return wrapperList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is return user msg.
	* @param : String userId, String otherUserId.
	* @return : MsgUser.
	***************************************************************************************************************************/
    @AuraEnabled 
    public static MsgUser returnUserMsg(String userId, String otherUserId){
        MsgUser createMainWrapper = new MsgUser();
        
        Set<Id> userIdSet = new Set<Id>();
        Set<Id> msgIds = new Set<Id>();
        Set<Id> profileId = new Set<Id>();
        
        List<MsgWrapper> wrapperList = new List<MsgWrapper>();
        
        Map<Id, String> imgMap = new Map<Id, String>();       
        Map<Id, String> mapOfProfilePic = new Map<Id, String>();
        
        for(InstaMsg__c  iterateRec : [SELECT InstaUserReceiver__r.Name FROM InstaMsg__c WHERE InstaUserReceiver__c = :otherUserId]){
            userIdSet.add(iterateRec.InstaUserReceiver__c);    
            createMainWrapper.name = iterateRec.InstaUserReceiver__r.Name;            
        }
        for(InstaMsg__c  iterateRec : [SELECT msg__c, InstaUserReceiver__c, InstaUserSender__c, CreatedDate FROM InstaMsg__c WHERE InstaUserSender__c =:userId OR InstaUserReceiver__c =:userId  OR InstaUserSender__c = :otherUserId OR InstaUserReceiver__c = :otherUserId ORDER BY CreatedDate ASC]){
            msgIds.add(iterateRec.Id);
        }
        if(msgIds.size() != 0){
            for(ContentDocumentLink iterateRec : [SELECT ContentDocument.LatestPublishedVersionId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN : msgIds]){
                String picUrl = '';         
                if(imgMap.containsKey(iterateRec.LinkedEntityId)){
                    picUrl = imgMap.get(iterateRec.LinkedEntityId);
                }
                picUrl = baseUrl + contentUrl + String.valueOf(iterateRec.ContentDocument.LatestPublishedVersionId);
                imgMap.put(iterateRec.LinkedEntityId, picUrl);  
            }            
        }        
        mapOfProfilePic = AlgoInsta.returnUserProfilePic(userIdSet);   
        createMainWrapper.profileImg = mapOfProfilePic.get(otherUserId);
        createMainWrapper.userId = otherUserId;
        for(InstaMsg__c  iterateRec : [SELECT Id, msg__c, InstaUserReceiver__c, InstaUserSender__c, CreatedDate FROM InstaMsg__c WHERE InstaUserSender__c =:userId OR InstaUserReceiver__c =:userId  OR InstaUserSender__c = :otherUserId OR InstaUserReceiver__c = :otherUserId ORDER BY CreatedDate ASC]){           
            List<String> ym = String.valueOf(iterateRec.CreatedDate).split('-');
            List<String> tim = ym[2].split(':');
            List<String> dt = tim[0].split(' ');
            DateTime myDateTime = DateTime.newInstance(Integer.valueOf(ym[0]), Integer.valueOf(ym[1]), Integer.valueOf(dt[0]), Integer.valueOf(dt[1]), Integer.valueOf(tim[1]), Integer.valueOf(tim[2]));           
            String formatted = myDateTime.formatGMT('EEE, MMM d yyyy HH:mm:ss'); 
            List<String> creat = formatted.split(',');
            List<String> original = creat[1].split(' ');
            if(iterateRec.InstaUserReceiver__c == otherUserId && iterateRec.InstaUserSender__c == userId){
                if(imgMap.get(iterateRec.Id) == NULL){
                MsgWrapper createWrapper = new MsgWrapper();
                createWrapper.msg = iterateRec.msg__c;
                createWrapper.receiver = false;
                createWrapper.recordId = userId; 
                createWrapper.img = false;    
                createWrapper.imgUrl = null;
                createWrapper.msgId = iterateRec.Id;    
                createWrapper.msgTime = creat[0]+' '+Integer.valueOf(dt[1])+':'+Integer.valueOf(tim[1]);            
                wrapperList.add(createWrapper);                     
                }else{
                MsgWrapper createWrapper = new MsgWrapper();
                createWrapper.msg = iterateRec.msg__c;
                createWrapper.receiver = false;
                createWrapper.recordId = userId;
                createWrapper.img = true;   
                createWrapper.msgId = iterateRec.Id; 
                createWrapper.imgUrl = imgMap.get(iterateRec.Id);   
                createWrapper.msgTime = creat[0]+' '+Integer.valueOf(dt[1])+':'+Integer.valueOf(tim[1]);            
                wrapperList.add(createWrapper);  
                }
                
            }else if(iterateRec.InstaUserReceiver__c == userId && iterateRec.InstaUserSender__c == otherUserId){
                if(imgMap.get(iterateRec.Id) == NULL){
                MsgWrapper createWrapper = new MsgWrapper();
                createWrapper.msg = iterateRec.msg__c;
                createWrapper.receiver = true;
                createWrapper.recordId = userId; 
                createWrapper.img = false;    
                createWrapper.imgUrl = null;
                createWrapper.msgId = iterateRec.Id; 
                createWrapper.msgTime = creat[0]+' '+Integer.valueOf(dt[1])+':'+Integer.valueOf(tim[1]);            
                wrapperList.add(createWrapper);                     
                }else{
                MsgWrapper createWrapper = new MsgWrapper();
                createWrapper.msg = iterateRec.msg__c;
                createWrapper.receiver = true;
                createWrapper.recordId = userId;
                createWrapper.img = true;
                createWrapper.msgId = iterateRec.Id; 
                createWrapper.imgUrl = imgMap.get(iterateRec.Id);   
                createWrapper.msgTime = creat[0]+' '+Integer.valueOf(dt[1])+':'+Integer.valueOf(tim[1]);            
                wrapperList.add(createWrapper);  
                }
            }           
        }        
        createMainWrapper.msgList = wrapperList;
        return createMainWrapper;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for create msg Handler.
	* @param : String senderId, String msg, String receiverId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Id createMsgHandler(String senderId, String msg, String receiverId){
        InstaMsg__c createRec = new InstaMsg__c();
        createRec.InstaUserSender__c = senderId;
        createRec.InstaUserReceiver__c = receiverId;
        createRec.msg__c = msg;       
        try{
              insert createRec;
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now()); 
        }
        return createRec.Id;
    }
    
       
    /**************************************************************************************************************************
	* @description : This method is for return user profile pic.
	* @param : Set<Id> userId.
	* @return : Map<Id, String>.
	***************************************************************************************************************************/    
    public static Map<Id, String> returnUserProfilePic(Set<Id> userId){
        Map<Id, String> mapOfProfilePic = new Map<Id, String>();        
        
        if(userId.size() != 0){
            for(ContentDocumentLink iterateRec : [SELECT ContentDocument.LatestPublishedVersionId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN : userId]){
                String picUrl = '';         
                if(mapOfProfilePic.containsKey(iterateRec.LinkedEntityId)){
                    picUrl = mapOfProfilePic.get(iterateRec.LinkedEntityId);
                }
                picUrl = baseUrl + contentUrl + String.valueOf(iterateRec.ContentDocument.LatestPublishedVersionId);
                mapOfProfilePic.put(iterateRec.LinkedEntityId, picUrl);  
            }            
        }
        return mapOfProfilePic;
    }  
    
    /**************************************************************************************************************************
	* @description : This method is for remove likes.
	* @param : String postId, String userId.
	* @return :N/A.
	***************************************************************************************************************************/
    @AuraEnabled 
    public static List<Like__c> removeLike(String postId, String userId){
        List<Like__c>  likeLs = [SELECT Id FROM Like__c WHERE Post__c = : postId AND InstaUser__c = : userId];        
        try{
             Database.delete(likeLs, false);
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());  
        }
        return likeLs;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for search users.
	* @param : String searchKey.
	* @return : List<searchUserWrapper>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<searchUserWrapper> searchUsers(String searchKey){        
        List<searchUserWrapper> searchUserlist = new List<searchUserWrapper>();
        Map<Id, String> mapOfProfilePic = new Map<Id, String>();
        Set<Id> userId = new Set<Id>();        
        if(searchKey == null || String.isBlank(searchKey)){
            return NULL;
        }
        for(InstaUser__c iterate: [SELECT Id, Email__c, Name FROM InstaUser__c WHERE Name LIKE :searchKey ]){
            userId.add(iterate.Id);
        }
        mapOfProfilePic = AlgoInsta.returnUserProfilePic(userId);   
        String searchVal = '%'+searchKey+'%';
        for(InstaUser__c iterateRec : [SELECT Id, Email__c, Name FROM InstaUser__c WHERE Name LIKE :searchVal]){
            searchUserWrapper createWrapper = new searchUserWrapper();
            createWrapper.Id = iterateRec.Id;
            createWrapper.userEmail = iterateRec.Email__c;
            createWrapper.profilePic = mapOfProfilePic.get(iterateRec.Id);
            createWrapper.name = iterateRec.Name;
            searchUserlist.add(createWrapper);
        }   
        return searchUserlist;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for delete msg.
	* @param : String msgId.
	* @return : List<InstaMsg__c>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<InstaMsg__c> deleteMsg(String msgId){
      List<InstaMsg__c> instaMsg = [SELECT ID FROM InstaMsg__c WHERE ID = :msgId];      
      try{
          Database.delete(instaMsg, false);
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage()); 
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now()); 
        }   
        return instaMsg;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for return reels.
	* @param : String userId, String email.
	* @return : List<InstaReel__c>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<InstaReel__c> returnReels(String userId, String email){
        Set<Id> userSet = new Set<Id>();
          
        for(Follower__c iterateFollower : [SELECT InstaUser__c FROM Follower__c WHERE Following_UserEmail__c =:email]){          
            userSet.add(iterateFollower.InstaUser__c);         
        }  
        for(InstaUser__c iterateRec : [SELECT Id, (SELECT InstaUser__c FROM followers__r) FROM  InstaUser__c WHERE Id = : userId]){
            for(Follower__c iterate : iterateRec.followers__r){
                userSet.add(iterate.InstaUser__c);
            }
        }
        return [SELECT Id, videoLink__c FROM InstaReel__c WHERE InstaUser__c =:userId OR InstaUser__c IN : userSet];
    }
    
    /**************************************************************************************************************************
	* @description : This method is for send post.
	* @param : String postId, String userId, String otherUserId.
	* @return : ContentDocumentLink.
	***************************************************************************************************************************/
    @AuraEnabled
    public static ContentDocumentLink sendPost(String postId, String userId, String otherUserId){
      Id msgId = AlgoInsta.createMsgHandler(userId, null, otherUserId);
      ContentDocumentLink  cont = [SELECT LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :postId LIMIT 1];
      ContentDocumentLink createCDL = new ContentDocumentLink();
      createCDL.LinkedEntityId = msgId;
      createCDL.ContentDocumentId = cont.ContentDocumentId;      
        try{
             insert createCDL;
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage());             
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());         
        }
        return createCDL;
    }    
    
    /**************************************************************************************************************************
	* @description : This method is trigger for platform event.
	* @param : List<InstaMsg__c> msgList.
	* @return : N/A.
	***************************************************************************************************************************/
    public static void insertMsgTriggerHandler(List<InstaMsg__c> msgList){
        List<Msg_Inserted__e> events = new List<Msg_Inserted__e>();
               
        Set<Id> recIds = new Set<Id>();
        
        Map<Id, String> imgMap = new Map<Id, String>(); 
        
        if(recIds.size() != 0){
            for(ContentDocumentLink iterateRec : [SELECT ContentDocument.LatestPublishedVersionId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN : recIds]){
                String picUrl = '';         
                if(imgMap.containsKey(iterateRec.LinkedEntityId)){
                    picUrl = imgMap.get(iterateRec.LinkedEntityId);
                }
                picUrl = baseUrl + contentUrl + String.valueOf(iterateRec.ContentDocument.LatestPublishedVersionId);
                imgMap.put(iterateRec.LinkedEntityId, picUrl);  
            }            
        }
        for (InstaMsg__c iterateRec : msgList) {
            List<String> ym = String.valueOf(iterateRec.CreatedDate).split('-');
            List<String> tim = ym[2].split(':');
            List<String> dt = tim[0].split(' ');
            DateTime myDateTime = DateTime.newInstance(Integer.valueOf(ym[0]), Integer.valueOf(ym[1]), Integer.valueOf(dt[0]), Integer.valueOf(dt[1]), Integer.valueOf(tim[1]), Integer.valueOf(tim[2]));           
            String formatted = myDateTime.formatGMT('EEE, MMM d yyyy HH:mm:ss'); 
            List<String> creat = formatted.split(',');
            List<String> original = creat[1].split(' ');
            Msg_Inserted__e event = new Msg_Inserted__e();
            event.RecordId__c = iterateRec.Id;  
            event.msg__c = iterateRec.msg__c;
            event.senderId__c = iterateRec.InstaUserSender__c;
            event.picUrl__c = imgMap.get(iterateRec.Id);
            event.CreatedDate__c = creat[0]+' '+Integer.valueOf(dt[1])+':'+Integer.valueOf(tim[1]);
            events.add(event);
        }
        if (!events.isEmpty()) {
            EventBus.publish(events);
        }
     }
    
    /**************************************************************************************************************************
	* @description : This method is for delete contentDocumentLink.
	* @param : String userId.
	* @return : ContentDocumentLink.
	***************************************************************************************************************************/
    @AuraEnabled
    public static ContentDocumentLink deleteProfilePic(String userId){
       ContentDocumentLink conDoc = [SELECT ID FROM ContentDocumentLink WHERE LinkedEntityId =:userId];
        Database.delete(conDoc, false);
        return conDoc;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for upload profile.
	* @param : String userId, String name, String password.
	* @return : InstaUser__c.
	***************************************************************************************************************************/
    @AuraEnabled
    public static InstaUser__c updateProfile(String userId, String name, String password){
       InstaUser__c updatePro = new InstaUser__c();
       updatePro.Id = userId;
       updatePro.Name = name;
       updatePro.Password__c = password;
        try{
            update updatePro;           
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage());             
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());
        }
        return updatePro;
    }
    
   /**************************************************************************************************************************
	* @description : This method is for verify Email.
	* @param : String email.
	* @return : List<InstaUser__c>.
	***************************************************************************************************************************/ 
    @AuraEnabled
    public static List<InstaUser__c> verifyEmail(String email){
        return [SELECT Email__c, Id FROM InstaUser__c WHERE Email__c LIKE :email];
    }
    
    /**************************************************************************************************************************
	* @description : This method is for update Password.
	* @param : String email, String password.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static InstaUser__c updatePassword(String email, String password){
       InstaUser__c user = [SELECT Id FROM InstaUser__c WHERE Email__c = : email LIMIT 1];
       InstaUser__c updateUserPass = new InstaUser__c();
       updateUserPass.Id = user.Id;
       updateUserPass.Password__c = password;
       try{
            update updateUserPass;           
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage());             
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());
        }
        return updateUserPass;
       
    }
    
    /**************************************************************************************************************************
	* @description : This method is send an email.
	* @param : String userEmail, String otp.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static void sendEmail(String userEmail, String otp) {
        String email = userEmail;  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{email});
        mail.setSubject('Otp Verification of change Paaword');             
        String body = '<h1>Your Otp is '+otp+'</h1>';
        mail.setHtmlBody(body);
        Messaging.sendEmail(new List<Messaging.Email> { mail });
    }
    
    /**************************************************************************************************************************
	* @description : This method is for upload file.
	* @param : String base64, String filename, String recordId.
	* @return : String.
	***************************************************************************************************************************/
    @AuraEnabled    
    public static String uploadFile(String base64, String filename, String recordId) {
        ContentVersion cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
        if (cv == null || cdl == null) { return null; }
        return cdl.Id;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for create Error log.
	* @param : String errMsg, Datetime dt.
	* @return : Error_Log__c.
	***************************************************************************************************************************/
    public static Error_Log__c createErrorLog(String errMsg, Datetime dt){
         Error_Log__c createError = new Error_Log__c();
         createError.Error_Msg__c = errMsg;
         createError.Timestamp__c = dt;
         insert createError;
         return createError;
    }
    
    @AuraEnabled
    public static List<Follower__c> removeFollower(String removeEmailFollower, String userId){
        List<Follower__c> follower = [SELECT InstaUser__c FROM Follower__c WHERE Following_UserEmail__c =:removeEmailFollower AND InstaUser__c = : userId];
        try{
            delete follower;
        }catch(DMLException e){
            System.debug('The following exception has occurred: ==>'+e.getMessage());             
            Error_Log__c createError =  AlgoInsta.createErrorLog(e.getMessage(), System.now());
        }     
       return follower;
    }
    /**************************************************************************************************************************
	* @description : This method is insert content version.
	* @param : String base64, String filename.
	* @return : ContentVersion.
	***************************************************************************************************************************/
    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
            insert cv;
            return cv;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
    /**************************************************************************************************************************
	* @description : This method is for create ContentDocumentLink .
	* @param : String contentVersionId, String recordId.
	* @return : ContentDocumentLink.
	***************************************************************************************************************************/
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
    public class MsgUser{
        @AuraEnabled public String userId;
        @AuraEnabled public String profileImg;
        @AuraEnabled public String name;
        @AuraEnabled public List<MsgWrapper> msgList;        
    }
    
    public class MsgWrapper{
        @AuraEnabled public String msg;
        @AuraEnabled public String msgTime;
        @AuraEnabled public String imgUrl;
        @AuraEnabled public Boolean img;
        @AuraEnabled public Boolean receiver;
        @AuraEnabled public String recordId;
        @AuraEnabled public String msgId;
    }
    
    public class MsgUserProfileWrapper{
        @AuraEnabled public String userId;
        @AuraEnabled public String profileImg;
        @AuraEnabled public String name;
        @AuraEnabled public String msg;
    }
    
    public class PostMapWrapper{
        @AuraEnabled public String Id;
        @AuraEnabled public PostWrapper post;       
    } 
    
    public class searchUserWrapper{
        @AuraEnabled public String Id;
        @AuraEnabled public String userEmail;
        @AuraEnabled public String profilePic;
        @AuraEnabled public String name;
    }
    
    public class NotificationWrapper{
        @AuraEnabled public String userName;
        @AuraEnabled public String picUrl;
        @AuraEnabled public String body;
        @AuraEnabled public String userPic;
        @AuraEnabled public boolean follow;
    }
    
    public class ListOfPostIdWrapper{
        @AuraEnabled public List<String> ids;
    }
    
    public class PostWrapper{
        @AuraEnabled public String Id;
        @AuraEnabled public String caption;
        @AuraEnabled public String userId;
        @AuraEnabled public String userName;
        @AuraEnabled public String profileImg;
        @AuraEnabled public Integer likeCount;
        @AuraEnabled public String postPicUrl;
        @AuraEnabled public Boolean savePost;
        @AuraEnabled public Boolean likePost;
        @AuraEnabled public List<ImageWrapper> imagesList;
        @AuraEnabled public List<CommentWrapper> commentsList;
        @AuraEnabled public List<LikeWrapper> likeList;
    }
    
    public class PostWrapperOther{
        @AuraEnabled public String Id;
        @AuraEnabled public String caption;
        @AuraEnabled public Integer likeCount;
        @AuraEnabled public Integer cmtCount;
        @AuraEnabled public String imageUrl; 
    }
    
    public class UserDetails{
        @AuraEnabled public String profileImg;
        @AuraEnabled public String name;
        @AuraEnabled public Integer follower;
        @AuraEnabled public Integer following;
        @AuraEnabled public Integer posts;
        @AuraEnabled public List<FollowerWrapper> followerList;
        @AuraEnabled public List<FollowingWrapper> followingList;        
    }
    
    public class FollowerWrapper{
        @AuraEnabled public Id userId;
        @AuraEnabled public String name;
        @AuraEnabled public String email;
        @AuraEnabled public String profileImg;        
    }
    
    public class FollowingWrapper{
        @AuraEnabled public Id userId;
        @AuraEnabled public String name;
        @AuraEnabled public String profileImg; 
    }
    
    public class LikeWrapper{
        @AuraEnabled public String userName;
    }
    
    public class CommentWrapper{
        @AuraEnabled public String userProfile;
        @AuraEnabled public String userName;
        @AuraEnabled public String comments;
    }
    
    public class ImageWrapper{
        @AuraEnabled public String image;
        @AuraEnabled public String link;
    }
    
    public class userInfoWrapper{
        @AuraEnabled public String Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String password;
    }  
    
    public class UsersWrapper{
        @AuraEnabled public String Id;
        @AuraEnabled public String profileImg;
        @AuraEnabled public String Name;
        @AuraEnabled public Integer post;
        @AuraEnabled public Integer follower;
        @AuraEnabled public Integer following;        
    }
    
    public class UserProfileWrapper{
        @AuraEnabled public String postId;
        @AuraEnabled public PostWrapperOther post;       
    }
    
    
}