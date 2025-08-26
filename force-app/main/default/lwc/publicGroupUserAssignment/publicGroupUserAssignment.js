import { LightningElement } from 'lwc';
import getAllGroup from '@salesforce/apex/AssignUserIntoGroup.getAllGroup';
import getAllUser from '@salesforce/apex/AssignUserIntoGroup.getAllUser';
import createPublicGroup from '@salesforce/apex/AssignUserIntoGroup.createPublicGroup';
import getAssignAllUser from '@salesforce/apex/AssignUserIntoGroup.getAssignAllUser';
import searchUserHandler from '@salesforce/apex/AssignUserIntoGroup.searchUserHandler';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class PublicGroupUserAssignment extends LightningElement {
    isCreateGroup = false;
    isLoading = false;
    isErrorMsg = false;
    errorMsg;
    searchUser;
    selectedGroup;
    publiGroupLabel;
    publicGroupApiName;
    selectedUser = [];
    allGroup = [];
    allUsers = [];


    //connected call back
    connectedCallback() {
        this.getAllPublicGroup();
        this.getAllUsersHandler();
    }

    //get all public group
    getAllPublicGroup() {
        getAllGroup().then(groups => {
            if (groups) {
                this.allGroup = groups;
            }
        })
    }

    //get all user list
    getAllUsersHandler() {
        getAllUser().then(user => {
            if (user) {
                this.allUsers = user;
            }
        })
    }

    //clear group functionality
    clearGroupHandler(){
        this.selectedGroup = null;
        this.selectedUser = [];    
    }


    //change public group handler
    changePublicGroupHandler(event) {
        this.selectedGroup = event.target.value;
    }

    //select user handler
    selectuserHandler(event) {
        this.selectedUser = event.target.value;
    }

    //create public group hanlder
    createGroupHandler() {
        this.isCreateGroup = true;
    }

    //close modal of create public group
    closeCreatePublicGroupHandler() {
        this.publiGroupLabel = null;
        this.publicGroupApiName = null;
        this.isCreateGroup = false;
    }

    //public group label name
    labelNamechangeHandler(event) {
        this.publiGroupLabel = event.detail.value;
    }

    //set api name of public group
    publicGroupApichangeHandler(event) {
        this.publicGroupApiName = event.detail.value;
    }

    //create new group 
    createPublicGroupHandler() {
        if (this.publiGroupLabel != null && this.publicGroupApiName != null) {
            if (this.publicGroupApiName.includes(' ')) {
                this.isErrorMsg = true;
                this.errorMsg = 'Please enter valid Group Name not included spaces, special charecters.';
            } else {
                this.isLoading = true;
                this.isErrorMsg = false;
                createPublicGroup({ publicGroupLabel: this.publiGroupLabel, publicGroupName: this.publicGroupApiName }).then(res => {
                    if (res) {
                        this.getAllPublicGroup();
                        this.isLoading = false;
                        this.isCreateGroup = false;
                        this.publiGroupLabel = null;
                        this.publicGroupApiName = null;
                        this.showToast('Create Public Group', 'public Group Creaing sucessfully', 'success');
                    }
                })
            }
        } else {
            this.isErrorMsg = true;
            this.errorMsg = 'Please enter required Field';
        }
    }


    //assign User into  public group 
    assignUserIntoPublicGroupHandler() {
        if (this.selectedUser.length > 0 && this.selectedGroup != null) {
            this.isLoading = true;
            getAssignAllUser({ publicGroupId: this.selectedGroup, userIds: this.selectedUser }).then(res => {
                if (res) {
                    this.isLoading = false;
                    console.log('res====>',JSON.stringify(res));
                    
                    this.showToast('Assign User Sucessfully', 'Assigning User into Public group', 'success');
                    this.selectedGroup = null;
                    this.selectedUser = [];
                }
            })
        }
    }

    //search user functionality
    searchHandler(event){
     this.searchUser = event.detail.value;
      if(this.searchUser != null){
        searchUserHandler({key : this.searchUser}).then(res =>{
            if(res){
                console.log('res===>',JSON.stringify(res));
                
                this.allUsers = res;
            }
        })
      }else{
        this.getAllUsersHandler();
      }

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