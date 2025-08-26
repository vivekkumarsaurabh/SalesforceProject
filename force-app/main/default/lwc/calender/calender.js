import { LightningElement, track } from 'lwc';
import 	Name from '@salesforce/schema/Attendence_User__c.Name'
import returnHolidays from '@salesforce/apex/Calender.returnHolidays';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import attendenceUser from '@salesforce/apex/Calender.attendenceUser';
import retriveData from '@salesforce/apex/Calender.retriveData';
import createRecord from '@salesforce/apex/Calender.createRecord';
import returnAttendenceWrapper from '@salesforce/apex/Calender.returnAttendenceWrapper';
import deleteData from '@salesforce/apex/Calender.deleteData';
import { loadScript } from 'lightning/platformResourceLoader';
import ChartJS from '@salesforce/resourceUrl/ChartJS';
//import chartData from '@salesforce/apex/Calender.chartData';
export default class Calender extends LightningElement {      
    isCalender = true;
    isAttendence = false;
    isUserAttendence = false;
    isCreateModal = false; 
    isLoading = false;
    isBtnHide = false;
    isShowChart = false;
    @track isChartJsInitialized;
    chart;
    date;
    week;
    dateToday = new Date().toJSON().slice(0,10);
    @track holidayMap = new Map();
    objectToMap = obj => new Map(Object.entries(obj)); //object Map
    @track vacations = [];
    @track currentMonth;
    @track currentYear; 
    @track daysArr = []; 
    users = [];
    checkedList = [];
    attendenceData = [];
    @track objectApiName = 'Attendence_User__c';
    fields = [Name];   
    monthAtend = new Date().getMonth();
    attendence = [];
    items = []; 
    userId;
    xValues = ['Half Day','Present', 'Absent', 'SickLeave', 'FloaterLeave'];
    @track yValues = [];
    barColors = ['#E6A4E6','#008000','#F8D594','#99D0CE','#F8C194'];    
    @track chartValue = 'bar';
    isNotClose = false;

    constructor(){
        super();
        const style = document.createElement('style');
        style.innerText = `.slds-radio{display: inline-block !important;}`;
        document.querySelector('head').appendChild(style);
    }

    //connected call Back
    connectedCallback(){
        this.holiday();  
        this.monthAtend = 0;
        let days = this.daysInMonth(this.monthAtend, 2024);       
        this.makeDays(days);
        this.handleAttendence();
        
    }
    
    //holiday function
    holiday(){
        returnHolidays().then(result => {
            this.holidayMap = this.objectToMap(result);
            this.todayDate();                       
        })  
    }
    
    // today date
    todayDate(){
        let currentDate = new Date();
        this.week =  currentDate.toLocaleString('en-us', {weekday: 'long'});
        let month = currentDate.toLocaleString('en-us', { month: 'long'})
        let day =  currentDate.toString().slice(8,10);
        this.date = month+' '+day;
        this.currentMonth = currentDate.getMonth();
        this.currentYear = currentDate.getFullYear();
        this.generateCalendar(this.currentMonth, this.currentYear);      
    } 
    
    //days in Month
    daysInMonth(month, year){  
        return 32-new Date(year,month,32).getDate(); 
    }
    
    //generate a Calender
    generateCalendar = (month, year) => {                
        let firstDay = (new Date(year, month)).getDay();
        let today = new Date();
        let tbl = this.template.querySelector(".calendar-days");
        tbl.innerHTML = "";
        this.vacations = [];
        let cell;
        let para;
        let cellText;
        let date = 1;
        let monthYearKey = `${year}-${month}`;    
        for (let i = 0; i < 6; i++) {
            let row = document.createElement("tr");
            row.style.lineHeight = "4rem";
            for (let j = 0; j < 7; j++){
                if (i === 0 && j < firstDay) {
                    cell = document.createElement("td");
                    cellText = document.createTextNode("");                    
                    cell.appendChild(cellText);
                    row.appendChild(cell);
                }
                else if (date > this.daysInMonth(month, year)) { 
                    break;
                }                
                else {            
                    cell = document.createElement("td");
                    para = document.createElement("span"); 
                    cellText = document.createTextNode(date);
                    cell.appendChild(para);
                    para.appendChild(cellText);
                    para.style.fontSize = "1.5rem";
                    para.style.fontWeight = "500";    
                    if(date === today.getDate() && year === today.getFullYear() && month === today.getMonth()) {
                        para.style.backgroundColor = "rgb(231, 74, 105)";
                        para.style.borderRadius = "50%";
                        para.style.padding = "5px";
                        para.style.color = "#fff";
                    }                   
                    if(this.holidayMap.has(monthYearKey)){
                        this.vacations = this.holidayMap.get(monthYearKey);
                        this.vacations.forEach(ele=>{
                            if(date == ele.dateHoliday){
                                para.style.color = "rgb(231, 74, 105)";
                            }                            
                        })                      
                    }                       
                    row.appendChild(cell);                    
                    date++;
                }  
            }
            tbl.appendChild(row); 
        }
    }
    
