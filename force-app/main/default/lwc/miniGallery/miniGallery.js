import { LightningElement, api, wire, track } from 'lwc';
import getImage from '@salesforce/apex/MiniGallery.getImage';
import getSObjects from '@salesforce/apex/MiniGallery.getSObjects';
import getAllRecords from '@salesforce/apex/MiniGallery.getAllRecords';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import searchRecord from '@salesforce/apex/MiniGallery.searchRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sObjectSearch from '@salesforce/apex/MiniGallery.sObjectSearch';
import avtarImg from '@salesforce/resourceUrl/avtar';

export default class MiniGallery extends LightningElement {
    isLoading = false;
    isGallery = false;
    isPreviewModal = false;
    isCrousel = false;
    isRecordsBox = false;
    isIllustractionTrue = false;
    avtarUrl = avtarImg;
    imageUrl = [];
    sObjectList = [];
    recordList = [];
    slides = [];
    previewUrl;
    @track searchObjValue;
    @track searchRecValue;
    @track recordApi;
    fieldName;
    @track recordId;    
    @api autoScroll = false;
    @api customHeight = '500px';
    @api customWidth = '500px';
    @api hideNavigationButtons = false;
    @api hideNavigationDots = false;
    @api hideSlideNumber = false;
    @api hideSlideText = false;
    @api scrollDuration = 3000;    
    slideIndex = 1;
    timer;

    @wire(getObjectInfo,{objectApiName: '$recordApi'}) objectFieldNameInfo({data,error}){
        if(data){
            console.log('data---->'+JSON.stringify(data.nameFields));
             this.fieldName = data.nameFields[0];
             console.log('FieldName => ', this.fieldName);
        }
    } 
    
    
    //connected call back
    connectedCallback(){
        this.getSObjectsList();
        // if (this.autoScroll) {
        //     this.timer = window.setInterval(() => {
        //         this.handleSlideSelection(this.slideIndex + 1);
        //     }, Number(this.scrollDuration));
        // }
    }
    
    //get All Object
    getSObjectsList(){
        this.sObjectList  = [];
        getSObjects().then(result => { 
            this.sObjectList = result; 
            this.isRecordsBox = false;
        })
    }    

   // search Object
    searchObjHandler(event){
        this.searchObjValue = event.target.value;
        if(this.searchObjValue == null){
            this.isRecordsBox = false;
            this.getSObjectsList();  
        }else{  
            sObjectSearch({searchKey : this.searchObjValue}).then(res=>{
                if(res == null || res == undefined){
                    this.isRecordsBox = false;
                    this.getSObjectsList();  
                }else{
                    this.sObjectList = res;
                }            
            })
        }
    }
           
    //Object Hadler
    objHandler(event){    
        this.recordApi = event.target.dataset.id;  
        this.isGallery = false;  
        this.isIllustractionTrue = true;          
        this.getAllRecordData();        
    }   
    
    //get All record
    getAllRecordData(){
        this.isRecordsBox = false;
        this.recordList = [];
        getAllRecords({objName : this.recordApi, field: this.fieldName}).then(result =>{                     
            this.recordList = result;            
            this.isRecordsBox = true;  
            if(this.recordList.length == 0){
                this.showToast('Not Found','Record Not Found','info');
            }          
        })
    }
    
    //search Records
    searchRecHandler(event){       
        this.searchRecValue = event.target.value;
        if(this.searchRecValue == null){
            this.getAllRecordData();
        }else{
            searchRecord({objName: this.recordApi, searchKey: this.searchRecValue}).then(res =>{
                this.recordList = res;
            })
        }         
    }
        
    //record handler
    recHandler(event){
        this.recordId = event.target.dataset.id;
        let tempArr = [];
        this.isLoading = true;
        getImage({objectId : this.recordId}).then(result=>{
            result.forEach(element => {
                tempArr.push(element);
                this.isIllustractionTrue = false;
            }); 
            if(tempArr.length == 0){
                this.isIllustractionTrue = true;
                this.isGallery = false;
            }
            this.imageUrl = tempArr;
            this.slides = tempArr;   
            this.isGallery = true;  
            this.isLoading = false;          
        }) 
    }
        
    //previewModal handler   
    previewModal(event){
        this.previewUrl = null;
        this.isGallery = false;
        this.isPreviewModal = true;
        this.isCrousel = true;
        this.previewUrl = event.target.dataset.id;       
        const customEvent = new CustomEvent('slidesdata', {
            detail : this.slides
        })
        this.dispatchEvent(customEvent);
    }
    
    //close Modal
    isclosdModal(){
        this.isPreviewModal = false;
        this.isCrousel = false;
        this.isGallery = true;        
        this.previewUrl = null;
    }
    
    //set MaxWidth of Image   
    get maxWidth() {
        return `width: ${this.customWidth};`;
    }
    //set MaxHeight of Image  
    get maxHeight() {
        return `height: ${this.customHeight}; width:100%`;
        
    }
    
    //slides
    @api
    get slidesData() {
        return this.slides;
    }
    
    //slideData for fade features
    set slidesData(data) {
        this.slides = data.map((slide, i) => {            
            if (i === 0) {
                return {
                    ...slide,
                    index: i + 1,
                    slideClass: 'fade slds-show',
                    dotClass: 'dot active'
                };
            }
            return {
                ...slide,
                index: i + 1,
                slideClass: 'fade slds-hide',
                dotClass: 'dot'
            };
        });
    }
    
    // //Mouse Over handler
    // handleMouseOver() {
    //     if (this.autoScroll) {
    //         window.clearInterval(this.timer);
    //     }
    // }
    
    // //Mouse Out Handler
    // handleMouseOut() {
    //     if (this.autoScroll) {
    //         this.timer = window.setInterval(() => {
    //             this.handleSlideSelection(this.slideIndex + 1);
    //         }, Number(this.scrollDuration));
    //     }
    // }
    
    // //disconnectedCallBack
    // disconnectedCallback() {
    //     if (this.autoScroll) {
    //         window.clearInterval(this.timer);
    //     }
    // }
    
    //show Slide Handler
    showSlide(event) {
        const slideIndex = Number(event.target.dataset.id);
        this.handleSlideSelection(slideIndex);
    }
    
    //slideBackWard Handler
    slideBackward() {
        const slideIndex = this.slideIndex - 1;
        this.handleSlideSelection(slideIndex);
    }
    
    //Slide Forward
    slideForward() {
        const slideIndex = this.slideIndex + 1;
        this.handleSlideSelection(slideIndex);
    }
    
    //Slide Selection Handler
    handleSlideSelection(index) {
        if (index > this.slides.length) {
            this.slideIndex = 1;
        } else if (index < 1) {
            this.slideIndex = this.slides.length;
        } else {
            this.slideIndex = index;
        }
        this.slides = this.slides.map((slide) => {
            if (this.slideIndex === slide.index) {
                return {
                    ...slide,
                    slideClass: 'fade slds-show',
                    dotClass: 'dot active'
                };
            }
            return {
                ...slide,
                slideClass: 'fade slds-hide',
                dotClass: 'dot'
            };
        });
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