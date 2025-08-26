import { LightningElement, api, track } from 'lwc';
import { subscribe} from 'lightning/empApi';
import createUser from '@salesforce/apex/AlgoInsta.createUser';
import login from '@salesforce/apex/AlgoInsta.login';
import createPost from '@salesforce/apex/AlgoInsta.createPost';
import getImage from '@salesforce/apex/AlgoInsta.getImage';
import updatePost from '@salesforce/apex/AlgoInsta.updatePost';
import deletePost from '@salesforce/apex/AlgoInsta.deletePost';
import retrivePost from '@salesforce/apex/AlgoInsta.retrivePost';
import postComment from '@salesforce/apex/AlgoInsta.postComment';
import createLike from '@salesforce/apex/AlgoInsta.createLike';
import removeLike from '@salesforce/apex/AlgoInsta.removeLike';
import getAllUsers from '@salesforce/apex/AlgoInsta.getAllUsers';
import profileImg from '@salesforce/apex/AlgoInsta.profileImg';
import createFollower from '@salesforce/apex/AlgoInsta.createFollower';
import retriveUserPost from '@salesforce/apex/AlgoInsta.retriveUserPost';
import getUserDetails from '@salesforce/apex/AlgoInsta.getUserDetails';
import retriveAllrelativePost from '@salesforce/apex/AlgoInsta.retriveAllrelativePost';
import retriveAllNotification from '@salesforce/apex/AlgoInsta.retriveAllNotification';
import createNotificationHandler from '@salesforce/apex/AlgoInsta.createNotificationHandler';
import createSavePost from '@salesforce/apex/AlgoInsta.createSavePost';
import removeSavePost from '@salesforce/apex/AlgoInsta.removeSavePost';
import retriveSavePost from '@salesforce/apex/AlgoInsta.retriveSavePost';
import deleteSavePost from '@salesforce/apex/AlgoInsta.deleteSavePost';
import returnMsgProfile from '@salesforce/apex/AlgoInsta.returnMsgProfile';
import searchUsers from '@salesforce/apex/AlgoInsta.searchUsers';
import returnUserMsg from '@salesforce/apex/AlgoInsta.returnUserMsg';
import createMsgHandler from '@salesforce/apex/AlgoInsta.createMsgHandler';
import uploadFile from '@salesforce/apex/AlgoInsta.uploadFile';
import sendPost from '@salesforce/apex/AlgoInsta.sendPost';
import deleteMsg from '@salesforce/apex/AlgoInsta.deleteMsg';
import deleteProfilePic from '@salesforce/apex/AlgoInsta.deleteProfilePic';
import updateProfile from '@salesforce/apex/AlgoInsta.updateProfile';
import removeLikePost from '@salesforce/apex/AlgoInsta.removeLikePost';
import returnReels from '@salesforce/apex/AlgoInsta.returnReels';
import removeFollower from '@salesforce/apex/AlgoInsta.removeFollower';
import verifyEmail from '@salesforce/apex/AlgoInsta.verifyEmail';
import updatePassword from '@salesforce/apex/AlgoInsta.updatePassword';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendEmail from '@salesforce/apex/AlgoInsta.sendEmail';

export default class AlgoInsta extends LightningElement {
    instaLogo = false;
    isSearch = false;
    isSwitchUser = false;
    isLogin = true;
    isHome = true;
    isSignUp = false;
    isHomePage = false;
    isModal = false;
    isDiscard = false;
    isDrop = true;
    isQuote = false;
    isLike = false;
    isComment = false;
    isPopOver = false;
    isMsg = false;
    isUserMsg = false;
    isDeleteMsg = false;
    isPostProfile = false;
    isReelProfile = false;
    isSaveProfile = false; 
    isNotification = false;
    isFollowerDetailsModal = false;
    isFollowingDetailsModal = false;
    isEditProfile = false;
    isProfilePersonal = false;
    isMsgUser = false;
    isMessage = false;
    isOnChat = true;
    isOnSend = true;
    isChat = false;
    isOption = false;
    isReel = false;
    isChangePassword = false;
    isMatchPassword;
    isCorrectPassword;
    isOTP = false;
    isForget = false;
    isRunTime = true;
    isbtnVerification = false;


