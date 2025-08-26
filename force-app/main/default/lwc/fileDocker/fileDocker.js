import { LightningElement, api, wire, track } from 'lwc';
import returnFiles from '@salesforce/apex/FileDocker.returnFiles';
import deleteFile from '@salesforce/apex/FileDocker.deleteFile';
import editFile from '@salesforce/apex/FileDocker.editFile';
import returnFileDetails from '@salesforce/apex/FileDocker.returnFileDetails';
import deleteFileAll from '@salesforce/apex/FileDocker.deleteFileAll';
import {NavigationMixin} from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchKey from '@salesforce/apex/FileDocker.searchKey';

export default class fileDocker extends NavigationMixin(LightningElement) {
    @api recordId;
    isLoading = false;
    illustractionTrue = false;
    isRecordList = false;
    isDeleteModal = false;
    isDeleteAllModal = false;
    isEditModal = false;
    ischeckValue = false;
    isDisabled = true;
    ischeckAll;
    fileDetailsArr = [];  
    trueCheckIdList = [];
    fileId; 
    @track recordIdFile;  
    titleValue;
    descValue;
    createdDate;
    lastModifyDate;
    @track searchValue;
    downloadAllLink;
    
    //search values 
    searchKeys(event){
        this.searchValue = event.target.value;  
        this.recordIdFile = this.recordId;
        if(this.searchValue == undefined || this.searchValue == null){
            this.getRecord();
        }  
    }
    
    //for searching push details into arr
    @wire(searchKey,{searchVal : '$searchValue', recId: '$recordIdFile'}) getFiles({data,error}){        
        if(data){
            let tempArr = [];
            data.forEach(ele=>{
                tempArr.push(ele);
            }) 
            this.fileDetailsArr = tempArr;          
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
    
    //callback method
    connectedCallback(){
        this.getRecord();
    }
    
    //retrive files from database 
    getRecord(){        
        this.isLoading = true;
        let tempArr = [];       
        returnFiles({objectId: this.recordId}).then(result => {
            result.forEach(ele=>{
                tempArr.push(ele);
            })   
            if(tempArr.length == 0){
                this.illustractionTrue = true;
            } 
            this.fileDetailsArr = tempArr;      
            this.isRecordList = true; 
            this.isLoading = false;   
            this.ischeckValue = false; 
            this.trueCheckIdList = [];            
            this.searchValue = null; 
        })  
    }
    
    //preview file method
    previewHandler(event){
        console.log(event.target.dataset.id)
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: event.target.dataset.id
            }
        })
    }
    
    //delete modal opening
    openDeleteModal(event){
        this.isDeleteModal = true;
        this.fileId = event.target.dataset.id;
    }
    
    //delete modal closing
    deleteCancelModal(){
        this.isDeleteModal = false;        
    }
    
    //delete modal handler
    deleteHandler(event){      
        deleteFile({docId: this.fileId}).then(result=>{
            this.isDeleteModal = false;
            this.getRecord();
            this.showToast('Deleted','Deleted Successfully','success');
            
        })
    }
    
    //edit modal opening and set previous values
    openEditModal(event){       
        this.fileId = event.target.dataset.id;
        returnFileDetails({docId: this.fileId}).then(result=>{
            this.titleValue = result.title;
            this.descValue = result.descrip;
            this.createdDate = result.CreatedDate;
            this.lastModifyDate = result.LastModifiedDate;4
        })
        this.isEditModal = true;
    }
    
    //edit modal closing
    editCancelModal(){
        this.isEditModal = false;
    }
    
    //update title
    updatetitle(event){
        this.titleValue = event.target.value;
        
    }
    
    //update description
    updatedesc(event){
        this.descValue = event.target.value;
    }
    
    //editHandler method for editing files details
    editHandler(event){
        editFile({docId: this.fileId, title:  this.titleValue, descrip: this.descValue}).then(result=>{
            this.isEditModal = false;
            this.getRecord();
            this.showToast('Update','Updated Successfully','success');
        })
    }
    
    //check Onclick event fire
    changeCheck(event){  
        if(event.target.checked){           
            this.ischeckValue = true; 
            this.isDisabled = false;                   
        }else{
            this.ischeckValue = false;
            this.isDisabled = true;
        }
    }
    
    //check all values events
    buttonEnable(){
        const checkedList = [];
        this.template.querySelectorAll('.checkBoxCkeck').forEach(element =>{
            if(element.checked){
                checkedList.push(element);
            }else{               
                this.ischeckAll = false;            
            }
            if(checkedList.length >= 2){
                this.isDisabled = false;
            }else{
                this.isDisabled = true;
            }           
        })
    }
    
    //open Delete modal and push documentId in arr for delete selected files;
    openDeleteAllModal(event){
        this.template.querySelectorAll('.checkBoxCkeck').forEach(element =>{
            if(element.checked){
                this.trueCheckIdList.push(element.dataset.id);
            }
        })        
        this.isDeleteAllModal = true;     
    }
    
    //deleteAll modal closing
    deleteAllCancelModal(event){
        this.isDeleteAllModal = false;
    }
    
    //deleteHandler method
    deleteAllHandler(event){
        deleteFileAll({docIds: this.trueCheckIdList}).then(result=>{
            this.isDeleteAllModal = false;
            this.ischeckValue = false;          
            this.getRecord();
            this.showToast('Deleted','Deleted Successfully','success');
        })
    }
    
    //downloadAll method for selected ids and generat link
    downloadAll(event){
        var i = 0;
        this.template.querySelectorAll('.checkBoxCkeck').forEach(element =>{          
            if(element.checked){
                if(i == 0){
                    this.ids='/'+element.dataset.id;
                    i++;
                }else{
                    this.ids+='/'+element.dataset.id;
                }                
            }
        })  
        this.downloadAllLink = '/sfc/servlet.shepherd/document/download'+this.ids;        
        this.getRecord();
        this.showToast('Download','Download Successfully','success');        
    }
    
    //hadleUpload file finished then shows toast 
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        this.showToast('Upload File',uploadedFiles.length+' File Uploaded','success');  
        this.getRecord();
    }
    
    
}