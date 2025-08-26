import { LightningElement, track} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import 	Name from '@salesforce/schema/Salon_Man__c.Name';
import 	Email from '@salesforce/schema/Salon_Man__c.Email__c';
import 	Phone from '@salesforce/schema/Salon_Man__c.Phone__c';
import 	Password from '@salesforce/schema/Salon_Man__c.Password__c';
import avtarImg from '@salesforce/resourceUrl/avtar'; 
import retriveUserPass from '@salesforce/apex/SalonHandler.retriveUserPass';
import retriveAppointment from '@salesforce/apex/SalonHandler.retriveAppointment';
import deleteAppointment from '@salesforce/apex/SalonHandler.deleteAppointment';
import logoImage from '@salesforce/resourceUrl/SalonLogoWhite';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import retriveContact from '@salesforce/apex/SalonHandler.retriveContact';
import deteleUserContact from '@salesforce/apex/SalonHandler.deteleUserContact';
import dateFilterAppointment from '@salesforce/apex/SalonHandler.dateFilterAppointment';
import countPastAppoitment from '@salesforce/apex/SalonHandler.countPastAppoitment';
import countFutureAppoitment from '@salesforce/apex/SalonHandler.countFutureAppoitment';
import countContact from '@salesforce/apex/SalonHandler.countContact';
import countAppoitment from '@salesforce/apex/SalonHandler.countAppoitment';
import { loadScript } from 'lightning/platformResourceLoader';
import barChartList from '@salesforce/apex/SalonHandler.barChartList';
import ChartJS from '@salesforce/resourceUrl/ChartJS';
import updateStatus from '@salesforce/apex/SalonHandler.updateStatus';
import createUserHandler from '@salesforce/apex/SalonHandler.createUserHandler';
const actions = [{ label: 'Delete', name: 'delete' }];

const COLUMNS = [ 
    {label:'Date', fieldName:'DateSlot__c', type:'date'},
    {label:'Name', fieldName:'Name__c', type:'text'},
    {label:'Phone', fieldName:'Phone__c', type:'phone'},
    {label:'Email', fieldName:'Email__c', type:'email'},   
    {label:'Start time', fieldName:'Time_Slot__c', type:'text'},
    {label:'End time', fieldName:'End_Time__c', type:'text'},
    {label:'Category', fieldName:'catLink', type:'url', typeAttributes: {label: { fieldName: 'catName' }, target: '_blank'}},
    {label:'Status', fieldName:'Appointment_Status__c', type:'text'},
    {   label: 'Action',
    type: 'action',
    initialWidth:'50px',
    typeAttributes: { rowActions: actions },
  
}
]

const COLUMNSCON = [
    {label:'Name', fieldName:'Name', type:'text'},
    {label:'Email', fieldName:'User_Email__c', type:'phone'},
    {label:'Message', fieldName:'User_Message__c', type:'text'},
    {   label: 'Action',
    type: 'action',
    initialWidth:'50px',
    typeAttributes: { rowActions: actions },
} 
]

export default class SalonDashboard extends  NavigationMixin(LightningElement) {
    isLogIn = true;
    isRecord = true;
    isDashBoard = false;
    isDateFilter = true;
    isAppointment = false;
    isDeleteModal = false;
    isContacts = false;
    isDeleteModalContact = false;
    isIllustractionTrue = false;
    isBtnDisable = true;
    isUpdateProfile = false;
    isCreateUserModal = false;
    isMatchPassword = false;

    avtarUrl = avtarImg;  
    logoImg = logoImage;  
    userMail;
    userPass;
    userId;
    UserName;
    createPassword;
    matchPassword;
    correctPass;
    deleteAccId;
    deleteConId;
    datefilter;
    chart;
    pastAppointment;
    futureAppointment;
    totalAppointment;
    totalContact;
    switchMenu;
    @track objectApiName = 'Salon_Man__c';
    userRecordId;
    updatedUserData = {};
    userData = {};
    records = [];
    recordsContact = [];
    statusList = [];
    //bar chart
    xValuesforBar = [];
    yValues = [];
    barColors = [];    
    //pieChart
    xValuesforPie = ['Appointments','Contact'];
    yValuesPie = [];
    ColorsPie = ['#E6A4E6','#F8D594'];
    //donutChart
    xValuesfordonut = ['Completed Appointment','Total Appointment'];
    yValuesdonut = [];
    Colorsdonut = ['#008000','#E6A4E6'];