    cmt;
    recordId; 
    userMail;
    userPic;
    userPass;
    correctPass;
    userId;
    @track UserName;
    newName;
    newPass;
    caption;
    userIdPostcmt;
    picUrlPostcmt;
    searchValue;
    msgData;
    currUserMsg;
    obj;//msgobj
    receiverUserId;
    msgId;
    msid; //delte msg id
    base64;
    sendPostId;
    otherUserIDs;
    videoUrl;
    otp;
    otpChange;
    forgetEmail;
    newPassChange;
    userIdChangePass;
    timer = 20;
    timeSet;

    
    allUser = [];
    reels = [];
    userProfileMsg = [];
    searchValues = [];
    posts = [];
    singlePost;
    slides = [];
    userPosts = [];
    postIDs = [];
    userDetailsData = [];
    personalUserData = [];
    notification = [];
    userSavePosts = [];
    @track allMsg = [];
    fileRecord = [];
    userDetails = {};

    subscription = {};
    @api channelName = '/event/Msg_Inserted__e';

    //constructor
    constructor(){
        super();
        const style = document.createElement('style');
        style.innerText = `.slds-carousel__content{
            padding-right:3%;
        }
        .slds-carousel__content .content-container {
            display: none;
        } .slds-carousel__image img{
            height: 350px;
        
        } 
        .slds-modal__container .slds-modal__content .slds-grid .slds-col .slds-carousel__content .content-container{
            display: none;
        }
        .content-container {
            display: none;
        }
        .slds-dropdown-trigger slds-button_icon:nth-child(2){
            display:none;
        }
        .slds-textarea{
            border:none;
             height:35px;
              resize: none;
        }`;
        document.querySelector('head').appendChild(style);
    }

    //connencted call back
    connectedCallback() {    
        this.handleSubscribe();
        // createVideo().then(res =>{
        //     this.videoUrl = res;
        //     console.log('data==>'+this.videoUrl);
        // })
    }
    

