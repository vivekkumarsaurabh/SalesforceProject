import { LightningElement } from 'lwc';
import getsObjectWithConfigration from '@salesforce/apex/RollupSummary.getsObjectWithConfigration';
import getFieldIntegrated from '@salesforce/apex/RollupSummary.getFieldIntegrated';
import getChildObject from '@salesforce/apex/RollupSummary.getChildObject';
import createCustomField from '@salesforce/apex/RollupSummary.createCustomField';
import getFieldValue from '@salesforce/apex/RollupSummary.getFieldValue';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class RollupSummary extends LightningElement {
    isSummerize = false;
    isVisible = true;
    isShowOperation = true;
    isError = false;
    isDisplay;
    error;
    errorDiv;
    parentsObject;
    parentRecord;
    childsObject;
    operationType;
    fieldLabel;
    fieldAPIName;
    helpText;
    description;
    childField;
    realValue = [];
    parentsObjectList = [];
    childsObjectList = [];
    childIntegratedFieldList = [];
    operationList = [{ label: "COUNT", value: "COUNT" }, { label: "SUM", value: "SUM" }, { label: "MIN", value: "MIN" }, { label: "MAX", value: "MAX" }];



    //connected call back 
    connectedCallback() {
        this.getallSobject();
    }

    //get all sObject with configration 
    getallSobject() {
        getsObjectWithConfigration().then(sObject => {
            if (sObject) {
                this.parentsObjectList = sObject;
            }
        }).catch(error => {
            this.error = error;
        })
    }

    //sObjectSelectHandler from sObject comboBox
    sObjectSelectHandler(event) {
        this.parentsObject = event.detail.value;
    }
 

    //parent record  handler from select record 
    parentRecordHandler(event) {
        this.parentRecord = event.detail.value;
    }


    //onchange field Label name 
    fieldLabelHandler(event) {
        this.fieldLabel = event.target.value;
    }

    //onchange field Api  name handler
    fieldAPINameHandler(event) {
        this.fieldAPIName = event.target.value;        
    }

    //get child sObject
    childObjectRecordHandle(event) {
        this.childRecord = event.detail.value;
    }

    //operation handler for MIN/MAX/COUNT/SUM
    operationHandler(event) {
        this.operationType = event.target.value;        
        if (this.operationType == 'COUNT') {      
            this.childIntegratedFieldList = [];
            this.getRealValueHandler();
            this.isVisible = true;
        } else {
            this.getAllIntegratedField();
            this.isVisible = false;
        }
    }

    //get description handle
    descriptionHadler(event){
        this.description =event.detail.value;
    }

    //get help text handler
    helpTextHandler(event){
        this.helpText = event.detail.value;
    }


    //get child sObject 
    getAllchildsObject() {
        if (this.parentsObject) {
            getChildObject({ objectName: this.parentsObject}).then(childsObject => {
                if (childsObject) {
                    this.childsObjectList = childsObject;
                }
            })
        }
    }

    //get all Integrated child sobject Field List
    getAllIntegratedField() {
        if (this.childsObject) {
            getFieldIntegrated({childObjectName : this.childsObject}).then(field => {
                if (field) {
                    this.childIntegratedFieldList = field;
                }
            })
        }
    }


    //get select child object
    childObjectRecordHandler(event){
        this.childsObject = event.target.value; 
        if(this.childsObject){
            this.isShowOperation = false;
        }else{
            this.isShowOperation = true;
        }
    }

    //nexthandler in Lwc
    handlerNext() {
        this.getAllchildsObject();
        if(this.parentsObject == null || this.parentsObject == undefined){
            this.isError = true;
             this.errorDiv = 'Please enter correct value';            
        }else if(this.fieldLabel == null || this.fieldAPIName == null){
            this.isError = true;
            this.errorDiv = 'Please enter required field'; 
        }else if(!this.validateFieldApi(this.fieldAPIName)){
            this.isError = true;
            this.errorDiv = 'Please enter valid Field Name without use any spaces and special characters';   
        }else{
            this.isSummerize = true;
            this.errorDiv = null; 
            this.isError = false;  
        }
    }

    //handler previours in lwc
    handlePreviours() {
       if(this.isSummerize == true){        
        this.isSummerize = false;
       }
    }

    //select integrated child field 
    selectChildFieldHandler(event){
      this.childField = event.target.value;
      this.getRealValueHandler();
      
    }

    //get rollup summary value  using apex
    getRealValueHandler(){     
       if(this.parentsObject != null && this.childsObject != null && this.operationType != null && this.parentRecord != null){
            console.log( 'parentsObject--->',this.parentsObject+'    childsObjcrt---->',this.childsObject+'  parentRecord===',this.parentRecord, '   childField------->',this.childField);            
            getFieldValue({parentsObjectName: this.parentsObject, fieldIntegrated: this.childField, childsObjectName: this.childsObject, operation : this.operationType, parentsObjectId : this.parentRecord }).then(value =>{
            if(value){
                this.realValue = value;
                console.log('realValue=====>'+JSON.stringify(this.realValue));                           

            }
        })
    } 
    }


    //create custom field with roll up summary value
    saveHandler(){
        if(this.fieldLabel == null && this.fieldAPIName == null || this.realValue == null){
            this.isError = true;
            this.errorDiv = 'Please enter all required fields';   
        }else{
            this.isError = false;
            this.errorDiv = null;
            if(this.fieldLabel != null && this.fieldAPIName != null && this.realValue != null){            
                let fieldApiforCreateMetadata = `${this.parentsObject}.${this.fieldAPIName}__c`;
            createCustomField({fieldLabelName: this.fieldLabel, fieldApiName: fieldApiforCreateMetadata, description: this.description, helpText : this.helpText, realValueList: JSON.stringify(this.realValue), childsObject : this.childsObject}).then(res =>{
                if(res){
                    this.showToast('Create Roll Up Summary Field', 'Please see in the records and on obect', 'success');                
                }
            })
           }
        }
       
    }

    //validate fieldApiName
    validateFieldApi(fieldApiName) {

        //const apiContains = /^[A-Za-z]+$/;
        const apiContains = /^[A-Za-z_]+$/;
        
        return apiContains.test(fieldApiName);
        
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