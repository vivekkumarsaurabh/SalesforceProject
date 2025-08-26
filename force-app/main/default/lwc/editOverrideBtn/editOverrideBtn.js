import { LightningElement, wire, api, track } from 'lwc';
import getLayoutName from '@salesforce/apex/DecribeSObjectHandler.getLayoutName';
import returnlayout from '@salesforce/apex/DecribeSObjectHandler.returnlayout';
import getRecordType from '@salesforce/apex/OverrideBtnHandler.getRecordType';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
export default class EditOverrideBtn extends  NavigationMixin(LightningElement) {
    @api objectApiName;
    recTypeId;
    @api recId;
    layoutInformation; 
    recordName;
    rec;
    isModal = true;
    action; 
    recordIdOfRec;
    activeSections =[]; 
    currentPageReference = null; 
    urlStateParameters = null; 

    constructor(){
        super();
        const style = document.createElement('style');
        style.innerText = `.slds-accordion__summary{height: 1px;}`;
        document.querySelector('head').appendChild(style);
    }
    

    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
       if (currentPageReference) {
        this.isModal = false;
        console.log('recId----->',this.recId);
        
         getRecordType({objectName : this.objectApiName, recordId : this.recId}).then(res =>{       
          
            res.forEach(ele =>{
                if(ele.RecordTypeId == undefined || ele.RecordTypeId == null){
                  //  this.recTypeId = ele.RecordTypeId;
                    this.recTypeId = '0125j000000evZ6AAI';
                    this.recordName = ele.Name;
                }else{
                    this.recTypeId = ele.RecordTypeId;
                    this.recordName = ele.Name;
                }               
            })

            getLayoutName({recordId:this.recTypeId}).then(result => {   
                let layoutName;
                 result.forEach(ele =>{
                    layoutName = ele.value;
                 })                              
                 let layoutN = this.objectApiName+'-'+layoutName;
               // let layoutN = 'Account-Account Layout';               
                returnlayout({layoutName:layoutN}).then(result => {  
                    result.forEach(element =>{
                        this.activeSections.push(element.sectionName);
                    })       
                    this.layoutInformation = result;                
                    this.isModal = true;
                }) 
            });
          
            
         })
           
       }
    }

    handleSuccess(event){
      this.recordIdOfRec = event.detail.id;
      this.action = 'edit';
      this.navigateToRecord();
    }

    isclosdModal(){
        this.action = 'cancel';
        this.isModal = false;
        this.navigateToRecord();
    }

    navigateToRecord() {        
        switch ( this.action) {            
        case 'edit':
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordIdOfRec,
                    objectApiName: this.objectApiName,
                    actionName: 'view'
                }                     
        });          
       break;
        case 'cancel':
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recId,
                    objectApiName: this.objectApiName,
                    actionName: 'view'
                }                  
        }); 
        this.isModal = false; 
         break;   
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