    //calender tab open
    calenderHandler(){
        this.holiday(); 
        this.isAttendence = false;
        this.isUserAttendence = false;
        this.isCalender = true;  
    }
    
    //attendence tab open
    attendenceHandler(){
        this.isCalender = false;
        this.isUserAttendence = false;
        this.isAttendence = true; 
        this.monthAtend = 0;
        let days = this.daysInMonth(this.monthAtend, 2024);       
        this.makeDays(days);
        this.handleAttendence();   
    }    
    
    //previous btn Handler
    prevCalHandler(){
        this.currentYear = (this.currentMonth === 0) ? this.currentYear - 1 : this.currentYear;
        this.currentMonth = (this.currentMonth === 0) ? 11 : this.currentMonth - 1;        
        this.generateCalendar(this.currentMonth, this.currentYear);       
    }
    
    //next btn Handler
    nextCalHandler(){
        this.currentYear = (this.currentMonth === 11) ? this.currentYear + 1 : this.currentYear;
        this.currentMonth = (this.currentMonth + 1) % 12;
        this.generateCalendar(this.currentMonth, this.currentYear);
    }
    
    
    //year comboBox values
    get years() {
        return [
            { label: '2021', value: '2021' },
            { label: '2022', value: '2022' },
            { label: '2023', value: '2023' },
            { label: '2024', value: '2024' },
            { label: '2025', value: '2025' },
            { label: '2026', value: '2026' }
        ];
    }
    //month comboBox Values
    get month_names() {
        return [
            { label: 'Jan', value: '0' },
            { label: 'Feb', value: '1' },
            { label: 'Mar', value: '2' },
            { label: 'Apr', value: '3' },
            { label: 'May', value: '4' },
            { label: 'Jun', value: '5' },
            { label: 'Jul', value: '6' },
            { label: 'Aug', value: '7' },
            { label: 'Sep', value: '8' },
            { label: 'Oct', value: '9' },
            { label: 'Nov', value: '10' },
            { label: 'Dec', value: '11' }  
        ];
    }

    //handle Year in Calender
    handleYear(event){
        this.currentYear = event.detail.value;
        this.generateCalendar(this.currentMonth, this.currentYear);
    }
    //handle Month in Calender
    handleMonth(event){
        this.currentMonth = event.detail.value;
        this.generateCalendar(this.currentMonth, this.currentYear);
    }
    //handle Days in Attendence
    handleDaysInMonth(event){
        this.monthAtend = event.detail.value;
        let days = this.daysInMonth(this.monthAtend, 2024);
        this.makeDays(days);        
    }
    //create Days in Month
    makeDays = (days) =>{
        this.daysArr = [];
        this.items =  [];
        for(let i=1; i<=days; i++){
            let weekend = new Date(2024, this.monthAtend,i).getDay();
            if(weekend === 0 || weekend === 6 ){
                this.items.push(i);
                continue;
            }else{        
                this.daysArr.push(i);
            }
        }
        this.returnData();
    }
    
    //handle User
    handleUser(){
        this.isCalender = false;
        this.isAttendence = false;
        this.isUserAttendence = true;
    }
    
    //habdle Create Modal
    handleCreateModal(){
        this.isCreateModal = true;
    }
   
    //handle submit 
    handleCreateSubmit(event){        
        this.isLoading = true;
        setTimeout(() => {
            this.fetchUsers();
        }, 5000);        
        this.isCreateModal = false;
        this.showToast('Record Inserted','Inserted Successfully','success'); 
    }
    
    //handle Cancel
    handleCancelCreate(){
        this.isCreateModal = false;
    }
    
    //fetch User 
    fetchUsers(){
        this.users = [];
        this.attendenceData  = [];
        attendenceUser({createDate : this.dateToday}).then(result =>{
            this.attendenceData  = [];
            this.users = result;  
            this.isBtnHide = true;          
        })
        this.isLoading = false;
    }
    
