import { LightningElement, api, track } from 'lwc';
import { subscribe} from 'lightning/empApi';
import retriveUserHandler from '@salesforce/apex/SendMsgWithWhatsapp.retriveUserHandler';
import returnMessages from '@salesforce/apex/SendMsgWithWhatsapp.returnMessages';
import sendMessage from '@salesforce/apex/SendMsgWithWhatsapp.sendMessage';
import userCreateHandler from '@salesforce/apex/SendMsgWithWhatsapp.userCreateHandler';
import deleteMsg from '@salesforce/apex/SendMsgWithWhatsapp.deleteMsg';
export default class WhatsAppMessanger extends LightningElement {
isMsg = false;
isReply = false;
isUser = false;
isCreateUser = false;
isDeleteModal = false;
isHome = true;
users = [];
@track messageWrapperList;
userId;
msgData;
userPhone;
userName;
newName;
newPhone;
replyMsgId;
replyMsg;
replyLable;
getMsgId;
subscription = {};
 @api channelName = '/event/WhatsAppMessage__e';

 //constructor
  constructor(){
    super();
    const style = document.createElement('style');
    style.innerText = ` 
    .slds-textarea{
        border:none;
         height:30px;
          resize: none;
          padding:5%;
    }
    .slds-button{
        border:none;
        margin:0;
        padding:0;
    }`;
    document.querySelector('head').appendChild(style);
}

//connected call back
connectedCallback(){
    this.retiveUser();
    this.handleSubscribe();
}

//render call back
renderedCallback(){
    const scrollData = this.template.querySelector('[data-scroll-section]');
    if(scrollData){
     scrollData.scrollTop = scrollData.scrollHeight;
    }
 }

//retrive User handler
retiveUser(){
    retriveUserHandler().then(res =>{        
        this.users = res;
        this.user =  this.users.sort((a, b) => a.dt < b.dt ? 1 : -1);
    })
}

//userHandler 
userHandler(event){
this.messageWrapperList = [];
this.userId = event.currentTarget.dataset.id;
this.userPhone = event.currentTarget.dataset.phone;
this.userName = event.currentTarget.dataset.name;
this.isHome = false;
this.isMsg = true;
this.returnUserMsgHandler();
}

//return User Msg Handler
returnUserMsgHandler(){
    this.messageWrapperList = [];
    returnMessages({userId : this.userId}).then(res =>{
        this.messageWrapperList = res;
    })
}

//msg send handler
msgSendHandler(event){
    this.msgData = event.target.value;
    if(event.keyCode == 13){
     console.log('keyCode====>'+event.keyCode);
      this.sendMsgHandler();
    }
}


