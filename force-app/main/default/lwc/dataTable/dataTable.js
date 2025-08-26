import { LightningElement,track,wire,api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import getAccountList from '@salesforce/apex/DataTable.getAccountList';
import getAccColumn from '@salesforce/apex/DataTable.getAccColumn';
import searchKey from '@salesforce/apex/DataTable.searchKey';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Name from '@salesforce/schema/Account.Name';
import AnnualRevenue from '@salesforce/schema/Account.AnnualRevenue';
import Rating from '@salesforce/schema/Account.Rating';
import Phone from '@salesforce/schema/Account.Phone';
import Website from '@salesforce/schema/Account.Website';
import deleteAcc from '@salesforce/apex/DataTable.deleteAcc';
import updateContacts from '@salesforce/apex/DataTable.updateContacts';
import { notifyRecordUpdateAvailable } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";


export default class DataTable extends NavigationMixin(LightningElement) {    
    // customData = `<table><thead><th>data</th></thead></table>`
    @api recordId;
    @api objectApiName;
    @track columns;    
    @track error;
    @track sortBy;
    @track sortDirection;
    @track searchValue; 
    isLoading = false;  
    isRecord = false;
    isDeleteModal = false;
    isCreateModal = false; 
    blink = false;
    @track isSearchData = false;
    illustractionTrue = false;
    fields = [Name, Rating, AnnualRevenue, Phone, Website];      
    totalRecords = 0; 
    pageSize; 
    totalPages; 
    deleteAccId;
    pageNumber = 1;
    pageSizeOptions = [10, 25, 50, 75, 100]; 
    @track records = [];
    searchData = [];     
    @track recordsToDisplay = [];
    draftValues = [];
    
    //connectedCallback
    connectedCallback(){
        getAccColumn().then(result=>{
            this.columns = result;
            console.log('columnsWrapper---->',JSON.stringify(this.columns));
        })       
        this.getData();    
        // this.template.querySelector(".customdataIN").innerHTML = this.customData;
    }
    
    //Search Input Keys
    searchInputKey(event){
        this.searchValue = event.target.value;              
    } 
    
    //Search  Method
    @wire(searchKey,{searchVal : '$searchValue'}) getFiles({data,error}){               
        if(!data){
            this.isSearchData = false;
            this.isRecord = true;
            this.getData();                
        }else{           
            let tempArr = [];
            let result = JSON.parse(JSON.stringify(data));             
            result.forEach(ele=>{
                ele['accLink'] = '/'+ ele.Id; 
                tempArr.push(ele);
                this.isRecord = false; 
                this.isSearchData = true; 
            })        
            this.searchData = tempArr; 
        }  
    }
    
    //getData from Apex
    getData(){ 
        let tempArr = [];
        this.records = []; 
        this.isLoading = true; 
        setTimeout(() => {
            getAccountList().then(data =>{  
                console.log('data------>'+JSON.stringify(data));                            
                let result = JSON.parse(JSON.stringify(data)); 
                result.forEach(recElement => {
                    recElement['accLink'] = '/'+ recElement.Id; 
                    tempArr.push(recElement); 
                    this.isRecord = true;
                    this.isSearchData = false;      
                });               
                this.records = tempArr;           
                this.isLoading = false; 
                this.totalRecords = this.records.length;                
                this.pageSize = this.pageSizeOptions[0];
                this.paginationHelper();          
            })

          }, 3000);       
       
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
    
    //handle pagination disableFirst button
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    
    //handle pagination disableLast button 
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    
    //handleRecord perPage
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }
    
    //handle previous Page
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
    
    //handleNext Page
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
    
    //handle firstPage
    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }
    
    //handle lastPage
    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    } 
    
    //handle paginationHelper
    paginationHelper() {        
        let recordToDisp = [];
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            recordToDisp.push(this.records[i]);            
        }
        this.recordsToDisplay = [...recordToDisp];
        console.log('recordsToDisplay====-->'+JSON.stringify(this.recordsToDisplay));
    }
    
    
    //sort
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection; 
        this.sortData(this.sortBy, this.sortDirection);
    }
    
    //sorting method
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.records));
        let keyValue = (a) => {
            return a[fieldname];
        };   
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; 
            y = keyValue(y) ? keyValue(y) : '';       
            return isReverse * ((x > y) - (y > x));
        });
        this.records = parseData;
        this.paginationHelper();
    } 
    
    //handle openCreate Modal
    openCreateRecModal(event){
        this.isCreateModal = true;
        this.blink = true;
    }
    
    //handle handleCreateSubmit Modal
    handleCreateSubmit(event){        
        this.isCreateModal = false;       
        this.recordsToDisplay = [];                
        this.getData();         
        this.showToast('Record Inserted','Inserted Successfully','success');        
    }
    
    //handle handleCancelCreate Modal
    handleCancelCreate(event){
        this.isCreateModal = false;
    }
    
    //handle rowAction event
    handleRowAction(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;          
        switch ( actionName ) {
            case 'delete':
            this.deleteAccId = row.Id; 
            this.isDeleteModal = true;
            break;
            case 'edit':
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: row.Id,
                    objectApiName: 'Account',
                    actionName: 'edit'
                }                     
            }); 
            setTimeout(() => {
                this.getData();
            }, 10000);                                  
            break;            
            default:
        }         
    }
    
    //handle delete Cancel Modal
    deleteCancelModal(){
        this.isDeleteModal = false; 
    }
    
    //handle deleteHandler
    deleteHandler(){
        deleteAcc({recId : this.deleteAccId}).then(result =>{
            this.isDeleteModal = false;
            this.getData();    
            this.showToast('Deleted','Deleted Sucessfully','success');           
        })  
        
    }


    async handleSave(event) {
        const updatedFields = event.detail.draftValues;    
        console.log('data--->'+updatedFields);
        console.log('JSON----->',JSON.stringify(updatedFields));
        // Prepare the record IDs for notifyRecordUpdateAvailable()
        const notifyChangeIds = await updatedFields.map(row => { return { "recordId": row.Id } }); 
        console.log('rowId---->'+JSON.stringify(notifyChangeIds));   
        // try {
            // Pass edited fields to the updateContacts Apex controller
            const result = updateContacts({data: JSON.stringify(updatedFields)});
            console.log(JSON.stringify("Apex update result: "+ result));
            this.draftValues = undefined;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contact updated',
                    variant: 'success'
                })
            );    
            // Refresh LDS cache and wires
            notifyRecordUpdateAvailable(notifyChangeIds);   
             
            // Display fresh data in the datatable
            // await refreshApex(this.records);
                // Clear all draft values in the datatable
                this.draftValues = [];
    }
    //    }catch(error) {
    //            this.dispatchEvent(
    //                new ShowToastEvent({
    //                    title: 'Error updating or refreshing records',
    //                    message: error.body.message,
    //                    variant: 'error'
    //                })
    //          );
    // };

    

    

}