    //handle today date
    handleDatePicker(event){
        this.dateToday = event.target.value;
        this.handleAttendence();        
    }
    
    //handle attendence 
    handleAttendence(){
        this.attendenceData = [];
        retriveData({dt : this.dateToday}).then(result =>{            
            if(result.length != 0){
                this.users = [];
                this.isBtnHide = false;   
                this.attendenceData = result; 
            }else{ 
                this.fetchUsers();
            }                
        }) 
    }
    
    //handle CheckBox Click function
    handleCheckBox(event){        
        let ans = event.target.checked;
        let targetId = event.target.dataset.id;  
        this.template.querySelectorAll(`[data-id="${targetId}"]`).forEach(element =>{
            element.checked = false;
        })
        event.target.checked = ans;
        if(this.checkedList.length != 0){
            let tempArr = [];
            let found = 0;
            tempArr = this.checkedList;
            for(let k=0; k<tempArr.length; k++){
                const val =  tempArr[k].split("-"); 
                if(event.target.dataset.id === val[0]){
                    tempArr.splice(k,1);
                    tempArr.push(event.target.dataset.id+'-'+event.target.value+'-'+this.dateToday);  
                    found = 1;
                    break;
                }                        
            }
            if(!found){
                tempArr.push(event.target.dataset.id+'-'+event.target.value+'-'+this.dateToday);
            }    
            this.checkedList = tempArr;
        }else{
            this.checkedList.push(event.target.dataset.id+'-'+event.target.value+'-'+this.dateToday);
        } 
    }
    
    //handle Save Attendence Record
    handleSaveAttendence(){
        this.isLoading = true;
        createRecord({attendList : this.checkedList}).then(res =>{
            this.isLoading = false;
            this.showToast('Record Inserted','Inserted Successfully','success'); 
        })
    }
    
    handleUpdateAttendence(){    
        deleteData({dt: this.dateToday}).then(res=>{
            this.handleAttendence();  
        })
    }
    
    //return shows Our Attendence method
    returnData(){ 
        this.attendence = [];
        let days = this.daysInMonth(this.monthAtend, 2024);
        returnAttendenceWrapper({month: this.monthAtend, listdays: this.items, daysInMonth : days}).then(res=> {
            if(res.length == 0){
                this.showToast('No Records','No Records','info'); 
            }else{
                res.forEach(ele=>{
                    ele.dtWrpperList.forEach(iterate =>{                        
                        ele.dtWrpperList= ele.dtWrpperList.sort((a, b) => a.dateOfDay > b.dateOfDay ? 1 : -1); 
                    })
                })
                this.attendence = res;
            } 
        }) 
    }
    
    //render call back for make chart
    renderedCallback() {   
        if(this.isNotClose){ 
            this.isChartJsInitialized = true;            
            const temp =  this.template.querySelector('.piechart');
            if(temp){
                Promise.all([
                    loadScript(this, ChartJS)
                ]).then(() => {
                  let  configNew = {
                        type: this.chartValue,
                        data: {
                            labels: this.xValues,
                            datasets: [{
                                label: 'dataset',
                                backgroundColor: this.barColors,
                                data: this.yValues
                            }]
                        },
                        options: {
                            title: {
                                display: true,
                                text: "User Data Chart"
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
        }

        // handle open modal of chart
        handleOpenChart(event){
            this.isChartJsInitialized = false;
            let i = 0;
            this.userId = event.target.dataset.id;
            this.template.querySelectorAll(`[data-value="${this.userId}"]`).forEach(element =>{
                this.yValues[i] = element.textContent;
                this.isShowChart = true;
                i++;
            })
            
            if(this.yValues != null && this.yValues.length > 0){
                this.isNotClose = true;
                this.isChartJsInitialized = true;
            }
        }
        
        //handle Onclick 
        handleChartValues(event){
            this.isChartJsInitialized = false; 
            this.isNotClose = true;   
            this.chartValue = event.target.value;
        }        
       
        //handle close chart modal
        closeChartHandle(){
            this.isShowChart = false;
            this.isChartJsInitialized = false;
            this.isNotClose = false;
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

       //chart option 
        get options() {
            return [               
                { label: 'Bar Chart', value: 'bar' },
                { label: 'Pie Chart', value: 'pie' },
                { label: 'Doughnut', value: 'doughnut' }
            ];
        }
        
    }