 //handle subscriber run (platform event method)
 handleSubscribe() {              
    const messageCallback = (response)=> {
        var obj = JSON.parse(JSON.stringify(response));
        let objData = obj.data.payload;   
        const [msgDate, msgTime] = objData.MsgSentTime__c.split(","); 
       // let keyPoint = `TODAY-${objData.SenderId__c}`;
        let keyPoint = `TODAY-${objData.SenderId__c}`;
        let filterObj = this.messageWrapperList.filter(ele => ele.dt == keyPoint); //return a list so we use 0index to push (filterObj[0])          
        if(filterObj.length > 0){
            console.log('aa rha h');
            let obj = {msg : objData.msg__c, msgTime : msgTime, receiver : objData.SentMsg__c, sent:objData.MsgClass__c, recUserId : objData.SenderId__c, msgId: objData.RecordId__c, status : objData.delivered__c, showTick : objData.sent__c , messageId : objData.messageId__c, replyMsgId : objData.ReplyId__c, replyLabel : objData.ReplyLabel__c, replyMsg : objData.ReplyMsg__c};
            let existMsg = filterObj[0].msgList.filter(msgElement => msgElement.msgId ==  objData.RecordId__c );
            if (existMsg.length) {
                existMsg.forEach(ele =>{
                    ele.status = objData.delivered__c;
                    ele.showTick = objData.sent__c;
                })
            }else{
                filterObj[0].msgList.push(obj); 
            }        
        }else{ 
            if(objData.SenderId__c == this.userId){        
            let obj =  { dt: keyPoint , key: 'TODAY', msgList :[{msg : objData.msg__c, msgTime : msgTime, receiver : objData.SentMsg__c, sent:objData.MsgClass__c,  recUserId : objData.SenderId__c, msgId: objData.RecordId__c, status : objData.delivered__c, showTick : objData.sent__c, messageId : objData.messageId__c, replyMsgId : objData.ReplyId__c, replyLabel : objData.ReplyLabel__c, replyMsg : objData.ReplyMsg__c}]};
            this.messageWrapperList.push(obj);    
            }            
        }
        console.log('daata==Msg>'+JSON.stringify(this.messageWrapperList));
       
    };

    subscribe(this.channelName, -1, messageCallback).then(response => {
        this.subscription = response;
    });
}

//send Msg Handler
sendMsgHandler(){
    if(this.msgData){
    sendMessage({phoneNumberId :'319481387908362',phoneNumber : this.userPhone, msgToSend : this.msgData, sendMsg : true, replyMsgId : this.replyMsgId}).then(res =>{
        this.template.querySelector('.msgArea').value = '';
        this.template.querySelector('.chatMsg').style.height = '45vh';
        this.msgData = null;
        this.replyMsg = null;
        this.replyLable = null;
        this.replyMsgId = null;
        this.isReply = false;
        console.log('sending sucessefully');
    })
 }
}

//backHandler
backHandler(){
this.retiveUser();
this.isMsg = false;
this.isHome = true;
}

//open Modal Handler
openCreateModalHandler(){
this.isCreateUser = true;
this.isUser = true;
}

//create User
createUserhandler(){
    this.isUser = false;
}

//close Modal Handler
isclosdCreateUserModalHandler(){
    console.log('is close');
    this.isUser = false;
    this.isCreateUser = false;
}

//newPhone Handler
newPhoneHandler(event){
this.newPhone = event.target.value;
}

//new Name Handler
newNameHandler(event){
this.newName = event.target.value;
}

//user save Handler
userSavehandler(){
    userCreateHandler({name : this.newName, phone : this.newPhone}).then(res =>{        
        if(res){
            this.retiveUser();
            this.isclosdCreateUserModalHandler();
        }  
    })
}

//show Delele Btn Handler
showDeleteBtn(event){
    let dataId = event.currentTarget.dataset.shoing;
    this.template.querySelector(`[data-hide="${dataId}"]`).style.display = 'none';
    this.template.querySelector(`[data-show="${dataId}"]`).style.display = 'block';
}

//delete Handler for Delete Msg
deleteModalHandler(event){
this.getMsgId = event.currentTarget.dataset.msgid;
console.log('getMsgid=====>'+this.getMsgId);
this.isDeleteModal = true;
}

deleleMsgHandler(){
    deleteMsg({msgId : this.getMsgId}).then(res =>{
        this.isDeleteModal = false;
        this.returnUserMsgHandler();
        this.retiveUser();
    })
}

cancelDeleteHandler(){
    this.isDeleteModal = false;
}

//hide Delete Btn
hideDeleteBtn(event){
    let dataId = event.currentTarget.dataset.shoing;
    this.template.querySelector(`[data-hide="${dataId}"]`).style.display = 'block';
    this.template.querySelector(`[data-show="${dataId}"]`).style.display = 'none';
}

replyHandler(event){
  this.replyMsgId = event.currentTarget.dataset.messageid;
  this.replyMsg = event.currentTarget.dataset.msg;
  this.replyLable = event.currentTarget.dataset.label;
  this.template.querySelector('.chatMsg').style.height = '35vh';
  this.isReply = true;
}

closeReplyHandler(){
this.template.querySelector('.chatMsg').style.height = '45vh';
this.replyMsg = null;
this.replyLable = null;
this.isReply = false;
}


}