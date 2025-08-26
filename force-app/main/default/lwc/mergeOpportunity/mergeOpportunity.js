import { LightningElement, api, wire } from 'lwc';
import queryChildRecords from '@salesforce/apex/MergeSObject.queryChildRecords';
import getsObjectFieldsValues from '@salesforce/apex/MergeSObject.getsObjectFieldsValues';
import getChildObject from '@salesforce/apex/MergeSObject.getChildObject';
import createRecord from '@salesforce/apex/MergeSObject.createRecord';
import deleteRecord from '@salesforce/apex/MergeSObject.deleteRecord';
import mergeChildRecords from '@salesforce/apex/MergeSObject.mergeChildRecords';
import retriveRecordName from '@salesforce/apex/MergeSObject.retriveRecordName';
import getRequiredFields from '@salesforce/apex/MergeSObject.getRequiredFields';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class MergeSObject extends NavigationMixin(LightningElement)  {
    @api recordId;
    @api objectApiName;
    @api myComponent;
    isChildObjectList = true;
    isIllustration = false;
    isLoading = false;
    isOpportunitySelected = false;
    isShowOpportunityValue = false;
    isDeleteRecord = false;
    isMergeChildObject = false;
    isDisableButton = true;
    rowSpan;
    isReqField = false;
    isFinishButton = false;
    isFinalRecord = false;
    isSkipMerge = false;
    childObjectSelected;
    error;
    createsObjectRecord;
    childObjectList = [];
    opportunityList = [];
    opportunitySelected = [];
    fieldsValueWrapper = [];
    finalMergeRecord = [];
    deleteRecordList = [];
    deletedRecordSelected = [];
    mergeCHildObjectRecords = [];
    selectedRecords = [];
    askingDeletingValues = [];
    reqfieldsList = [];    
    askingDelete = [{ label: 'Delete the merge records', value: 'YESDELETE' }, { label: 'Assign the merge record as a parent record', value: 'YESMERGE' }];
  
    //constructor
    constructor() {
        super();
        const style = document.createElement('style');
        style.innerText = `.slds-form-element__label{
           font-size:1rem;  
        }
      .checkboxClass .slds-form-element__legend .slds-form-element__control{
       display: -webkit-box;
       display: flex !important; 
       }
       .slds-checkbox_faux{
       margin:5px;
       }        
        `
        document.querySelector('head').appendChild(style);
    }

    //wire method for getting child Object
    @wire(getChildObject, { objectName: '$objectApiName' })
    wireGetChildRelationshipName({ error, data }) {
        if (data) {
            this.childObjectList = data;
        } else if (error) {
            this.error = error;
            this.childObjectList = undefined;
        }
    }

    //handle previous button functionality
    handlePrevious() {
        if (this.isOpportunitySelected) {
            this.isOpportunitySelected = false;
            this.isShowOpportunityValue = false;
            this.isFinalRecord = false;
            this.isDeleteRecord = false;
            this.isMergeChildObject = false;
            this.childObjectSelected = null;
            this.isChildObjectList = true;
        } else if (this.isShowOpportunityValue) {
            this.isChildObjectList = false;
            this.isShowOpportunityValue = false;
            this.isFinalRecord = false;
            this.isDeleteRecord = false;
            this.isMergeChildObject = false;
            this.isOpportunitySelected = true;
        }else if (this.isFinalRecord){
            this.isChildObjectList = false;
            this.isMergeChildObject = false;
            this.isDeleteRecord = false;
            this.isOpportunitySelected = false;
            this.isFinalRecord = false;
            this.fieldsValueWrapper = [];        
            this.finalMergeRecord = [];
            this.isReqField = false;
            this.isShowOpportunityValue = true;
        } else if (this.isMergeChildObject) {
            this.isChildObjectList = false;
            this.isMergeChildObject = false;
            this.isDeleteRecord = false;
            this.isOpportunitySelected = false;
            this.isShowOpportunityValue = false;
            this.isFinalRecord = true;
        } else if (this.isDeleteRecord) {
            if(this.isSkipMerge){
                this.isChildObjectList = false;
                this.isShowOpportunityValue = false;
                this.isOpportunitySelected = false;
                this.isDeleteRecord = false;
                this.isMergeChildObject = false;
                this.isFinalRecord = true;
            }else{
            this.isChildObjectList = false;
            this.isShowOpportunityValue = false;
            this.isOpportunitySelected = false;
            this.isDeleteRecord = false;
            this.isFinalRecord = false;
            this.isMergeChildObject = true;
            }
        }
    }
    
    //handle Back button functionality which is drop from noData page to select sObject page
    handleBack(){
        if(this.isIllustration){
         this.isChildObjectList = true;
         this.isIllustration = false;
        }
    }

    //select child sObject functionality
    handleSelectChildObject(event) {
        this.isChildObjectList = false;
        this.childObjectSelected = event.detail.value;
        this.isLoading = true;
        getRequiredFields({objectName : this.childObjectSelected}).then(reqFields =>{
         if(reqFields){
          this.reqfieldsList = reqFields;
          let index = this.reqfieldsList.findIndex(ele => ele == 'Name'); //hard  coded field name
          if (index !== -1) {
              this.reqfieldsList.splice(index, 1);
          }
         }
         
        }).catch(error => {
            this.error = error;
        });
        queryChildRecords({ parentObjectApiName: this.objectApiName, childObjectApiName: this.childObjectSelected, parentRecordId: this.recordId }).then(res => {
            if (res) {
                if (res.length == 0) {
                    this.isLoading = false;
                    this.isIllustration = true;
                    this.isOpportunitySelected = false;

                } else {
                    this.isLoading = false;
                    this.opportunityList = res;
                    this.isIllustration = false;
                    this.isOpportunitySelected = true;
                }
            } else {
                this.isLoading = false;
                this.isIllustration = true;
                this.isOpportunitySelected = false;
            }
        }).catch(error => {
            this.error = error;
        });
    }

    //handle selected sObject value
    handleOpportunity(event) {
        this.opportunitySelected = event.detail.value;
        if (this.opportunitySelected.length > 1) {
            this.isDisableButton = false;
            this.rowSpan = this.opportunitySelected.length; 
        } else {
            this.isDisableButton = true;
        }
    }

    //handle countinue functionality
    handleContinue() {
        this.isLoading = true;
        this.isOpportunitySelected = false;
        this.isDeleteRecord = false;
        this.isMergeChildObject = false;
        this.isChildObjectList = false;
        this.isFinalRecord = false;
        retriveRecordName({ recordIds: this.opportunitySelected }).then(res => {
            if (res) {
                this.selectedRecords = res;
            }
            getsObjectFieldsValues({ sObjectIds: this.opportunitySelected }).then(res => {
                if (res) {
                    this.isLoading = false;
                    this.fieldsValueWrapper = res;
                    if(this.fieldsValueWrapper)
                    this.fieldsValueWrapper = this.fieldsValueWrapper.filter(item => item.fieldApiName !== 'Name');
                    this.isShowOpportunityValue = true;
                    
                }
            }).catch(error => {
                this.error = error;
            });
        }).catch(error => {
            this.error = error;
        });

    }

    //change handler
    changeHandler(event) {
        let findedValue = this.finalMergeRecord.find(element => element.key == event.target.name);
        if (findedValue) {
            findedValue.value = event.target.value;
        } else {
            this.finalMergeRecord.push({ key: event.target.name, value: event.target.value });
        }
        let checkdata = [];
        this.reqfieldsList.forEach(iterateFields =>{
           let findData = this.finalMergeRecord.find(element => element.key == iterateFields);
            if(findData){
                checkdata.push(true);
            }else{
                checkdata.push(false);          
            }         
        })
        if(checkdata.includes(false)){
            this.isReqField = false;    
        }else{
            this.isReqField = true;   
        }

    }

    //handle asking for delete record or not
    handleAsking(event) {
        this.askingDeletingValues = event.detail.value;
        if (this.askingDeletingValues.length == 0) {
            this.isSkipMerge = false;
            this.isFinishButton = true;
        } else if (this.askingDeletingValues.length == 1) {
            if (this.askingDeletingValues[0] == 'YESDELETE') {
                this.isSkipMerge = true;
                this.isFinishButton = false;
            } else if (this.askingDeletingValues[0] == 'YESMERGE') {
                this.isSkipMerge = false;
                this.isFinishButton = false;
            }
        } else {
            this.isSkipMerge = false;
            this.isFinishButton = false;
        }
    }

    //asking for merge sObject value
    askingMergeValues(event) {
        this.askingMergeValues = event.detail.value;
    }


    //check input validation of contact
    isInputValidCon() {
        let isValid = true;
        let inputNameFields = this.template.querySelectorAll('.validateCon');
        inputNameFields.forEach(inputField => {
            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        });
        return isValid;
    }

    //give new record name 
    nameHandler(event) {
        let findedValue = this.finalMergeRecord.find(element => element.key == 'Name'); //hard coded
        if (findedValue) {
            findedValue.value = event.target.value;
        }else{
            this.finalMergeRecord.push({ key: 'Name', value: event.target.value });
        }
    }

    //handle final sObject value
    handlefinalValueSObject() {
        if(this.isReqField){
        this.deleteRecordList = []; 
        this.isLoading = true;
        this.isDeleteRecord = false;
        this.isOpportunitySelected = false;
        this.isChildObjectList = false;
        this.isShowOpportunityValue = false;
        this.createDeleteList();
        if(this.askingDeletingValues.length >= 1){
            this.isFinishButton = false;
        }else{
            this.isFinishButton = true;
        }       
        this.isLoading = false;
        this.isFinalRecord = true;
     }else{
        this.showToast('Error','Please choose the required fields for merging a record','Error');
     }
    }

    //navigate to new record
    navigateToRecordPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.createsObjectRecord['Id'],
                actionName: 'view'
            }
        });
    }

    //handle final record 
    handleFinalRecord() {
        if (this.isInputValidCon()) {
            if (this.isSkipMerge) {
                this.isLoading = true;
                this.isOpportunitySelected = false;
                this.isChildObjectList = false;
                this.isShowOpportunityValue = false;
                this.isFinalRecord = false;
                this.isMergeChildObject = false;
                this.createRecordHandler();
                this.isLoading = false;
                this.showToast('Insert Record ', 'Merge record Succesfully', 'success');
                this.isDeleteRecord = true;

            } else if(this.isSkipMerge == false && this.isFinishButton == false){ //when skipMerge true && finishButton is  true 
                this.isLoading = true;
                this.isDeleteRecord = false;
                this.isOpportunitySelected = false;
                this.isChildObjectList = false;
                this.isShowOpportunityValue = false;
                this.isFinalRecord = false;
                this.createRecordHandler();
                setTimeout(() => {
                    this.mergeChildRecordHandler();
                    this.isLoading = false;
                    this.isMergeChildObject = true;
                    this.showToast('Insert Record ', 'Merge record Succesfully', 'success');
                    this.showToast('Assign Record', 'Merge child Record Succesfully', 'success');

                }, 1000);
            }else{
                this.isLoading = true;
                this.isDeleteRecord = false;
                this.isOpportunitySelected = false;
                this.isChildObjectList = false;
                this.isShowOpportunityValue = false;
                this.isFinalRecord = false;
                this.createRecordHandler();
                setTimeout(() => {
                    this.mergeChildRecordHandler();
                    this.isLoading = false;
                    this.isFinishButton = true;
                    this.isMergeChildObject = true;
                    this.showToast('Insert Record ', 'Merge record Succesfully', 'success');
                    this.showToast('Assign Record', 'Merge child Record Succesfully', 'success');
                }, 1000);   

            }
        } else {
            this.isLoading = false;
            this.isDeleteRecord = false;
            this.isOpportunitySelected = false;
            this.isChildObjectList = false;
            this.isShowOpportunityValue = false;
            this.isMergeChildObject = false;
            this.isFinalRecord = true;
        }
    }

    //create delete record list for deleting records
    createDeleteList(){
        this.opportunitySelected.forEach(eleSelected => {
            this.opportunityList.forEach(ele => {
                if (ele.value == eleSelected) {
                    this.deleteRecordList.push(ele);
                }
            })
        })
    }
     
    //create record handler
    createRecordHandler() {
        createRecord({ objectName: this.childObjectSelected, keyValueList: this.finalMergeRecord }).then(res => {
            if (res) {
                this.createsObjectRecord = res;
            }
        }).catch(error => {
            this.error = error;
        });
    }

    //merge child record handler
    mergeChildRecordHandler() {
        mergeChildRecords({ objectName: this.childObjectSelected, recordIds: this.opportunitySelected, mergeRecordId: this.createsObjectRecord['Id'] }).then(res => {
            if (res) {
                this.mergeCHildObjectRecords = res;
            }
        }).catch(error => {
            this.error = error;
        });
    }

    //handle child sObject record next
    handleNextChildObjectRecord() {
        this.isShowOpportunityValue = false;
        this.isMergeChildObject = false;
        this.isOpportunitySelected = false;
        this.isChildObjectList = false;
        this.isFinalRecord = false;
        this.isDeleteRecord = true;
    }

    //handle delete functionality
    handleDeleted(event) {
        this.deletedRecordSelected = event.detail.value;
    }

    //deleting that records 
    handleDeletedNext() {
        deleteRecord({ recordIds: this.deletedRecordSelected }).then(res => {
            if (this.deletedRecordSelected.length >= 1) {
                this.showToast('Delete Records', 'Deleted Succesfully', 'success');
                this.dispatchEvent(new CloseActionScreenEvent());
            } else {
                this.dispatchEvent(new CloseActionScreenEvent());
            }
        }).catch(error => {
            this.error = error;
        });
    }
    
    //finish that functionality
    handlefinishBtn() {
        if(this.isInputValidCon()){
            if(this.isSkipMerge == false && this.isFinishButton == true){   
                this.createRecordHandler();            
                setTimeout(() => {                    
                    this.showToast('Insert Record ', 'Merge record Succesfully', 'success');
                    this.dispatchEvent(new CloseActionScreenEvent());
                    this.navigateToRecordPage();
                }, 1000);
              
            }else{
            this.dispatchEvent(new CloseActionScreenEvent());
            this.navigateToRecordPage();
            }
        }else{
            this.isLoading = false;
            this.isDeleteRecord = false;
            this.isOpportunitySelected = false;
            this.isChildObjectList = false;
            this.isShowOpportunityValue = false;
            this.isMergeChildObject = false;
            this.isFinalRecord = true;
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