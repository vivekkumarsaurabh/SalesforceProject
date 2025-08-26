import { LightningElement, wire, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getLayoutName from '@salesforce/apex/DecribeSObjectHandler.getLayoutName';
import returnlayout from '@salesforce/apex/DecribeSObjectHandler.returnlayout';
import { CurrentPageReference } from 'lightning/navigation';
import getRecordType from '@salesforce/apex/OverrideBtnHandler.getRecordType';
import returnObjectLable from '@salesforce/apex/OverrideBtnHandler.returnObjectLable';
import returnProductMapping from '@salesforce/apex/OverrideBtnHandler.returnProductMapping';
import returnSalesOrder from '@salesforce/apex/OverrideBtnHandler.returnSalesOrder'
export default class OverrideBtn extends NavigationMixin(LightningElement) { 

    @api objectApiName;
    @api recTypeId;    
    @api recId;
    isObjectName = true;
    isModal = true;
    layoutInformation; 
    recordName;
    action; 
    recordIdOfRec;
    objName;
    activeSections = []; 
    currentPageReference = null; 
    availablity;

    checkPatter;
    checkError;
     distibution;
     splant;
     division;
     productId;
     quantity;
    
    constructor(){
        super(); 
        const style = document.createElement('style');
        style.innerText = `.slds-accordion__summary{height: 1px;}`;
        document.querySelector('head').appendChild(style);      
    }
  
    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
       if (currentPageReference ) {
        this.layoutInformation = null;
        this.activeSections = [];
        this.isModal = false;
      
        if(this.recId){
            this.isObjectName = false;
            getRecordType({objectName : this.objectApiName, recordId : this.recId}).then(res =>{           
                res.forEach(ele =>{
                    this.recTypeId = ele.RecordTypeId;
                    this.recordName = ele.Name;
                })
                getLayoutName({recordId:this.recTypeId}).then(result => {   
                    let layoutName;
                     result.forEach(ele =>{
                        layoutName = ele.value;
                     })             
                    let layoutN = this.objectApiName+'-'+layoutName;
                    returnlayout({layoutName:layoutN}).then(result => {  
                        result.forEach(element =>{
                            this.activeSections.push(element.sectionName);
                        })       
                        this.layoutInformation = result;                
                        this.isModal = true;
                    }) 
                });
            })
                                
        }else{ 
        this.isObjectName = true;
        returnObjectLable({objectName : this.objectApiName}).then(res =>{
                this.objName = res;
        }) 
        getLayoutName({recordId:this.recTypeId}).then(result => {   
            let layoutName;
             result.forEach(ele =>{
                layoutName = ele.value;
             })             
            let layoutN = this.objectApiName+'-'+layoutName;
            returnlayout({layoutName:layoutN}).then(result => {  
                result.forEach(element =>{
                    this.activeSections.push(element.sectionName);
                })       
                this.layoutInformation = result;                
                this.isModal = true;
            }) 
        });        
       }
      }
    }
   
    // getRecordTypeNameHandler(objectName, recordId){
    //     getRecordType({objectName : objectName, recordId : recordId}).then(res =>{           
    //         res.forEach(ele =>{
    //             this.recTypeId = ele.RecordTypeId;
    //             this.recordName = ele.Name;
    //         }) 
    //     })
    // }

    dataHandler(event){
        let fieldApiName = event.target.fieldName;   
            
        if(fieldApiName == 'Quantity__c' && this.recId != null && this.recId != undefined){
            console.log('data===>'+this.recId);
            returnSalesOrder({recordId : this.recId}).then(res =>{
                console.log('data==+=++'+JSON.stringify(res));
                console.log(res.Distribution_Channel__c);                
                this.distibution = res.Distribution_Channel__c;
                this.productId = res.Product_Mapping__c;
                this.splant = res.SPlant__c;
                this.division = res.Division__c;
               
            })
            this.quantity = event.detail.value;
        }
      console.log('data==>'+this.distibution+' dataprod===>'+this.productId+' splant==>'+this.splant+' division ==>'+this.division+'  this.qunntity===>'+this.quantity);
     //  let  qunty = event.target.dataset.fil;  
       if(fieldApiName == 'Distribution_Channel__c'){
        this.distibution = event.detail.value;
       }else if(fieldApiName == 'SPlant__c'){
        this.splant = event.detail.value;
       }else if(fieldApiName == 'Division__c'){
        this.division = event.detail.value;
       }else if(fieldApiName == 'Product_Mapping__c'){
        this.productId = JSON.stringify(event.detail.value[0]);
       }else if(fieldApiName == 'Quantity__c'){
        this.quantity = event.detail.value;
       }    
          
       if(this.distibution && this.splant && this.division && this.productId && this.quantity){
        console.log('incomming'+this.distibution+'splan===>'+this.splant+'division===>'+this.division+'productId===>'+this.productId+'quantity===>'+this.quantity);
        returnProductMapping({recordId : this.productId, division: this.division, splant : this.splant, distibution : this.distibution, quantity : this.quantity}).then(res =>{
        
        let inputNameFields = this.template.querySelectorAll('.input');
        inputNameFields.forEach(ele =>{            
            if(ele.fieldName == 'Quantity__c'){
                 if(res.SPlant__c == this.splant && res.Distribution_Channel__c == this.distibution && res.Division__c == this.division){                  
                   if(res.Quantit__c < this.quantity){
                        this.template.querySelector(`[data-error= "${ele.fieldName}"]`).style.display = 'block';
                        this.checkError = true;
                    }else{
                        this.checkError = false;
                        this.template.querySelector(`[data-error= "${ele.fieldName}"]`).style.display = 'none';
                    }
                   // ele.setCustomValidity("Date value is required");                
                 //   ele.reportValidity();
                 // this.checkPatter = `^([1-9]|[1-4][0-9]|${res.Quantit__c})$`;
             
                } 
            }
        })
        })
       }
       
    }

    handleSave(event){
        if(this.checkError){  
            event.stopPropagation();
            event.preventDefault(); 
            this.showToast('Error','Please Enter Valid value in the Fields','error');  
        }else if(!this.checkError){
            this.template.querySelector('lightning-record-edit-form').submit(this.fields);
        }
    }
  
    handleSuccess(event){
      this.recordIdOfRec = event.detail.id; 
      getRecordType({objectName : this.objectApiName, recordId : this.recordIdOfRec}).then(res =>{           
        res.forEach(ele =>{
            this.recTypeId = ele.RecordTypeId;
            this.recordName = ele.Name;
        }) 
        this.action = 'create';
        this.navigateToRecord();
     })   
    }

    isclosdModal(){
        this.action = 'cancel';
        this.isModal = false;
        this.navigateToRecord();
    }

    navigateToRecord() {     
        switch ( this.action) {            
        case 'create':
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordIdOfRec,
                    objectApiName: this.objectApiName,
                    actionName: 'view'
                }                     
        });
        // const anchor = document.createElement('a');
        // anchor.href = `"/${this.recordIdOfRec}"`;
        // anchor.label = `${this.recordName}`;
        this.showToastCreate('Record Created',`Account "{1}" was created.`,'success');        
       break;
        case 'cancel':
            if(this.recordIdOfRec){
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.recId,
                        objectApiName: this.objectApiName,
                        actionName: 'view'
                    }                  
            }); 
            }else{
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: this.objectApiName,
                        actionName: 'list'
                    },
                    state: {       
                        filterName: 'Recent' 
                    }                    
            });
        }            
        this.isModal = false;   
        break;   
       }  
     }

     showToastCreate(toastTitle, toastMessage, toastVariant) {    
        const toastEvent = new ShowToastEvent({
            title: toastTitle,
            message: toastMessage,
            variant: toastVariant,
            messageData: [
                `${this.recordName}`,
                {
                    url: `https://algocirruspvtltd-6d-dev-ed.develop.lightning.force.com/lightning/r/${this.objName}/${this.recordIdOfRec}/view`,
                    label: this.recordName
                }
            ]
        })
        this.dispatchEvent(toastEvent);
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