    columns = COLUMNS;
    columnsContact = COLUMNSCON; 
    @track isChartJsInitialized;  
    
    
           
    //set user email and retrive password
    userEmail(event){
        this.userMail =  event.target.value;
        retriveUserPass({email: this.userMail}).then(res =>{
            this.userId = res.Id;
            this.correctPass = res.password;
            this.UserName = res.Name;
        })
    }   
    
    //password 
    userPassword(event){
        this.userPass = event.target.value;
    }
    
    //handle login 
    handleLogin(event){
        if(this.userPass == this.correctPass){            
            this.isLogIn = false;  
            this.countApp(); 
            this.countCon();
            this.pastApp(); 
            this.futureApp(); 
            this.makeConfigValueBar();
            this.isDashBoard = true;                             
            this.handleHomeDashboard();
            this.showToast('Login Sucessfull','Sucessfull Login','success');
        }else{
            this.showToast('Incorrect Password','Please Enter correct Password','error');
        }
    }

    //config value for bar graph 
    makeConfigValueBar(){
        barChartList({salonManId : this.userId}).then(res => {
          this.xValuesforBar = res.nameWrapperList;
          this.yValues = res.countWrapperList;
          this.barColors = res.colorWrapperList;
        })
    }
    
    //handle  Home button
    handleHomeDashboard(event){ 
        this.isAppointment = false;
        this.isContacts = false;
        this.isHome = true;
        this.template.querySelectorAll('.menuItem').forEach(element=>{
            element.style.background = 'none';          
        })
        event.target.style.background = 'blueviolet';
    }    
    
    //handle appointment button
    handleAppointment(event){
        this.loadData();
        this.isContacts = false;   
        this.isHome = false;          
        this.isIllustractionTrue = false;    
        this.isRecord = true;           
        this.isAppointment = true;        
        this.template.querySelectorAll('.menuItem').forEach(element=>{
            element.style.background = 'none';           
        })
        event.target.style.background = 'blueviolet';
    }
    
    //handle contact button
    handleContact(event){       
        this.contactDataHandler();  
        this.isHome = false;      
        this.isAppointment = false;    
        this.isContacts = true;        
        this.template.querySelectorAll('.menuItem').forEach(element=>{
            element.style.background = 'none'; 
        })
        event.target.style.background = 'blueviolet';
    }

    //handle update profile
    handleUpdateProfile(event){  
        this.template.querySelectorAll('.menuItem').forEach(element=>{
            element.style.background = 'none'; 
        })
        event.target.style.background = 'blueviolet';
        this.isUpdateProfile = true;
    }
     
    //signup button handler
    handleSignUp(event){
        this.isHome = false;      
        this.isAppointment = false;    
        this.isContacts = false; 
        this.isDashBoard = false;
        this.userMail = null;
        this.userPass = null;
        this.isLogIn = true;
        this.template.querySelectorAll('.menuItem').forEach(element=>{
            element.style.background = 'none'; 
        })
        event.target.style.background = 'blueviolet';
    }
    
    //load appointment 
    loadData(){         
        return retriveAppointment({salonManId : this.userId})
        .then(result => {
            let updatedRecords = result;
            this.records = updatedRecords;   
            let data = JSON.parse(JSON.stringify(this.records));
            data.forEach(element => {
                element['catName'] = element.Salon_Categories__r.Name;
                element['catLink'] = '/'+ element.Salon_Categories__c;                
            });        
            this.records = data;
            this.isIllustractionTrue = false;
            this.isAppointment = true;
        })
                  
    }
    
    //contact data handler
    contactDataHandler(){
        return retriveContact().then(res =>{           
            this.recordsContact = res; 
            this.isContacts = true;          
        })
    }
    
