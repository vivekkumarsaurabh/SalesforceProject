import { LightningElement, api, wire, track } from 'lwc';
import retriveRecord from '@salesforce/apex/RetriveAccRecord.retriveRecord';
import deleteData from '@salesforce/apex/RetriveAccRecord.deleteData';
import insertData from '@salesforce/apex/RetriveAccRecord.insertData';
import retriveData from '@salesforce/apex/RetriveAccRecord.retriveData';
import updateData from '@salesforce/apex/RetriveAccRecord.updateData';
import deleteBulkData from '@salesforce/apex/RetriveAccRecord.deleteBulkData';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class WireComponent extends LightningElement {
    name ='';
    phone = '';
    lastNameRec = '';
    phoneRec = ''; 
    nameRec = '';
    phoneRec = '';
    contactArrData;
    isCheck = false;
    isCheckData = true;
    recodId = '';
    recordId;   // get a record Id  
    contRecArr = []; //records array of contact
    delcurrentRecId = '';
    trueValue = false; //noData Visible 
    @track isInsertModal = false;
    @track isUpdateModal = false;
    @track isDeleteModal = false;
    @track isDeleteAllModal = false;
    @track isViewModal = false;
    @track checkBox = false;
    checkValue;  
    isDisabled = true;
    trueCheckIdList = [];
    toastView = false;
    
    
    showToast(toastTitle, toastMessage, toastVariant) {
        const toastEvent = new ShowToastEvent({
            title: toastTitle,
            message: toastMessage,
            variant: toastVariant,
        })
        this.dispatchEvent(toastEvent);
    }
    
    
    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
        if (currentPageReference) {
            console.log(currentPageReference);
            this.recordId = currentPageReference.state.recordId || null;
        }
    }
    
    //connected callback
    connectedCallback(){
        console.log('This is RecordId', this.recordId);
        this.getRecords();
    }
    
    //retrive data from database
    getRecords(){
        retriveRecord({accId: this.recordId})
        .then(data => {
            this.contRecArr = [];
            let contRecJson = JSON.parse(JSON.stringify(data)); 
            contRecJson.forEach(recElement =>{
                recElement['recordLink'] = '/'+ recElement.Id;
                this.contRecArr.push(recElement);
            })
            if(this.contRecArr.length == 0) {
                this.trueValue = true;
            }
            this.isDisabled = true;
            this.isCheck = true;
            this.trueValue = false;
        })
        .catch(error => {
            console.log(error);
        })     
    }
    
    //bulk button Enabled 
    buttonEnable(){
        let checkedList = [];
        this.template.querySelectorAll('.input1').forEach(element =>{
            if(element.checked){
                checkedList.push(element);
            }
            if(checkedList.length >= 2){
                this.isDisabled = false;
            }else{
                this.isDisabled = true;
            }
        })
    }
    
    changeCheck(event){
        if(event.target.checked){            
            this.checkValue = true; 
            this.isDisabled = false;            
        }else{
            this.checkValue = false;
            this.isDisabled = true;
        }
    }
    
    openDeleteAllModal(){
        this.template.querySelectorAll('.input1').forEach(element =>{
            if(element.checked){
                this.trueCheckIdList.push(element.dataset.id);
            }
        })
        
        this.isDeleteAllModal = true;
        this.isCheck = false;        
    }
    
    deleteAllModal(){
        this.isDeleteAllModal = false;
        this.isDisabled = true;
        this.isCheck = true; 
        
    }
    
    //Bulk delete data in database  
    deleteAll(){ 
        deleteBulkData({recIdList : this.trueCheckIdList});s        
        setTimeout(() => { console.log('World!'); }, 10000);
        this.showToast('Record Updated','Deleted Records Sucessfully', 'success');    
        this.getRecords();
        this.isDeleteAllModal = false;
    }
    
    //insert Modal fill values
    insertName(event){
        this.name = event.target.value;        
    }
    
    insertPhone(event){
        this.phone = event.target.value;
    }   
    
    //handle Update Modal  fill the data in variables
    updateModal(event) {       
        let recordId = event.target.dataset.id;        
        retriveData({recId:recordId})
        .then(result=>{      
            console.log('result--> ',result);           
            this.lastNameRec = result.LastName;            
            this.phoneRec = result.Phone;
            this.recodId = result.Id;
            this.isUpdateModal = true;   
            
        })
        .catch(error=>{
            console.log('error--> ',result);
        })
        this.isCheck = false;
    }    
    
    closeUpdateModal(){
        this.isUpdateModal = false;
        this.isCheck = true;
    }
    
    openInsertModal() {
        this.isInsertModal = true;
        this.isCheck = false;
    }
    
    closeInsertModal() {
        this.isInsertModal = false;
        this.isCheck = true;
    }    
    
    //insert data in database
    insertRec(event) {  
        let parentId = event.target.dataset.id;      
        insertData({parentRecId : parentId, conName : this.name, conPhone : this.phone}).then(result=>{
            console.log('sucessfully Inserted',result);
            this.getRecords();          
        })      
        this.showToast('Record Inserted',this.name+' Inserted Sucessfully', 'success');
        this.isInsertModal = false;
    }    
    
    // handle Update Record
    updateLastName(event){
        this.lastNameRec = event.target.value;     
    } 
    
    updatePhone(event){
        this.phoneRec = event.target.value;
    }    
    
    //update Data in database
    updateRec(event){ 
        updateData({recId : this.recodId, conName: this.lastNameRec, conPhone : this.phoneRec}).then(result=>{
            console.log('update Record successfully');
            this.getRecords();
            var link = '<a href="+/{$recodId}">{this.lastNameRec}</a>'
            this.showToast('Record Updated',this.lastNameRec+' Updated Sucessfully', 'success');
        })
        this.isUpdateModal = false;        
    }
    
    //handle delete Modal    
    openDeleteModal(event){
        this.delcurrentRecId = event.target.dataset.id;
        this.isCheck = false;
        this.isDeleteModal = true;
    }   
    
    deleteModal(){
        this.isDeleteModal = false; 
        this.isCheck = true;
    }
    
    deleteRec(event){  
        deleteData({recId:this.delcurrentRecId}).then(result=>{
            console.log('sucessfully Deleted',result);
            this.getRecords();   
            this.showToast('Record Updated','Deleted Record Sucessfully', 'success');
        })              
        this.isDeleteModal = false;              
    } 
    
    
    // View Data Modal and retrive data
    viewModal(event){
        let recordId = event.target.dataset.id; 
        retriveData({recId:recordId})
        .then(result=>{           
            this.nameRec = result.LastName;            
            this.phoneRec = result.Phone;             
            this.isViewModal = true;
        })
        .catch(error=>{
            console.log('error--> ',result);
        })
        
        this.isCheck = false;
    }
    
    viewCancelModal(){
        this.isViewModal = false;
        this.isCheck = true;
        
    }
    
    // retrive data from Database 
    /** @wire(retriveRecord,{accId: '$recordId'}) contacts({data,error}){
        if(data){
            let contRecJson = JSON.parse(JSON.stringify(data)); 
            contRecJson.forEach(recElement =>{
                recElement['recordLink'] = '/'+recElement.Id;
                this.contRecArr.push(recElement);
            })
            this.isCheck = true;
        }else{
            console.log(error);
        }       
    }  **/
    
    
    
}