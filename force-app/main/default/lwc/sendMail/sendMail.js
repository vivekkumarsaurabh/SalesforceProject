import { LightningElement, wire, api, track } from 'lwc';
import getAllUsers from '@salesforce/apex/SendEmailWithLWC.getAllUsers';
import sendEmail from '@salesforce/apex/SendEmailWithLWC.sendEmail';
import getContact from '@salesforce/apex/SendEmailWithLWC.getContact';
import getAllFields from '@salesforce/apex/SendEmailWithLWC.getAllFields';
import getAllsObject from '@salesforce/apex/SendEmailWithLWC.getAllsObject';
import getFieldValue from '@salesforce/apex/SendEmailWithLWC.getFieldValue';
import getAllRecords from '@salesforce/apex/SendEmailWithLWC.getAllRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { EnclosingUtilityId, minimize } from 'lightning/platformUtilityBarApi';
import { CurrentPageReference } from 'lightning/navigation';



export default class SendMail extends NavigationMixin(LightningElement) {
    isSendingMail = false;
    isCC = false;
    isToSend = false;
    isSucessModal = false;
    isCcSend = false;
    isBccSend = false;
    isError = false;
    isBody = false;
    isMergeField = false;
    isReceipient = false;
    isSender = false;
    isAccountBrand = false;
    isOrganization = false;
    isTask = false;
    userList = [];
    sObjectList = [];
    @track toSendList = [];
    @track toCcUsersList = [];
    @track toBccUsersList = [];
    @track toContactList = [];
    @track fileAttachmentBlob = [];
    @track recipientOptionList = [];
    sObjectRecordData = [];
    taskfieldName = [];
    errorMsg;
    toSend;
    toBccUsers;
    toCcUsers;
    selectedUser;
    subjectEmail;
    bodyEmail;
    checkInputBox;
    plainBodyText;
    baseUrl;
    unknown;
    @track objectApiName = 'Contact';
    @track fieldApiName = 'ContactId';
    relatedToValue;
    variable;
    icon
    timer;
    error;

    //constrcuct for append style in head for internal css.
    constructor() {
        super();
        const style = document.createElement('style');
        style.innerText = `.slds-radio{padding:10px;}  .custom-menu-item .slds-icon { font-size: 20px; }`;
        document.querySelector('head').appendChild(style);
    }


    //for utility bar Id
    @wire(EnclosingUtilityId)
    utilityId;

