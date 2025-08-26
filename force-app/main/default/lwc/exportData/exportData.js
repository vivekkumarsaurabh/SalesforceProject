import {LightningElement} from 'lwc';
import getsObjectWithConfigration from '@salesforce/apex/DataExpoter.getsObjectWithConfigration';
import getAllData from '@salesforce/apex/DataExpoter.getAllData';
import getAllfields from '@salesforce/apex/DataExpoter.getAllfields';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ExportData extends LightningElement{
    isDisable = true;
    isBtn = false;
    error;     
    parentsObject;
    parentsObjectList;
    csvDatas = [];
    columnHeader = [];
    fieldSelectList = [];

    //get combobox value
    get getcomboBoxValue(){
        return this.parentsObject;
    }
    
    //get the fieldSelectLsit value
    get getAllSelectedList(){
        return [...this.fieldSelectList];
    }
     
    //custructor for inline style
    constructor(){
        super();
        let element = document.createElement('Style');
        element.innerHTML = `.checkboxClass .slds-form-element__control{ display: -webkit-box;  display: flex;}  .checkboxClass .slds-form-element__control .slds-checkbox{margin:0px 5px;}`;
        document.head.appendChild(element);
    }

    //connected call back
    connectedCallback(){
         this.getsObejctConfigration();
       
    }

    // getting all sobject
    getsObejctConfigration(){
        getsObjectWithConfigration().then(sObjectData =>{
            if(sObjectData){
                this.parentsObjectList  = sObjectData;
            }
           }).catch(error => {
            this.error = error;
        }) 
    }

    //get select all field 
    getAllFieldSelect(){ 
           if(this.columnHeader.length > 0){
            this.columnHeader.forEach(ele =>{
                this.fieldSelectList.push(ele.value);
            })
           } 
           if(this.fieldSelectList.length > 0){
            this.isDisable = false;
            this.isBtn = true;
          }else{
            this.isBtn = false;
            this.isDisable = true;
          }
          
    }

    //getting all fields
    getAllfieldHandler(){
        if(this.parentsObject){
        getAllfields({sobjectName : this.parentsObject
        }).then(data => {
            if(data){                
                this.columnHeader = data;
            }
        }).catch(error =>{
            this.error = error;
        })
       }
    }

    //sObject Select handler
    sObjectSelectHandler(event){
     this.parentsObject = event.target.value;
     if(this.parentsObject != null){
        this.getAllfieldHandler();
     } 
    }

    //get all data from apex
    getAllDataHandler(){  
        if(this.parentsObject != null && this.fieldSelectList.length > 0){
        getAllData({sobjectName : this.parentsObject}).then(csvdata =>{
           if(csvdata){
            this.csvDatas = csvdata;                   
              this.exportContactData();         
           }
        }).catch(error => {
            this.error = error;
        }) 
      }
    }

    //select field handler
    fieldSelecthandler(event){
      this.fieldSelectList = event.target.value;
      if(this.fieldSelectList.length > 0){
        this.isDisable = false;
        this.isBtn = true;
      }else{
        this.isDisable = true;
        this.isBtn = false;
      }
    }

    //get all field deselect
    getAllFieldDeselect(){
      if(this.fieldSelectList.length > 0){
        this.isDisable = true;
        this.isBtn = false;
        this.fieldSelectList = [];        
      }
    }


    //export and download in csv
    exportContactData(){
        let doc = '<table>';
        doc += '<style>';
        doc += 'table, th, td { border: 1px solid black; border-collapse: collapse;} th{background-color: aqua;}';            
        doc += '</style>';
        // Add all the Table Headers
        doc += '<tr>';
        this.fieldSelectList.forEach(element => {    
            let getLabel = this.columnHeader.find(ele => ele.value == element);     
            doc += '<th>'+ getLabel.label +'</th>';           
        });
        doc += '</tr>';        
        // Add the data rows
        this.csvDatas.forEach(record => {            
            doc += '<tr>';        
            this.fieldSelectList.forEach(iterateField =>{                                
                doc +='<td>'+record[iterateField]+'</td>';
            })
            doc += '</tr>';
        });
        doc += '</table>';
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        downloadElement.download = `${this.parentsObject}.xls`;
        document.body.appendChild(downloadElement);
        downloadElement.click();       
        this.isDisable = true;
        this.isBtn = false;
        this.fieldSelectList = [];
        this.parentsObject = null;
        this.showToast('Export Sucessfully',`Export data ${this.parentsObject} Sucessfully`,'success');
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