    //check input validation of appointment
    isInputValid() {
        let isValid = true;
        let inputNameFields = this.template.querySelectorAll('.input');
        inputNameFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;                
            }
            this.userDetails[inputField.name] = inputField.value; 
        });
        return isValid;
    }    
    
    //user email handler  
    userEmail(event){
        this.userMail =  event.target.value; 
        login({userMail : this.userMail}).then(res =>{
            this.userId = res.Id;
            this.correctPass = res.password;
            this.UserName = res.Name;
        })
    }

    //login handler
    loginHandle(){
        this.userPass = this.template.querySelector('.userPass').value;    
          if(this.userPass == this.correctPass){
            this.postsRefresh(); 
            this.retriveAllPostHandler();
            this.returnProfile();           
            this.getAllUser();                        
            this.isLogin = false;
             this.isSignUp = false;
             this.isSwitchUser = false;
             this.isHomePage = true;
             this.showToast('Login Sucessfully', 'User login Sucessfully', 'success');
          }else{            
             this.isSignUp = false;
             this.isHomePage = false;
             this.isLogin = true;
            this.showToast('Incorrect Password','Please Enter correct Password','error');
        }
    } 
    
    //retrive all post handler
    retriveAllPostHandler(){
        retriveAllrelativePost({userId : this.userId}).then(res =>{
              this.postIDs = res.ids;
        })
    }
    
    //retrive notification handler
    retriveNotifications(){
        retriveAllNotification({userId : this.userId}).then(res => {
            this.notification = res;
        })
    }
     
    //home handler
    homeHandler(){
        this.template.querySelectorAll('.menuName').forEach(ele =>{
            ele.style.display = 'block';
    })
        this.isProfilePersonal = false;
        this.instaLogo = false;
        this.isSearch = false;
        this.isUserMsg = false;
        this.isNotification = false;
        this.isProfile = false;
        this.isMessage = false;
        this.isReel = false;
        this.isMsg = false;
        this.isHome = true;
        
    }
    
    //post profile handler
    postProfileHandler(){
        this.template.querySelector('.Saved').style.color = '';
        this.template.querySelector('.Saved').style.borderTop = '';
        this.template.querySelector('.iconSaved').classList.remove('colorBlack');
        this.template.querySelector('.Reel').style.color = '';
        this.template.querySelector('.Reel').style.borderTop = '';
        this.template.querySelector('.iconReel').classList.remove('colorBlack');
        this.template.querySelector('.Post').style.color = '#000000';
        this.template.querySelector('.Post').style.borderTop = '1px solid #000000';
        this.template.querySelector('.iconPost').classList.add('colorBlack');
        this.isReelProfile = false;
        this.isSaveProfile = false;
        this.isPostProfile = true;
    }
    
    //reel profile handler
    reelProfileHandler(){
        this.template.querySelector('.Saved').style.color = '';
        this.template.querySelector('.Saved').style.borderTop = '';
        this.template.querySelector('.iconSaved').classList.remove('colorBlack');       
        this.template.querySelector('.Post').style.color = '';
        this.template.querySelector('.Post').style.borderTop = '';
        this.template.querySelector('.iconPost').classList.remove('colorBlack');   
        this.template.querySelector('.Reel').style.color = '#000000';
        this.template.querySelector('.Reel').style.borderTop = '1px solid #000000';
        this.template.querySelector('.iconReel').classList.add('colorBlack');         
        this.isSaveProfile = false;
        this.isPostProfile = false;
        this.isReelProfile = true;
    }

    //save profile handler
    saveProfileHandler(){     
        this.template.querySelector('.Post').style.color = '';
        this.template.querySelector('.Post').style.borderTop = '';
        this.template.querySelector('.iconPost').classList.remove('colorBlack');   
        this.template.querySelector('.Reel').style.color = '';
        this.template.querySelector('.Reel').style.borderTop = '';
        this.template.querySelector('.iconReel').classList.remove('colorBlack');         
        this.template.querySelector('.Saved').style.color = '#000000';
        this.template.querySelector('.Saved').style.borderTop = '1px solid #000000';
        this.template.querySelector('.iconSaved').classList.add('colorBlack');    
        retriveSavePost({userId : this.userId}).then(res => {
            this.userSavePosts = res;
        })     
        this.isPostProfile = false;
        this.isReelProfile = false;
        this.isSaveProfile = true;
    }

    //profile handler
    profilehandler(){    
        retriveUserPost({userId : this.userId}).then(res =>{     
        this.template.querySelectorAll('.menuName').forEach(ele =>{
                ele.style.display = 'block';
        })         
        this.getUserDetailHandler();
        this.isHome = false;
        this.isMessage = false;
        this.isMsg = false;
        this.instaLogo = false;
        this.isSearch = false;
        this.isUserMsg = false;
        this.isReel = false;
        this.isProfilePersonal = false;
        this.isPostProfile = true;
        this.userPosts = res;            
        this.isProfile = true;
        })        
    }

    //post refresh hanlder
    postsRefresh(){
        retrivePost({userId : this.userId, userEmail : this.userMail}).then(res=>{
            this.posts = res;
        })
    }

    //get user detail handler
    getUserDetailHandler(){
        getUserDetails({userId : this.userId, userEmail : this.userMail}).then(res =>{
            this.userDetailsData = res;
        })
    }   
    
    //follower list handler
    folowerListHandler(){
      this.isFollowerDetailsModal = true; 
    }
    
    //close follow modal handler
    isFolloweClosedHandler(){
        this.isFollowerDetailsModal = false;
    }

     //following list handler
    followingListHandler(){
        this.isFollowingDetailsModal = true;
    }
    
    //is following modal handler
    isFollowingDetailsClosedHandler(){
        this.isFollowingDetailsModal = false;
    }

    //signup Handler create user
    signUpHandle(){      
        if(this.isInputValid()){
            createUser({user : JSON.stringify(this.userDetails)}).then(res =>{
                this.template.querySelectorAll('.input').value = '';
                this.showToast('User Created', 'User has been created', 'success');            
            })
        }
    }

    //sign up handler
    signUpHandler(){
    this.isLogin = false; 
    this.isSignUp = true;
    }

    //login page hanlder
    loginPageHandler(){
    this.isSignUp = false;
     this.isLogin = true;
    }
    
    //create post handler
    createPostModal(){
        createPost({userId : this.userId}).then(res =>{
          this.recordId = res;
        })
        this.isQuote = false;
        this.isDrop = true;
        this.isModal = true;      
    }

    //is close modal
    isclosdModal(){
        this.isModal = false;
        this.isDiscard = true;       
    }

    //discard handler
    discardHandler(){
        deletePost({postId : this.recordId}).then(res =>{
            this.isDiscard = false;
            this.isModal = false;
        })
    }

    //discard cancel modal
    discardCancelModal(){
        this.isDiscard = false;
        this.isModal = true;
    }
    
    //handler upload finish
    handleUploadFinished(){
        getImage({postId : this.recordId}).then(res =>{
            this.slides = res;
        })       
     this.isDrop = false;
     this.isQuote = true;
    }

    //save text area text handler post caption
    saveTextAreaHandler(){
       this.caption = this.template.querySelector('.textA').value;   
    }
    
    //share handler
    shareHandler(){
        updatePost({caption: this.caption, postId : this.recordId}).then(res =>{
            this.isModal = false;
            this.postsRefresh();
            this.showToast('Post Uploaded', 'Post is Uploaded', 'success');

        })
    }

    //like handler
    likeHandler(event){
        let userIdPost = event.currentTarget.dataset.msg;
        let idPost  = event.currentTarget.dataset.id;
        let picUrlPost = event.currentTarget.dataset.picurl;
        removeLikePost({userId: this.userId, postId : idPost}).then(res =>{           
            if(res.length == 0){
            createLike({postId : idPost, userId: this.userId}).then(res =>{
                if(!this.postIDs.includes(idPost)){                  
                    createNotificationHandler({	userIdOfpost : userIdPost, userId : this.userId, body : 'is like your post', picUrl : picUrlPost, forfollow : false}).then( res=>{
                       
                    })
                }
                this.postsRefresh();
            }) 
        }else{
            removeLike({postId : idPost, userId: this.userId}).then(res =>{
                this.postsRefresh();
            })
            } 
        })
    }
    
    //return profile image handler 
    returnProfile(){
        profileImg({user: this.userId}).then(res =>{            
            this.userPic = res;
        })
    }
    
    //get all user handler
    getAllUser(){
        getAllUsers({userId : this.userId, email: this.userMail}).then(res =>{            
           this.allUser = res;
        })
    }
    
    //comment handler
    commentHandler(event){
    this.singlePost = null;
    this.picUrlPostcmt = event.currentTarget.dataset.urlpic;
    this.userIdPostcmt = event.currentTarget.dataset.useridd;
    let postId = event.currentTarget.dataset.id;  
    this.singlePost = this.posts.filter(x => x.Id === postId);    
    this.isComment = true;    
    // this.posts.forEach(item =>{   
    //     // console.log('id==>'+JSON.stringify(item.Id));
    //     // if(JSON.stringify(item.Id) == JSON.stringify(postId)){
    //     //     console.log('ek bar');
    //     //    console.log('data==>'+JSON.stringify(item.post));
    //     // }      
    // })

    //  console.log('data==>'+JSON.stringify(this.posts));
    }
    
    //save post handler
    cmtPost(event){
        this.cmt = event.target.value;

    }

    postsOpenHandler(event){
        let postId = event.currentTarget.dataset.postsid;
        console.log('data===>'+postId);
        this.singlePost = this.posts.filter(x => x.Id === postId);    
        this.isComment = true; 

    }
    
    //comment post handler
    postHandlerCmt(event){
      let postid = event.currentTarget.dataset.id;     
       postComment({comment :this.cmt, userId :this.userId, postId : postid}).then(res =>{
        if(!this.postIDs.includes(postid)){                  
            createNotificationHandler({	userIdOfpost :  this.userIdPostcmt, userId : this.userId, body : 'is commented on your post', picUrl : this.picUrlPostcmt, forfollow : false}).then( res=>{               
            })
        }
        this.template.querySelector('.cmtField').value = '';
        this.postsRefresh();
       })
    }
    
    // close comment handler
    closdComment(){
        this.isComment = false;
    }

    //more option handler
    moreOptionHandler(){
        this.isPopOver = true;
    }
    
    //close pop over modal handler
    closePopOverHandler(){
           this.isPopOver = false;  
    }
    
    //logout handler
    logoutHandler(){
           this.isMessage = false;
           this.isMsg = false;
           this.isReel = false;
           this.isProfile = false;
           this.isHomePage = false;
           this.isPopOver = false;
           this.isUserMsg = false;
           this.isLogin = true;
    }

    //follower handler
    followHandler(event){
        let followUserId = event.currentTarget.dataset.id;
        let profileimg = event.currentTarget.dataset.profileimg
        createFollower({followerId: followUserId, name : this.UserName, email : this.userMail }).then(res =>{
        createNotificationHandler({	userIdOfpost : followUserId, userId : this.userId, body : 'is started following you', picUrl : profileimg, forfollow : true});
            this.getAllUser();
            this.postsRefresh();
            this.showToast('follow Sucessfully', 'you have follow someone', 'success');
            
        })
    }

    //notification handler
    notifiactionHandler(){
        this.isNotification = !this.isNotification;        
        if(this.isNotification){  
            this.isSearch = false;       
            this.instaLogo  = true;            
            setTimeout(() => {
                this.retriveNotifications();
            }, 1000);                     
            this.template.querySelectorAll('.menuName').forEach(ele =>{
                ele.style.display = 'none';
            })
        }else{            
            this.template.querySelectorAll('.menuName').forEach(ele =>{
                ele.style.display = 'block';
            })  
            this.notification = [];                    
            this.instaLogo  = false;
        }
    }

    reelHandler(){
        returnReels({userId : this.userId, email : this.userMail}).then(res =>{
            this.reels = res;
        })
        this.instaLogo  = false;
        this.isHome = false;
        this.isProfile = false;
        this.isNotification = false;
        this.isMessage = false;
        this.isMsg = false;
        this.isSearch = false; 
        this.isUserMsg = false;      
        this.isReel = true;
    }
    
    //search handler
    searchHandler(){
         this.isSearch = !this.isSearch;
         if(this.isSearch){        
            this.instaLogo  = true;            
            this.template.querySelectorAll('.menuName').forEach(ele =>{
                ele.style.display = 'none';
            })
        }else{
            this.template.querySelectorAll('.menuName').forEach(ele =>{
                ele.style.display = 'block';
            })
            this.instaLogo  = false;
        }

    }

    //serch key handler
    searchKeyHandler(event){
        this.searchValue = event.target.value;
        searchUsers({searchKey : this.searchValue}).then(res =>{
            if(res){
                 this.searchValues = res;
            }else{
                this.searchValues = [];
            }
        })
    }
    
    //search user handler
    searchUserHandler(event){
        this.searchValue = event.target.value;
        searchUsers({searchKey : this.searchValue}).then(res =>{
            if(res){
                 this.searchValues = res;
            }else{
                this.searchValues = [];
                this.isOnChat = true;
                this.isOnSend = true;
            }
        })

    }

    //click msg handler
    clickMsgHandler(event){
        this.currUserMsg = event.currentTarget.dataset.id;       
        this.isOnChat = false;
        this.isOnSend = false;
    }

    //chat msg handler
    chatMsgHandler(){
        this.returnUsermsg(this.userId, this.currUserMsg);
        this.isMsgUser = false;
    }

    //send post handler
    sendPostHandler(event){
        this.sendPostId = event.currentTarget.dataset.postid;
        this.isMsgUser = true;
        this.isChat = false;       
    }

    //sender post handler
    senderPostHandler(){
        sendPost({postId : this.sendPostId, userId : this.userId, otherUserId : this.currUserMsg}).then(res => {           
            this.isMsgUser = false;
            this.showToast('Send Successfully', 'Send post Successfully', 'success');
        })
    }
    
    //open file upload handler
    openfileUpload(event) {
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.base64 = base64;
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.recordId
            }
        }
        reader.readAsDataURL(file);
    }

    //open profile handler
    openProfilehandler(event){
        let mail = event.currentTarget.dataset.email;
        let id = event.currentTarget.dataset.id;
        this.isSearch = false; 
        retriveUserPost({userId : id}).then(res =>{
            this.userPosts = res; 
            getUserDetails({userId : id, userEmail : mail}).then(res =>{
                this.personalUserData = res;
                this.instaLogo  = false;
                this.isHome = false;
                this.isProfile = false;
                this.isNotification = false;
                this.isMessage = false;
                this.isMsg = false;
                this.isSearch = false; 
                this.isUserMsg = false;
                this.isProfilePersonal = true;
                this.isPostProfile = true;
            })
        })       
        this.template.querySelectorAll('.menuName').forEach(ele =>{
            ele.style.display = 'block';
        })
    }
    
    //save handler
    saveHandler(event){
      let post = event.currentTarget.dataset.id; 
      removeSavePost({userId : this.userId, postId : post}).then(res =>{
        if(res.length == 0){
            createSavePost({userId : this.userId, postId : post}).then(res =>{
                this.postsRefresh();
            })            
        }else{
            deleteSavePost({userId : this.userId, postId : post}).then(res =>{
                this.postsRefresh();
            })
        }               
      })
    }  
    
    //msg handler
    messageHandler(){
    this.template.querySelectorAll('.menuName').forEach(ele =>{
            ele.style.display = 'none';
    })      
    this.returnMsgProfileHandler();
    this.instaLogo  = true;  
    this.isHome = false;
    this.isComment =false;
    this.isSearch = false;
    this.isUserMsg = false;
    this.isNotification = false;
    this.isProfile = false;    
    this.isMessage = true;
    this.isMsg = true;   
    }

    //return profile handler
    returnMsgProfileHandler(){
        returnMsgProfile({userId : this.userId}).then(res =>{
            this.userProfileMsg = res;
        })
    }
    
    //msg profile handler
    msgProfileHandler(event){
       this.otherUserIDs = event.currentTarget.dataset.otheruser;   
        this.template.querySelectorAll('.userPro').forEach(ele =>{
            ele.style.background = '';
        })
        this.template.querySelector(`[data-otheruser="${this.otherUserIDs}"]`).style.background = 'rgb(233, 230, 230)'; 
        this.returnUsermsg(this.userId, this.otherUserIDs);
    }

    //msg delete handler
    msgDeleteHandler(event){
        let dataId = event.currentTarget.dataset.msgp;
      this.template.querySelector(`[data-msgid="${dataId}"]`).style.display = 'block';    
    }
    
    //msg delete false
    msgDeleteFalse(event){
        let dataId = event.currentTarget.dataset.msgp;
        this.template.querySelector(`[data-msgid="${dataId}"]`).style.display = 'none';        
    }  

    handleOnselect(event) {
        this.msid = event.detail.value;
        this.isDeleteMsg = true;       
    }

    deleteMsgHandler(){
        deleteMsg({msgId : this.msid}).then(res =>{ 
            this.isDeleteMsg = false;
            this.returnUsermsg(this.userId, this.otherUserIDs);
            this.returnMsgProfileHandler();
            this.showToast('Delete Successfully', 'Deleted Successfully', 'success');           
        })
    }

    deleteCancelModal(){
        this.isDeleteMsg = false;
    }
    
    //msg send handler 
    msgSendHandler(event){
      this.msgData = event.target.value;
    }

    //return user msg
    returnUsermsg(userid, receiverid){
        returnUserMsg({userId : userid, otherUserId : receiverid}).then(res =>{
            this.allMsg = res;
            this.isMessage = false; 
            this.isUserMsg = true;
        })       
    }

    //handle subscriber run (platform event method)
    handleSubscribe() {               
        const messageCallback = (response)=> {
            var obj = JSON.parse(JSON.stringify(response));
            let objData = obj.data.payload;  
            let checkuser;
            if(objData.senderId__c == this.userId){
                checkuser = false;
            }else{        
                checkuser = true;
            }
            if(objData.picUrl__c === null){
                this.obj =  {msg : objData.msg__c, msgTime : objData.CreatedDate__c, receiver : checkuser, imgUrl: this.base64, img : false}; 
            }else{
                this.obj =  {msg : objData.msg__c, msgTime : objData.CreatedDate__c, receiver : checkuser, imgUrl: this.base64, img : true}; 
            }    
            this.allMsg.msgList.push(this.obj);
        };
        subscribe(this.channelName, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }
    
    //msg sending handler 
    msgSendingHandler(event){
        let otheruser = event.currentTarget.dataset.userreceiver;
        createMsgHandler({senderId : this.userId, receiverId: otheruser, msg: this.msgData}).then(res =>{ 
           this.template.querySelector('.msgArea').value = '';
           this.msgData = null;
            this.returnMsgProfileHandler();
        })
    }
    
    //file InsertHandler click on icon and automatically call file
    fileInsertHandler(event){
       this.receiverUserId = event.currentTarget.dataset.receiverid;        
       this.template.querySelector('.fileInput').click();
    }
    
    //upload file handler
    uploadFileHandler(event){
        const file = event.target.files[0];             
        createMsgHandler({senderId : this.userId, receiverId: this.receiverUserId, msg: this.msgData}).then(res =>{          
            var reader = new FileReader();
            reader.onload = () => {
                var base64 = reader.result.split(',')[1];                
                uploadFile({base64: base64, filename: file.name, recordId: res}).then(result=>{
                    this.fileData = null
                    let title = `${file.name} uploaded successfully!!`
                })               
            }
            reader.readAsDataURL(file);
         })      
    }
    
    //open msg modal for search user and send msg
    openMsgHandler(){
        this.isChat = true;
        this.isMsgUser = true;
    }

    //close msg modal
    isMsgClose(){
        this.isChat = false;
        this.isMsgUser = false;
    }

    //switch user mail
    switchUserEmail(event){
        this.userMail =  event.target.value; 
        login({userMail : this.userMail}).then(res =>{
            this.userId = res.Id;
            this.correctPass = res.password;
            this.UserName = res.Name;
        })        
    }
    
    //switchHandler
    switchHandler(){        
       this.isSwitchUser = true;
    }
 
    //switchHandler Cancel modal    
    switchCancelModal(){
        this.isSwitchUser = false;
    }
     
    //update name
    editNameChange(event){
     this.newName = event.target.value;
    }

    //update password
    editPassword(event){
    this.newPass = event.target.value;
    }
    
    //open update profile handler
    editProfileHandler(){
        this.newName = this.UserName;
        this.newPass = this.userPass;
        this.isEditProfile = true;
    }
     
    //cancel profile cancel
    editProfileCancelHandler(){
        this.isEditProfile = false;
    }
    
    //upload pic handler
    uploadPicHandler(event){        
        this.template.querySelector('.picInput').click();

    }
    
    //update profile pic  handler
    updateProfilePic(event){
        const file = event.target.files[0];
        deleteProfilePic({userId : this.userId}).then(res =>{
            var reader = new FileReader();
            reader.onload = () => {
                var base64 = reader.result.split(',')[1];                
                uploadFile({base64: base64, filename: file.name, recordId: this.userId}).then(result=>{
                    this.fileData = null
                    let title = `${file.name} uploaded successfully!!`
                    this.returnProfile();
                })               
            }
            reader.readAsDataURL(file);

        })   
         
    }

    //update profile handler
    updateProfileHandler(){
        this.userName = this.newName;      
        updateProfile({userId : this.userId, name : this.newName, password : this.newPass}).then(res =>{         
            this.isEditProfile = false;
            this.showToast('Updated Sucessfully', 'Profile Updated Sucessfully', 'success');
            this.profilehandler();
        })
    }
   
    //remove follower handler
    removeFollowerHandler(event){
        let followerName = event.currentTarget.dataset.followername;
        let followerEmail = event.currentTarget.dataset.followeremail;
        removeFollower({removeEmailFollower : followerEmail, userId : this.userId}).then(res =>{
            this.isFollowerDetailsModal = false;
           this.showToast('Unfollow Sucessfully', 'You are unfollow'+`${followerName}`+'Successfully', 'success');
            this.profilehandler();
        })
    }
    
    //forget password Handler
    forgetPasswordHandler(){
        this.isLogin = false;
        this.isSignUp = false;
        this.isOTP = false;
        this.isMatchPassword = false;
        this.isbtnVerification = false;
        this.timer = 20;
        this.isRunTime = true;
        this.isForget = true;       
    }
    
    //email forget
    emailForget(event){
        this.forgetEmail = event.target.value;
        verifyEmail({email : this.forgetEmail}).then(res =>{
           if(res.length == 0){
              this.isMatchPassword = false;
           }else{
             this.isMatchPassword = true;
           }
        })
    }
    
    //otp handler
    otpHandler(){
        var minm = 100000; 
        var maxm = 999999;
        this.otp = Math.floor(Math.random() * (maxm - minm + 1))+ minm;
          sendEmail({userEmail : this.forgetEmail, otp : this.otp}).then(res =>{  
            console.log('otp ====>'+this.otp);
            if(this.isRunTime){
                this.timeRuningHandler();
            }    
            this.isForget = false;
            this.isChangePassword = false;                      
            this.isOTP = true;             
          })  
        
       
    }

    //otp change Handler
    otpChangeHandler(event){
     this.otpChange = event.target.value;
    }
    
    //verify email confirmation Handler
    verifyEmailConfirmationHandler(){
        if(this.otp == this.otpChange){
            this.isOTP = false;
            this.isForget = false;
            this.isLogin = false;
            this.timer = 0;            
            this.isChangePassword = true;
        }else{
           this.showToast('Otp do not match', 'Please, send again', 'error');
        }
    }
    
    //new Password
    newPassword(event){
        this.newPassChange = event.target.value;
    }
    
    //goto login Page
    gotoLoginHandler(){
      this.isForget = false;
      this.isOTP = false;
      this.isChangePassword = false;
      this.isMatchPassword = false;    
      this.isCorrectPassword = false;     
      this.isLogin = true;
    }

    //mew Change password match with password
    newChangePassword(event){
       let newMatchPassword = event.target.value;
        if(this.newPassChange == newMatchPassword){
            this.isCorrectPassword = true;        
        }else{
            this.isCorrectPassword = false;
        }
    }
    
    //submit password and update password
    submitPassword(){
        updatePassword({email : this.forgetEmail, password : this.newPassChange}).then(res =>{
            this.isForget = false;
            this.isChangePassword = false;
            this.isLogin = true;            
           this.showToast('Updated Successfully', 'You are updated password. Please Login Now', 'success');
        })
    }

    //this is for increasing time
   timeRuningHandler(){
    this.isRunTime = false;
    this.timeSet = setInterval(() => {
        this.timeDesc(); 
    }, 1000);   
   }

   //this is for time desc for timer
   timeDesc(){ 
    if(this.timer == 0){    
        this.template.querySelector('.time').style.display = 'none';
        this.isbtnVerification = true;
        this.otp = null;
        clearInterval(this.timeSet);      
    }
    this.template.querySelector('.time').innerHTML = this.timer;
    this.timer--;
    }
    

    //toast method
    showToast(toastTitle, toastMessage, toastVariant) {    
        const toastEvent = new ShowToastEvent({
            title: toastTitle,
            message: toastMessage,
            variant: toastVariant,
        })
        this.dispatchEvent(toastEvent);
    }

    
}