    //connected call back
    connectedCallback() {
        this.getAllUserHandler();
        getAllsObject().then(res => {
            console.log('res--->', JSON.stringify(res));

            this.sObjectList = res;
        })
    }

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if (currentPageReference) {
            this.baseUrl = window.location.origin;
        }
    }


    //get all user
    getAllUserHandler() {
        getAllUsers().then(res => {
            if (res) {
                this.userList = res;
                this.selectedUser = res[0].value;
            }
        }).catch(error => {
            this.error = error;
        })
    }

    openSendingMail(){
        this.isSendingMail = true;
    }

    closeSendingMail(){
         this.toSendList = [];
         this.toCcUsersList = [];
         this.toBccUsersList = [];
         this.toContactList = [];
         this.fileAttachmentBlob = [];
        // this.recipientOptionList = [];
         this.sObjectRecordData = [];
         this.toSend = null;
         this.toBccUsers = null;
         this.toCcUsers = null;
        // this.selectedUser = null;
        // this.subjectEmail = null;
         this.bodyEmail = null;
        // this.checkInputBox = null;
         this.plainBodyText = null;
        this.isSendingMail = false;
    }

    //from user selected handler
    handleSeletedUser(event) {
        this.selectedUser = event.detail.value;
    }

    //to users selected handler
    toHandler(event) {
        this.toSend = event.target.value;
        if (this.toSend) {
            this.template.querySelector('.contactBox').style.top = '100%';
            this.checkInputBox = 'toSend';
            this.gettingAllRelatedContact(this.toSend);
        } else {
            this.toContactList = [];
        }
    }

    //subject handler
    subjectHandler(event) {
        this.subjectEmail = event.target.value;
    }

    //cc user handler
    ccHandler(event) {
        this.toCcUsers = event.target.value;
        if (this.toCcUsers) {
            this.template.querySelector('.contactBox').style.top = '200%';
            this.checkInputBox = 'toCcUsers';
            this.gettingAllRelatedContact(this.toCcUsers);
        } else {
            this.toContactList = [];
        }
    }

    //bcc users handler
    bccHandler(event) {
        this.toBccUsers = event.target.value;
        if (this.toBccUsers) {
            if (this.isCC) {
                this.template.querySelector('.contactBox').style.top = '300%';
            } else {
                this.template.querySelector('.contactBox').style.top = '200%';
            }
            this.checkInputBox = 'toBccUsers';
            this.gettingAllRelatedContact(this.toBccUsers);
        } else {
            this.toContactList = [];
        }
    }

    focustOutHandler(){
        
              if(this.unknown != null || this.unknown != undefined){
                let email = this.unknown;             
                // let conObject = { name: this.unknown, email: this.unknown, id: this.unknown };
                if (this.checkInputBox === 'toSend') {
                    this.isToSend = true;
                    let conObject = { name: this.unknown, email: this.unknown, id: this.unknown , pillIdentifier: 'toSend'};
                    if (this.toSendList.length != 0) {
                        let available = this.toSendList.filter(item => email.includes(item.email));
                        if (available.length == 0) {
                            this.toSend = null;
                            this.unknown = null;
                            this.toSendList.push(conObject);                                               
                        }
                    } else {
                        this.unknown = null;
                        this.toSend = null;
                        this.toSendList.push(conObject);  
                    }
        
                } else if (this.checkInputBox === 'toBccUsers') {
                    this.isBccSend = true;
                    let conObject = { name: this.unknown, email: this.unknown, id: this.unknown , pillIdentifier: 'toBccUsers'};

                    if (this.toBccUsersList.length != 0) {
                        let available = this.toBccUsersList.filter(item => email.includes(item.email));
                        if (available.length == 0) {
                            this.unknown = null;
                            this.toBccUsers = null;
                            this.toBccUsersList.push(conObject);
                        }
                    } else {
                        this.unknown = null;
                        this.toBccUsers = null;
                        this.toBccUsersList.push(conObject);                       
                    }
                } else {
                    this.isCcSend = true;
                    let conObject = { name: this.unknown, email: this.unknown, id: this.unknown, pillIdentifier: 'toCcUsers'};
                    if (this.toCcUsersList.length != 0) {
                        let available = this.toCcUsersList.filter(item => email.includes(item.email));
                        if (available.length == 0) {
                            this.unknown = null;
                            this.toCcUsers = null;
                            this.toCcUsersList.push(conObject);                          
                        }
                    } else {
                        this.unknown = null;
                        this.toCcUsers = null;
                        this.toCcUsersList.push(conObject);
                       
                    }
                }

              }              
             
    }

    //search related Contact with search Name
    gettingAllRelatedContact(name) {
        getContact({ searchContactName: name }).then(cons => {
            if (cons.length > 0) {
                this.toContactList = cons;
            } else {
                this.unknown = name;   
                 this.toContactList = [];
            }
        })
    }
   
    //validate email
    validateEmail(email) {

        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        
        return emailPattern.test(email);
        
    }

    //sending email handler
    sendEmailHandler() {
        if (this.toSendList.length == 0 || this.subjectEmail == null || this.selectedUser == null) {
            this.errorMsg = 'fill required field to send an email.';
            this.isError = true;
        } else {
            this.toSendList.forEach(item =>{
                if(!this.validateEmail(item.email)){
                    this.errorMsg = 'One or more email addresses are not valid.';
                    this.isError = true; 
                }else{
                    this.isError = false;
                }
            })
            if(this.toCcUsers.length > 0){
                this.toCcUsersList.forEach(item =>{
                    if(!this.validateEmail(item.email)){
                        this.errorMsg = 'One or more email addresses are not valid.';
                        this.isError = true; 
                    }else{
                        this.isError = false;
                    }
                })
            }
            if(this.toBccUsersList.length > 0){
                this.toBccUsersList.forEach(item =>{
                    if(!this.validateEmail(item.email)){
                        this.errorMsg = 'One or more email addresses are not valid.';
                        this.isError = true; 
                    }else{
                        this.isError = false;  
                    }
                })
            }
        }
        if (!this.isError) {
            this.isSucessModal = true;
            this.timeRuningHandler();
        }
    }

    //sending email handler
    sendingHandler() {
        if (this.toSendList.length != 0) {
            sendEmail({ subject: this.subjectEmail, toUserList: JSON.stringify(this.toSendList), fromUser: this.selectedUser, toBccUserList: JSON.stringify(this.toBccUsersList), toCcUserList: JSON.stringify(this.toCcUsersList), body: this.bodyEmail, fileBlobList: JSON.stringify(this.fileAttachmentBlob), relatedTo: this.relatedToValue }).then(res => {
                if (res) {
                    minimize(this.utilityId).then((isMinimized) => {
                        // console.log(`Minimize utilty ${isMinimized ? 'successfully' : 'failed'}`);
                    });
                    this.isSendingMail = false;
                    this.showToast('Email', 'Email was sent', 'success');
                }
            }).catch(erro => {
                this.error = error;
            })
        }
    }

    //time runnig for undo 
    timeRuningHandler() {
        this.timer = 10;
        this.timeSet = setInterval(() => {
            this.timeAsc();
        }, 1000);
    }

    //time decrease of undo sendMail
    timeAsc() {
        if (this.timer == -1) {
            this.isSucessModal = false;
            this.sendingHandler();
            clearInterval(this.timeSet);
        } else {
            let timeBody = `Undo (${this.timer--} s)`;
            this.template.querySelector('.time').innerHTML = timeBody;
        }
    }

    //handle body 
    handleRichTextChange(event) {
        this.bodyEmail = event.target.value;
    }

    //open cc box
    addCCHandler() {
        this.isCC = true;
    }

    //cancel modal handler
    cancelModal() {
        this.timer = -1;
        clearInterval(this.timeSet);
        this.isSucessModal = false;
    }


    //file Attachment click on icon and automatically call file
    fileAttachIconHandler() {
        this.template.querySelector('.fileInput').click();
    }

    //upload file handler
    uploadFileHandler(event) {
        const file = event.target.files[0];
        var reader = new FileReader();
        reader.readAsDataURL(file)
        reader.onload = () => {
            var base64 = reader.result.split(',')[1];
            let attachment = { fileName: file.name, fileType: file.type, blobBody: base64 };
            this.fileAttachmentBlob.push(attachment);
        }
    }

    //remove Attachment Handler
    removeAttachmentHandler(event) {
        let fileName = event.currentTarget.dataset.file;
        this.fileAttachmentBlob = this.fileAttachmentBlob.filter(item => !fileName.includes(item.fileName));
    }

    //select Contact Handler
    selectContactHandler(event) {
        let email = event.currentTarget.dataset.selectemail;
        let emailLabel = event.currentTarget.dataset.personname;
        let idContact = event.currentTarget.dataset.conid;
        // let conObject = { name: emailLabel, email: email, id: idContact };
        if (this.checkInputBox === 'toSend') {
            this.isToSend = true;            
            let conObject = { name: emailLabel, email: email, id: idContact , pillIdentifier: 'toSend'};
            if (this.toSendList.length != 0) {
                let available = this.toSendList.filter(item => email.includes(item.email));
                if (available.length == 0) {
                    this.toSendList.push(conObject);
                    this.toSend = null;
                    this.unknown = null;
                }
            } else {
                this.toSendList.push(conObject);
                this.toSend = null;
                this.unknown = null;
            }
        } else if (this.checkInputBox === 'toBccUsers') {
            this.isBccSend = true;
            let conObject = { name: emailLabel, email: email, id: idContact , pillIdentifier: 'toBccUsers'};
            if (this.toBccUsersList.length != 0) {
                let available = this.toBccUsersList.filter(item => email.includes(item.email));
                if (available.length == 0) {
                    this.toBccUsersList.push(conObject);
                    this.toBccUsers = null;
                    this.unknown = null;
                }
            } else {
                this.toBccUsersList.push(conObject);
                this.toBccUsers = null;
                this.unknown = null;
            }
        } else {
            this.isCcSend = true;
            let conObject = { name: emailLabel, email: email, id: idContact , pillIdentifier: 'toCcUsers'};
            if (this.toCcUsersList.length != 0) {
                let available = this.toCcUsersList.filter(item => email.includes(item.email));
                if (available.length == 0) {
                    this.toCcUsersList.push(conObject);
                    this.toCcUsers = null;
                    this.unknown = null;
                }
            } else {
                this.toCcUsersList.push(conObject);
                this.toCcUsers = null;
                this.unknown = null;
            }
        }
        this.toContactList = [];
    }

    //handle Remove 
    handleRemove(event) {
        let data = event.currentTarget.dataset.pill; 
        let chekInput = event.currentTarget.dataset.identifier;     
        if (chekInput === 'toSend') {
            this.toSendList = this.toSendList.filter(item => !data.includes(item.email));
        } else if (chekInput === 'toBccUsers') {
            this.toBccUsersList = this.toBccUsersList.filter(item => !data.includes(item.email));
        } else{
            this.toCcUsersList = this.toCcUsersList.filter(item => !data.includes(item));
        }
    }

    mergeFieldHandler() {
        // this[NavigationMixin.GenerateUrl]({
        //     type: 'standard__webPage',
        //     attributes: {
        //         url: 'https://algocirruspvtltd-6d-dev-ed.develop.lightning.force.com/lightning/n/Hello'
        //     }
        // }).then(generatedUrl => {
        //     console.log('data====>',generatedUrl);            
        //     window.open(generatedUrl,'Open','width=500,height=500');
        // });
        // let temp = this.template.querySelector('.submenu');
        // console.log('temp===>',temp);
        this.isReceipient = true;
        this.isSender = false;
        this.isAccountBrand = false;
        this.isOrganization = false;
        this.getAllFieldHandler('Contact');
        this.isMergeField = true;
    }

    receipientHandler(event) {
        this.template.querySelectorAll('.menuItem').forEach(ele => {
            ele.style.background = 'none';
            ele.style.border = 'none';
        })
        event.target.style.background = 'rgb(168, 168, 255)';
        event.target.style.borderLeft = '2px solid blue';
        this.isReceipient = true;
        this.isSender = false;
        this.isAccountBrand = false;
        this.isOrganization = false;
        this.getAllFieldHandler('Contact');
    }

    getAllFieldHandler(sObjectName) {
        if (this.isReceipient) {
            getAllFields({ objectName: sObjectName }).then(field => {
                if (field) {
                    this.recipientOptionList = field;
                    this.isReceipient = true;
                }
            })
            getAllFields({ objectName: 'Lead' }).then(field => {
                if (field) {
                    field.forEach(iterateField => {
                        this.recipientOptionList.push(iterateField);
                        this.isReceipient = true;
                    })
                }
            })
        } else if (this.isSender) {
            this.recipientOptionList = [];
            getAllFields({ objectName: sObjectName }).then(field => {
                if (field) {
                    this.recipientOptionList = field;
                    this.isSender = true;
                }
            })
        } else if (this.isAccountBrand) {
            this.recipientOptionList = [];
            getAllFields({ objectName: sObjectName }).then(field => {
                if (field) {
                    this.recipientOptionList = field;
                    this.isAccountBrand = true;
                }
            })
        } else if (this.isOrganization) {
            console.log('aaya');
            this.recipientOptionList = [];
            getAllFields({ objectName: sObjectName }).then(field => {
                console.log('organisation ----->',JSON.stringify(field));                
                if (field) {
                    this.recipientOptionList = field;
                    this.isOrganization = true;
                }
            })
        }

    }

    senderHandler(event) {
        this.template.querySelectorAll('.menuItem').forEach(ele => {
            ele.style.background = 'none';
            ele.style.border = 'none';
        })
        event.target.style.background = 'rgb(168, 168, 255)';
        event.target.style.borderLeft = '2px solid blue';
        this.isReceipient = false;
        this.isSender = true;
        this.isAccountBrand = false;
        this.isOrganization = false;
        this.getAllFieldHandler('User');
    }

    senderBrandHandler(event) {
        this.template.querySelectorAll('.menuItem').forEach(ele => {
            ele.style.background = 'none';
            ele.style.border = 'none';
        })
        event.target.style.background = 'rgb(168, 168, 255)';
        event.target.style.borderLeft = '2px solid blue';
        this.isReceipient = false;
        this.isSender = false;
        this.isAccountBrand = true;
        this.isOrganization = false;
        this.getAllFieldHandler('AccountBrand');
    }

    organnizationHandler(event) {
        this.template.querySelectorAll('.menuItem').forEach(ele => {
            ele.style.background = 'none';
            ele.style.border = 'none';
        })
        event.target.style.background = 'rgb(168, 168, 255)';
        event.target.style.borderLeft = '2px solid blue';
        this.isReceipient = false;
        this.isSender = false;
        this.isAccountBrand = false;
        this.isOrganization = true;
        this.getAllFieldHandler('Organization');
    }

    searchHandler(event) {
        let val = event.detail.value;
        if (val) {
            this.recipientOptionList = this.recipientOptionList.filter(item => val.includes(item.label));
            console.log('data===>', JSON.stringify(this.recipientOptionList));
        } else {
            let sObject;
            if (this.isReceipient) {
                sObject = 'Contact';
            } else if (this.isSender) {
                sObject = 'User';
            } else if (this.isAccountBrand) {
                sObject = 'AccountBrand';
            } else if (this.isOrganization) {
                sObject = 'Organization';
            }
            this.getAllFieldHandler(sObject);

        }

    }

    closeMergeHandler() {
        this.isMergeField = false;
    }

    inserTemplateHandler() {

        this.isMergeField = false;
    }

    recipientHandler(event) {
        this.recipientValue = event.detail.value;
    }


    InsertBodyHandler() {
        let sObject;
        if (this.isReceipient) {
            sObject = 'Contact';
        } else if (this.isSender) {
            sObject = 'User';
        } else if (this.isAccountBrand) {
            sObject = 'AccountBrand';
        } else if (this.isOrganization) {
            sObject = 'Organization';
        }

        if (this.toSendList.length == 1) {
            getFieldValue({ sObjectName: sObject, fieldApiName: this.recipientValue, sObejctApiRefrenceId: this.toSendList[0].id }).then(res => {
                if (res) {
                    this.variable = res;
                    if (this.bodyEmail == undefined || this.bodyEmail == null) {
                        this.bodyEmail = this.variable;
                    } else {
                        this.bodyEmail += this.variable;
                    }
                }
                this.isMergeField = false;
            })
        } else {
            this.isMergeField = false;
        }


    }

    htmlToPlainText(html) {
        return html.replace(/<[^>]*>/g, '');
    }

    openPreviewHandler() {
       if(this.isBody === true){
        if (this.bodyEmail != null || this.bodyEmail != undefined) {
            this.plainBodyText = this.htmlToPlainText(this.bodyEmail);
        }
        this.isBody = false;
       }else{
        this.isBody = true;
       }
    }

    // closeBodyHandler() {
    //     this.isBody = false;
    // }

    relatedToHandler(event) {
        this.relatedToValue = event.detail.value;
    }

    handlechangeSObject(event) {
        this.objectApiName = event.detail.value;

        getAllRecords({ sObjectName: this.objectApiName }).then(res => {
            this.sObjectRecordData = res;
        })

        // this.fieldApiName = `${this.objectApiName}Id`;
        console.log('objectApiName--->', event.detail.value);
        console.log('fieldApiName====>', this.fieldApiName);


    }

    // navigateToNewRecord() {
    //     this[NavigationMixin.Navigate]({
    //         type: 'standard__objectPage',
    //         attributes: {
    //             objectApiName: this.objectApiName, // Replace with your related object API name
    //             actionName: 'new'
    //         }
    //     });
    // }
    openEmailPreference(){
        let url = this.baseUrl+'/lightning/settings/personal/EmailSettings/home';
        window.open(url, '_blank');
    }

    handleSendWithGmail(){
        window.open('https://chromewebstore.google.com/detail/salesforce/jjghhkepijgakdammjldcbnjehfkfmha', '_blank');

    }

  
    handleCreateTask(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task',
                actionName: 'new'                
            },
            // state : {
            //     count: '1',
            //     nooverride: '1',
            //     useRecordTypeCheck : '1',
            //     defaultFieldValues: inheritParentString,
            //     navigationLocation: 'RELATED_LIST'
            // }
          });       
    }

     //handle create task Modal
     CreateTask() {
        this.isTask = false; 
        this.showToast('Record Inserted', 'Inserted Successfully', 'success');
    }
    cancelCreateTaskHandler(){
        this.isTask = false;
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