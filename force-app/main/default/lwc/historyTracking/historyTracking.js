import { LightningElement, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import retriveObjectHistory from '@salesforce/apex/ObjectHistoryTracking.retriveObjectHistory';
import objectIconMethod from '@salesforce/apex/ObjectHistoryTracking.objectIconMethod';
import returnObjectLabelName from '@salesforce/apex/ObjectHistoryTracking.returnObjectLabelName';
const columns = [
    {label:'Date', fieldName:'lastModifyDate', type:'String'},
    {label:'Object Name', fieldName:'objectName', type:'String'},
    {label:'Field Name', fieldName:'fieldName', type:'String'}, 
    {label:'User', fieldName:'userLink', type:'url', typeAttributes: {label: { fieldName: 'userName' }, target: '_blank'}},
    {label:'Old Value', fieldName:'oldValue', type:'String'},
    {label:'New Value', fieldName:'newValue', type:'String'}
];

export default class HistoryTracking extends LightningElement {
objectName;
recordIds;
objLabelName;
rowLimit = 10;
rowOffSet= 0;
records = []; 
columns = columns;
icon;


 //this method is used for currentPageReference for retrive params and retrive data
 @wire(CurrentPageReference)
 getPageReferenceParameters(currentPageReference) {
    if (currentPageReference) { 
         this.objectName  = currentPageReference.state.c__objectName;
         this.recordIds = currentPageReference.state.c__recordId; 
        if(this.objectName != undefined && this.objectName != null){ 
                objectIconMethod({objectName : this.objectName}).then(res => {
                    if(res != null && res != undefined){
                    this.icon = res;
                    }
                }).catch(error => {
                    this.error = error;
                    this.records = undefined;
                }); 
                returnObjectLabelName({objApiName : this.objectName}).then(res => {
                    if(res != undefined && res != null){
                    this.objLabelName = res;
                    console.log('data-----label===>',this.objLabelName);
                    
                    }
                }).catch(error => {
                    this.error = error;
                    this.records = undefined;
                }); 
        }
       this.retriveHistoryData();
    }
 }

 //this method is retrive all data from database
 retriveHistoryData(){
    return retriveObjectHistory({ limitsize: this.rowLimit , offset : this.rowOffSet, objName : this.objectName, recId : this.recordIds})
     .then(result => {
        if(result){
            this.records = [];
            let updatedRecords = [...this.records, ...result]; 
            let data = updatedRecords;
            data.forEach(element => {
                element['userLink'] = '/'+ element.userId; 
            })               
            this.records = data;
            console.log('record=======>',JSON.stringify(this.records));
            
        }  
     })  
     .catch(error => {
         this.error = error;
         this.records = undefined;
     });     
 }

 //this method for load more data on scroll
   loadMoreData(event) {
        const currentRecord = this.records;
        const { target } = event;
        target.isLoading = true;
        this.rowOffSet = this.rowOffSet + this.rowLimit;
        this.retriveHistoryData().then(()=> {               
                target.isLoading = false;
            })
            .catch(error => {
                this.error = error;
                this.records = undefined;
            });           
    }

}