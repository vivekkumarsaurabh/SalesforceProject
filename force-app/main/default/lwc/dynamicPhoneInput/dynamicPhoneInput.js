import { LightningElement, track, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { loadScript } from 'lightning/platformResourceLoader';
import PhoneValidation from '@salesforce/resourceUrl/PhoneValidation';
import getAllCountryInfo from '@salesforce/apex/DynamicPhoneInputWithCountryCode.getAllCountryInfo';
import getAllCountryConfiguration from '@salesforce/apex/DynamicPhoneInputWithCountryCode.getAllCountryConfiguration';
import updateRecordHandle from '@salesforce/apex/DynamicPhoneInputWithCountryCode.updateRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class DynamicPhoneInput extends LightningElement {
    @api recordId;
    @api objectApiName;
    isError = false;
    isDisplay = false;
    isShowField = true;
    @track allCountryInfo = [];
    allcountryCode = [];
    phoneNumber;
    flagImg;
    phoneCode;
    countryNamCode;
    inputFieldError;
    libPhoneNumber;
    // phone = '912332230098';
    phone = '1201987654';

    constructor(){
        super();
        let style = document.createElement('Style');
        style.innerText = `.slds-form-element__label {display:none}; .slds-input{border:none;}`;
        document.querySelector('head').appendChild(style);      
    }

    //connected call back handler
    connectedCallback() {
        this.gettingCoutryWithConfigration();
        this.getAllCountryInformation();    

        loadScript(this, PhoneValidation)

            .then(() => {

                // this.libPhoneNumber = window.libphonenumber; 
                // console.log('libphonenumber------->>>',this.libphonenumber);
                
                // if (window.libphonenumber){
                //     let validateNumber = window.libphonenumber.parsePhoneNumber(phone, 'IN');  
                //     console.log('comming....dcc');

                //  let val = validateNumber.isValid();  

                console.log('comming....');
                // }

                // this.libPhoneNumberJsLoaded = true;
                // this.validatePhoneNumber();
            })
            .catch(error => {
                console.error('Error loading libphonenumber:', error);
            });
    }

    // handle dropdown icon for trigger picklist 
    handleDisplay() {
        this.isDisplay = !this.isDisplay;
    }


    //getting all country behalf on configration using apex
    gettingCoutryWithConfigration() {
        getAllCountryConfiguration().then(countryData => {
            if (countryData) {
                countryData.forEach(ele => {
                    if (ele.CountryAlphaCode__c) {
                        this.allcountryCode.push(ele.CountryAlphaCode__c);
                    }
                })
            }
        })
    }

    //onchange of input number and validate the correct phone number 
    enterInputDataHandler(event) {
        this.phoneNumber = event.detail.value;
        console.log('phone==----->',this.phoneNumber);
        
        this.count = this.phoneNumber.length;
        if (this.validationInput(this.phoneCode, this.phoneNumber, this.countryNamCode)) {
            this.isError = false;
            this.inputFieldError = null;
        } else {
            this.isError = true;
            this.inputFieldError = 'Invalid phone number';
        }
    }

    //get all data when onclick means chosse data from country configration picklist
    getdataHadler(event) {
        this.phoneCode = event.currentTarget.dataset.code;
        this.flagImg = event.currentTarget.dataset.img;
        this.countryNamCode = event.currentTarget.dataset.cntycode;
        this.phoneNumber = null;
        this.isDisplay = false;
    }

    //get all infromation comes from static resource and receive JSON
    getAllCountryInformation() {
        getAllCountryInfo().then(data => {
            if (data) {
                let wholeData = JSON.parse(data);
                wholeData.forEach(ele => {
                    let wholeCode;
                    if (ele.idd.suffixes != null || ele.idd.suffixes != undefined) {
                        wholeCode = ele.idd.root + ele.idd.suffixes[0];
                    } else {
                        wholeCode = ele.idd.root;
                    }
                    if (this.allcountryCode.includes(ele.cca2)) {
                        this.allCountryInfo.push({ name: ele.name.common, code: wholeCode, countryNameCode: ele.cca2, flag: ele.flags.png });
                    }
                })
                this.flagImg = this.allCountryInfo[0].flag;
                this.phoneCode = this.allCountryInfo[0].code;
                this.countryNamCode = this.allCountryInfo[0].countryNameCode;
            }

        })
    }

    //save record in database
    saveRecordHandler() {
        if (this.phoneNumber != null) {
            updateRecordHandle({ sObjectName: this.objectApiName, recordId: this.recordId, phoneNumber: this.phoneNumber }).then(res => {
                if (res) {    
                    console.log('data---->',JSON.stringify(res));
                    let keys = Object.keys(res);
                    if(keys.length == 2){                        
                        // let firstField = keys[0];
                        // let secField = keys[1];
                        // let field = {firstField : this.recordId, secField : this.phoneNumber};
                        
                        updateRecord({ fields: {Id: this.recordId, Phone : this.phoneNumber}}); 

                    }

                    this.showToast('Update Phone Number', 'update phone field sucessfully', 'sucess')
                    this.isShowField = true;
                }
            })
        }
    }

    //saveBUtton trigger 
    saveRecordIndatabase() {
        this.isShowField = false;
    }

    //cancel button trigger
    cancelUpdatePhoneHandler() {
        this.isShowField = true;
    }

    //validate phone input number from static resource window.libphonenumber
    validationInput(code, phoneNumber, countryCode) {
        
        if (code != null && phoneNumber != null) {            
            let wholePhoneNumber = code + phoneNumber;
            let validateNumber;
            console.log('datawhole====>'+wholePhoneNumber);
            
            if(this.count != 1 && this.count != 0){
                validateNumber =  window.libphonenumber.parsePhoneNumber(wholePhoneNumber, countryCode);
            }else{
              return false;
            }
            return validateNumber.isValid();
        }
        return false;
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