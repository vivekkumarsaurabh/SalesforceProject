import { LightningElement } from 'lwc';
import logoImage from '@salesforce/resourceUrl/SalonLogoWhite';
import saloIm from '@salesforce/resourceUrl/salonImg';
import hairDesign from '@salesforce/resourceUrl/hairDesign';
import salonSideImg from '@salesforce/resourceUrl/salonSideImg';
import avtarImg from '@salesforce/resourceUrl/avtar';
import insta from '@salesforce/resourceUrl/insta';
import fb from '@salesforce/resourceUrl/fb';
import whatsapp from '@salesforce/resourceUrl/whatsapp';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import retriveAllCategory from '@salesforce/apex/SalonHandler.retriveAllCategory';
import retriveSalonMan from '@salesforce/apex/SalonHandler.retriveSalonMan';
import retriveAllAppoint from '@salesforce/apex/SalonHandler.retriveAllAppoint';
import createAppointment from '@salesforce/apex/SalonHandler.createAppointment';
import insertContact from '@salesforce/apex/SalonHandler.insertContact';
import sendEmail from '@salesforce/apex/SalonHandler.sendEmail';
export default class Salon extends LightningElement {
    isSalonMan = false;
    isDatePicker = false;
    isTimeSlot = false;
    isDateTimeSelect = false;
    isSelectSalonMen = false;
    isHome = true;
    isAppointment = false;
    isBookedNow = false;
    isBookedBtn = false;
    isAboutUs = false;
    isContactUs = false;
    
    logoImg = logoImage;
    salonImage = saloIm;   
    hairDesignBack = hairDesign;
    wp = whatsapp;
    instagram = insta;
    facebook = fb;
    salonSide = salonSideImg;
    avtarUrl = avtarImg;
    
    todayDate;
    salonManId;
    datePicker;
    timePick;
    catId;
    appointmentData = {};
    contactData = {};
    category = [];
    SalonMans = [];
    timeSlot = [];
    selectedSalonMan;
    
    //connected call back for retrive category
    connectedCallback(){
        this.retriveCategory();
      
    }
    
    //retrive category in salon
    retriveCategory(){
        this.category = [];
        retriveAllCategory().then( res=>{       
            this.category = res;
        })
    }
    
    //retrive salon man handler
    retriveAllSalonMan(){
        retriveSalonMan().then(res =>{
            this.SalonMans = res;    
            this.isSelectSalonMen = true;                  
        })
    }
    
    //handle home btn in navigation Bar
    handleHome(event){
        this.isAppointment = false;
        this.isAboutUs = false;
        this.isContactUs = false;
        this.isHome = true;
        this.template.querySelectorAll('.activeness').forEach(element=>{
            element.style.background = 'none';
        })
        event.target.style.background = 'blueviolet';   
    }
    
    //handle Appointment btn in navigation Bar
    handleAppoint(event){  
        this.isHome = false;
        this.isAboutUs = false;        
        this.isContactUs = false;
        this.isAppointment = true;
        this.template.querySelectorAll('.activeness').forEach(element=>{
            element.style.background = 'none';
        })
        event.target.style.background = 'blueviolet';     
    } 
    
    //handle About btn in navigation Bar
    handleAbout(event){
        this.retriveAllSalonMan();
        this.isHome = false;
        this.isAppointment = false;
        this.isContactUs = false; 
        this.isAboutUs = true;           
        this.template.querySelectorAll('.activeness').forEach(element=>{
            element.style.background = 'none';
        })
        event.target.style.background = 'blueviolet';
    }
    
    //handle Contact btn in navigation Bar
    handleContact(event){
        this.isHome = false;
        this.isAppointment = false;
        this.isAboutUs = false;
        this.isContactUs = true;
        this.template.querySelectorAll('.activeness').forEach(element=>{
            element.style.background = 'none';
        })
        event.target.style.background = 'blueviolet';
    }
    
    //handle onclick category 
    handleOnClickBook(event){        
        this.catId = event.currentTarget.dataset.id;
        const date = new Date();
        const year = date.getFullYear();
        const month = date.getMonth() + 1;
        const day = date.getDate();        
        var dateoftoday = year+'-'+month+'-'+day;
        this.todayDate = dateoftoday;
        this.retriveAllSalonMan();
        this.isSalonMan = true; 
        this.isDatePicker = false;
        this.isDateTimeSelect = false;       
    } 
    
