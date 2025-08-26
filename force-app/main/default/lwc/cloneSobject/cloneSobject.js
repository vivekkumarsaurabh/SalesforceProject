import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getsObjectFieldsValues from '@salesforce/apex/CloneSobject.getsObjectFieldsValues';
import createRecord from '@salesforce/apex/CloneSobject.createRecord';
import sObjectLabelName from '@salesforce/apex/CloneSobject.sObjectLabelName';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class CloneSobject extends NavigationMixin(LightningElement) {

    fieldValueData = [];
    @track requiredFieldList = [];  
    recordId;   
    sObjectName;
    @track sObjectLabelName;


   //get current Reference Page for recordId and SobjectApiName
    @wire(CurrentPageReference) getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
            let objectName = currentPageReference.attributes.apiName.toString().split(".");
            this.sObjectName = objectName[0];
        }
    }

    //connected callback
    connectedCallback(){               
       this.getsObjectFieldInformation();       
       this.getsObjectLabelHandler();
    }

     //navigate to new record
     navigateToRecordPage(newRecordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: newRecordId,
                actionName: 'view'
            }
        });
    }
 
    //getting label name of sObject
    getsObjectLabelHandler(){
        sObjectLabelName({sObjectApiName : this.sObjectName}).then(label =>{
            if(label){
                this.sObjectLabelName = label;
            }
        })
    }

    //get field with their values.
    getsObjectFieldInformation(){
        getsObjectFieldsValues({sObjectIds: this.recordId}).then(data =>{
            if(data){
                this.fieldValueData = data;
                this.fieldValueData.forEach(ele =>{
                    if(ele.reqField){
                         let obj = {label : ele.fieldName, apiName : ele.fieldApiName};
                        this.requiredFieldList.push(obj);                        
                    }
                })                                
            }
        })
    }

    //save Handler
    saveHandler(){
        let nullData = [];
        this.requiredFieldList.forEach(ele =>{
            let data = this.template.querySelector(`.${ele.apiName}`).value;
            if(data){
                this.fieldValueData.find(element => element.fieldApiName == ele.apiName).fieldValue = data;
            }else{
              nullData.push(false);
            }
        })
        let finalData = [];
        this.fieldValueData.forEach(iterateData =>{
            finalData.push({key : iterateData.fieldApiName, value: iterateData.fieldValue});
        })
        if(nullData.length == 0){
            this.createRecordHandler(finalData);
        }else{
            this.showToast('Required Field Missing','fill all required fields','error');
        }
    }

    //creare clone record
   createRecordHandler(finalData){
     createRecord({objectName: this.sObjectName, keyValueList : finalData}).then(res =>{
        if(res){
               console.log('data=====>',JSON.stringify(res));
               if(res.includes('Insert failed')){                
                this.showToast('Insert failed',`${res}`,'error');         
                
               }else{
                let recId = res.match(/(?:^|,)\s*Id=([A-Za-z0-9]+)/)[1];
                this.navigateToRecordPage(recId);
               this.showToast('Clone Sucessfully','Clone Record Successfully','success');          

               }
        }
     })
   }
   

   //close lwc handler
   closeLwcHandler(){
    this.dispatchEvent(new CloseActionScreenEvent());
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