    //date fileter handler
    handledateFilter(event){
        if(event.target.value == null || event.target.value == undefined){
            this.handleAppointment();
        }else{
            this.datefilter = event.target.value;
            dateFilterAppointment({dt : this.datefilter, salonManId : this.userId}).then(res=> {
                if(res.length == 0){
                     this.isRecord = false;
                    this.isIllustractionTrue = true;
                }else{
                    this.records = res;
                    this.isAppointment = true;
                    this.isRecord = true;
                    this.isIllustractionTrue = false;
                }
            })
        }
        
    }
        
    //handle rowAction event for appointment
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
                    objectApiName: 'Salon_Appointment__c',
                    actionName: 'edit'
                }                     
            }); 
            setTimeout(() => {
                this.isLoading = true; 
                this.loadData({salonManId : this.userId});              
            }, 8000);                                  
            break;            
            default:
        }       
    }

    //get selected row for appoitnment
    getSelectedRow(event){
            const selectedRows = event.detail.selectedRows;
            if(selectedRows.length == 0){
                this.isBtnDisable = true;
            }else{
                this.isBtnDisable = false;
            }
    }

    // handle status
    handleStatus(){
        var selectedRecords = this.template.querySelector(".dataTableRec").getSelectedRows();  
        selectedRecords.forEach(ele=>{
           this.statusList.push(ele.Id);
        })
        if(this.statusList.length == 0){
            this.showToast('Please Select Rows','Nothing Selected','error');
        }else{
        updateStatus({appointList : this.statusList}).then(res=>{
            var selectedRecordsNull = this.template.querySelector(".dataTableRec").getSelectedRows().checked = false;         
            this.loadData({salonManId : this.userId}); 
            this.showToast('Updated Succesfully','Updated Status Sucessfully','success');
        })
        } 
    }
    
    //handler Row Action Of Contact
    handleRowActionContact(event){
        const actionName = event.detail.action.name;
        if(actionName == 'delete'){
            this.isDeleteModalContact = true;
        }
        this.deleteConId = event.detail.row.Id;
    }
    
    //Delete Appointment Handler
    deleteHandler(){
        deleteAppointment({appointId : this.deleteAccId}).then(res=>{
            this.isDeleteModal = false;
            this.showToast('Delete Sucessfull','Deleted Appointment Succesfully','success');
            this.loadData();
        })
    }
    
    //delete Contact Handler
    deleteContactHandler(){
        deteleUserContact({deleteContId : this.deleteConId}).then(res=>{
            this.isDeleteModalContact = false;
            this.showToast('Delete Sucessfull','Deleted Contact Succesfully','success');
            this.contactDataHandler();
        })
    }

    //delete Cancel Modal
    deleteConCancelModal(){
        this.isDeleteModalContact = false;
    }
    
    //delete Cancel modal of appointment modal
    deleteCancelModal(){
        this.isDeleteModal = false;
    }
      
    //count Appointment
    countApp(){
       countAppoitment({salonManId : this.userId}).then(res=>{  
            if(res == null || res.length == 0 || res == undefined){
                this.totalAppointment = 0;  
            }else{
            this.totalAppointment = res;
            }
            this.yValuesPie.push(res);
            this.yValuesdonut.push(res);
        }) 
    }
    
    //count contact
    countCon(){
        countContact({salonManId : this.userId}).then(res=>{
            if(res == null || res.length == 0 || res == undefined){
                this.totalContact = 0;  
            }else{
            this.totalContact = res;
            }
             this.yValuesPie.push(res);
        })
    }

    //past appointment
    pastApp(){
        countPastAppoitment({salonManId : this.userId}).then(res=>{
            if(res == null || res.length == 0 || res == undefined){
                this.countPastAppoitment = 0;  
            }else{
            this.countPastAppoitment = res;
            }
             this.yValuesdonut.push(this.countPastAppoitment);
        }) 
    }

    //future appointment
    futureApp(){
        countFutureAppoitment({salonManId : this.userId}).then(res=>{
            if(res == null || res.length == 0 || res == undefined){
                this.futureAppointment = 0;  
            }else{
            this.futureAppointment = res;
            }
        }) 
    }
    
    //render call back
    renderedCallback(){  
        this.makeBarChartJs();
        this.makeDonoutChartJs();
        this.makePieChartJs();
    }

    createUserHandler(){
        this.isCorrectPassword = false;
        this.isMatchPassword = false;
        this.isCreateUserModal = true;       
    }

    passwordHandle(event){
        this.createPassword = event.detail.value;
    }
    matchPasswordHandler(event){
        this.matchPassword = event.detail.value;
        if(this.createPassword == this.matchPassword){
        this.isMatchPassword = false;
        this.isCorrectPassword = true;
        }else{
        this.isCorrectPassword = false;
        this.isMatchPassword = true;
        }
    }
    
     isInputValidationUserHandler(){
        let isValid = true;
        let inputNameFields = this.template.querySelectorAll('.validate');
        inputNameFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
            this.userData[inputField.name] = inputField.value;     
        });
        return isValid;
     }

    handleCreateSubmit(){
    if(this.isInputValidationUserHandler() && this.createPassword == this.matchPassword){
        this.isLoading = true;   
        createUserHandler({user : JSON.stringify(this.userData)}).then(res =>{
            this.isLoading = false;                  
            this.isCreateUserModal = false;
            this.showToast('User Created','User Created Successfully','success'); 
        })
    } 
    }

    handleCancelCreate(){
        this.isCreateUserModal = false;
    }

    updateCancelHandler(){
     this.isUpdateProfile = false;
    }

    updateProfileHandler(){
    this.isUpdateProfile = false;
    this.handleHomeDashboard();
    this.showToast('User Updated','User Updated Successfully','success'); 

    }
    
    

    //bar chart
    makeBarChartJs(){
        this.isChartJsInitialized = true;  
        const temp = this.template.querySelector('.barChart');
        if(temp){
            Promise.all([
                loadScript(this, ChartJS)
            ]).then(() => {
              let  configNew = {
                    type: "bar",
                    data: {
                        labels: this.xValuesforBar,
                        datasets: [{
                            label: 'dataset',
                            backgroundColor: this.barColors,
                            data: this.yValues
                        }]
                    },
                    options: {
                        title: {
                            display: true
                        },
                        legend: {
                            display: false
                         }
                    }
                }
                const temp = this.template.querySelector('.barChart').getContext( "2d" );
                this.chart = new window.Chart(temp, configNew); 
                this.chart.canvas.parentNode.style.height = '100%';
                this.chart.canvas.parentNode.style.width = '100%';
             
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading ChartJS',
                        message: error.message,
                        variant: 'error',
                    }),
                    );
                });
            }       
    }

    //make donout chart
    makeDonoutChartJs(){
        this.isChartJsInitialized = true;  
        const temp =  this.template.querySelector('.doughnutChart');        
        if(temp){
            Promise.all([
                loadScript(this, ChartJS)
            ]).then(() => {
              let  configNew = {
                    type: "doughnut",
                    data: {
                        labels: this.xValuesfordonut,
                        datasets: [{
                            label: 'dataset',
                            backgroundColor: this.Colorsdonut,
                            data: this.yValuesdonut
                        }]
                    },
                    options: {
                        title: {
                            display: true                            
                        }
                    }
                }
                const temp = this.template.querySelector('.doughnutChart').getContext( "2d" );
                this.chart = new window.Chart(temp, configNew); 
                this.chart.canvas.parentNode.style.height = '100%';
                this.chart.canvas.parentNode.style.width = '100%';
             
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading ChartJS',
                        message: error.message,
                        variant: 'error',
                    }),
                    );
                });
            }       
    }

    //make pie chart
    makePieChartJs(){
        this.isChartJsInitialized = true;      
        const temp =  this.template.querySelector('.piechart');        
        if(temp){
            Promise.all([
                loadScript(this, ChartJS)
            ]).then(() => {
              let  configNew = {
                    type: "pie",
                    data: {
                        labels: this.xValuesforPie,
                        datasets: [{
                            label: 'dataset',
                            backgroundColor: this.ColorsPie,
                            data: this.yValuesPie
                        }]
                    },
                    options: {
                        title: {
                            display: true
                        }
                    }
                }
                const temp = this.template.querySelector('.piechart').getContext( "2d" );
                this.chart = new window.Chart(temp, configNew); 
                this.chart.canvas.parentNode.style.height = '100%';
                this.chart.canvas.parentNode.style.width = '100%';
             
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading ChartJS',
                        message: error.message,
                        variant: 'error',
                    }),
                    );
                });
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
    
}