    //handle continue Men in modal
    handleCountinueMen(event){        
        this.salonManId  = event.currentTarget.dataset.id;       
        this.isSelectSalonMen = false;
        this.isDatePicker = true;
        this.isDateTimeSelect = false;        
        this.isTimeSlot = false;       
    }
    
    //handle countine in date
    handleCountinueDate(event){
        this.timeSlot = [];
        this.datePicker = event.target.value;
        retriveAllAppoint({salonMan : this.salonManId, datePick : this.datePicker}).then(result => {      
            if(result.length == 0){
                this.showToast('All Booked','Please Select Other SalonMan','success');
            }else{      
                this.timeSlot = result;
                this.isTimeSlot = true;
            }
        })              
    }    
        
    //handler continue date time
    handleCountinueDatePicker(event){
        this.timePick = event.target.value;
        this.isDatePicker = false;
        this.isSelectSalonMen = false;
        this.isTimeSlot = false;
        this.isBookedNow = true;
        this.isDateTimeSelect = true;
    }

    //check input validation of contact
    isInputValidCon(){
        let isValid = true;
        let inputNameFields = this.template.querySelectorAll('.validateCon');
        inputNameFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
            this.contactData[inputField.name] = inputField.value;     
        });
       
        return isValid;
    }

    //handle contact msg
    handleContactMsg(event){
        if(this.isInputValidCon()){
        insertContact({conData : JSON.stringify(this.contactData)}).then(res =>{
            let inputNameFields = this.template.querySelectorAll('.validateCon');
            inputNameFields.forEach(ele=>{
                ele.value = null;
            })
           this.showToast('Contact Submited','We will get in touch soon','success');
        })
    }
    }
    
    //check input validation of appointment
    isInputValid() {
        let isValid = true;
        let inputNameFields = this.template.querySelectorAll('.validate');
        inputNameFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
            this.appointmentData[inputField.name] = inputField.value; 
        });
        return isValid;
    }

    //handle book Now btn 
    handleBokedNow(){
        if(this.isInputValid()){
            this.isBookedBtn = false;
        createAppointment({categoryId : this.catId, salonMan : this.salonManId, appointUserData : JSON.stringify(this.appointmentData), appointDate: this.datePicker, timeSlot : this.timePick})
        .then(res=>{
            if(res == 'This time is not available for more than 1 hour'){
                this.showToast('Booking Cancel !','This time is not available for more than 1 hour','error');             
            }else{                
                sendEmail({userData : JSON.stringify(this.appointmentData), datePick : this.datePicker, timeSl : this.timePick}).then(res=> {
                    this.showToast('Booking Confirm !','Booking Succesfull','success');
                })
                
            }
        })
        this.isDateTimeSelect = false;
        this.isSalonMan = false; 
        this.isAppointment = true;
       }

    }
    
    //handle  back btn in modal
    backSalonManModal(){
        if(this.isDateTimeSelect){
            this.isBookedNow = false;
            this.isDateTimeSelect = false;
            this.isDatePicker = true;
        }else if(this.isDatePicker){
            this.isDatePicker = false;
            this.isSelectSalonMen = true;
        }else if(this.isSelectSalonMen){
            this.isSelectSalonMen = false;
            this.isSalonMan = false;
        }
    }
    
    //handle salon Men 
    handleSalonMan(event){
        this.selectedSalonMan = event.target.dataset.id;
        this.isSalonMan = false; 
    } 
    
    //close modal of salon man
    closeSalonManModal(){
        this.isSalonMan = false;
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


    //map co-ordinates
    mapMarkers = [
        {
            location: {
                Street: '1000 5th Ave',
                City: 'New York',
                State: 'NY',
            },
 
            title: 'Stylish Salon',
            description:
                'Stylish Salon is the standard for exclusive salon .',
        }       
    ];
     
    //map title
    markersTitle = 'Stylish Salon';
    center = {
        location: { Latitude: '28.617059659486664', Longitude: '77.36418125851047' },
    };


}