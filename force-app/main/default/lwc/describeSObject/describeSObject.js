import { LightningElement, track, wire } from 'lwc';
import getSObjects from '@salesforce/apex/DecribeSObjectHandler.getSObjects';
import returnRecordTypeName from '@salesforce/apex/DecribeSObjectHandler.returnRecordTypeName';
import getLayoutName from '@salesforce/apex/DecribeSObjectHandler.getLayoutName';
import returnlayout from '@salesforce/apex/DecribeSObjectHandler.returnlayout';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DescribeSObject extends LightningElement {
    @track isLoading = false;
    isRecordType = false; 
    isLayout = false;    
    ispageLayoutFields = false;
    isRequired = false;
    @track objName;
    @track recordTypeId;
    @track layoutName; 
    @track layoutInformation;    
    detailsObject = [];
    detailRecordType = [];
    detailsLayout = [];
    activeSections =[];  
  
    constructor(){
        super();
        const style = document.createElement('style');
        style.innerText = `.slds-accordion__summary-heading{height: 0px;}`;
        document.querySelector('head').appendChild(style);
    }
    
    showToast(toastTitle, toastMessage, toastVariant) {    
        const toastEvent = new ShowToastEvent({
            title: toastTitle,
            message: toastMessage,
            variant: toastVariant,
        })
        this.dispatchEvent(toastEvent);
    }
    
    connectedCallback(){ 
        this.isLoading = true;  
        this.detailsObject = [];        
        getSObjects().then(result=>{         
            this.detailsObject = result;           
            this.isLoading = false;                 
        })                
    }  
    
    handleObject(event) {
        this.isRecordType = true; 
        this.isLoading = true; 
        this.objName = event.detail.value;             
        returnRecordTypeName({objectName: this.objName}).then(result => {                  
            if(result == null || result == undefined){
                this.isRecordType = false; 
                this.showToast('Error', 'Record Type not fount', 'Error');
                this.detailRecordType = [];
                this.isLoading = false;  
            }else{
                this.detailRecordType = [];
                this.detailRecordType = result; 
                this.isLoading = false;               
            }            
        })          
        this.isLayout = false;    
        this.ispageLayoutFields = false; 
    }
    
    handleRecordType(event){
        this.recordTypeId = event.detail.value;
        this.isLayout = true; 
        this.isLoading = true; 
        console.log('recordTypeId',this.recordTypeId);
        getLayoutName({recordId:this.recordTypeId}).then(result => {
            this.detailsLayout = [];                                 
            this.detailsLayout = result;
            this.isLoading = false;   
        })  
        this.ispageLayoutFields = false;  
    }
    
    handleLayout(event){   
        this.isLoading = true;  
        this.activeSections =[];
        this.layoutInformation = null;              
        this.layout = event.detail.value;        
        let layoutN = this.objName+'-'+this.layout;
        returnlayout({layoutName:layoutN}).then(result => {  
            result.forEach(element =>{
                this.activeSections.push(element.sectionName);
            })       
            this.layoutInformation = result;
            this.ispageLayoutFields = true; 
            this.isLoading = false;            
        })
    }
}