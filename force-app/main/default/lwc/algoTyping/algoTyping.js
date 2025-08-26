import { LightningElement, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import ChartJS from '@salesforce/resourceUrl/ChartJS';
import loginHandle from '@salesforce/apex/AlgoTyping.loginHandle';
import signUpHandle from '@salesforce/apex/AlgoTyping.signUpHandle';
import searchEmail from '@salesforce/apex/AlgoTyping.searchEmail';
import saveRecordHandle from '@salesforce/apex/AlgoTyping.saveRecordHandle';
import retriveRecords from '@salesforce/apex/AlgoTyping.retriveRecordHandle';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AlgoTyping extends LightningElement {
isRunTime = true;
isTyping = true;
isChartDisplay = false;
isChartJsInitialized = false;
isture = true;
isLogin = false;
isLogOut = false;
isLogInModal = false;
isDashBoard = false;
isLogInPage = true;
isSignUpPage = false;
correctChar = 0;
incorrectChar = 0;
accuracy = 0;
wpm = 0;
timer;
timeSet;
secTimer;
word;
chartInterval;
index = -1;
userId;
userName;
userEmail;
todayDate;
incorrectIndexArr = [];
paragraphWord = [];
records = [];
xValues = ['Correct Charector','Incorrect Charector'];
barColors = ['yellow','orange'];
yValues = [];
paragraphSentence = ["Learning is a lifelong journey, and there is always something new to discover. Whether it is mastering a new skill, exploring a new hobby, or learning about a new culture, every day is an opportunity to grow and expand one's horizons.", "The development of ecosystem-based adaptation strategies is another important application of technology and nature. Ecosystem-based adaptation uses natural systems and processes to build resilience to climate change and other environmental threats.", "The snow was falling softly outside, creating a winter wonderland. I snuggled up by the fire with a cup of hot cocoa, feeling cozy and content.", "The universe is vast and mysterious, with countless wonders waiting to be discovered. From distant galaxies to subatomic particles, there is no limit to the secrets that can be unlocked through scientific exploration.","Mindfulness is the practice of being present and fully engaged in the moment, and it is essential to cultivating a sense of peace and well-being. Whether it's through meditation, deep breathing, or simply taking time to savor the sights and sounds of the world around us, mindfulness can bring a sense of calm and clarity to our lives.","The popularity of outdoor activities like hiking and camping has been growing, with people seeking out opportunities to explore nature and disconnect from technology. It's a way to recharge and appreciate the beauty of the natural world.","The aroma of freshly baked bread wafted through the air as I walked into the cozy bakery. The shelves were lined with all kinds of delectable treats, and I couldn't resist indulging in a warm croissant.","The smell of freshly cut grass wafted through the air, making everyone feel more alive and energized.","The sun beat down on the beach, warming the sand and the water to the perfect temperature.","The sound of a river rushing by could be heard in the distance, adding to the tranquility of the scene.","A gentle rain fell from the sky, washing the city clean and bringing a sense of calm to the streets.","The sound of children playing could be heard in the park as parents watched from nearby."];
paragraphValue;

//connected callback handler 
connectedCallback(){
    this.paragraphValue = this.returnRandomPara();    
    this.todayDate = new Date().toJSON().slice(0,10);
    this.isLogin = true;
}

//render callback handler
renderedCallback(){
    if(this.isture){
    let para = this.template.querySelector('.paraGraph').innerText;
    this.paragraphWord = para.split("");
    this.template.querySelector('.paraGraph').innerHTML = this.getParagraphWithSpanTag(para);
    this.isture = false;   
    this.timer = 30;
    this.secTimer = 30;
    this.wpm = 0;
    this.isDashBoard = false;
    this.isChartDisplay = false;
    this.isChartJsInitialized = false;
    this.isDashBoard = false;
    this.isTyping = true;
    }
}

//login handler for display modal
loginHandler(){  
    this.isLogInModal = true;
    this.isSignUpPage = false;
    this.isLogInPage = true;  
    this.template.querySelector('.inputName').value = '';
    this.template.querySelector('.inputEmail').value = '';
    this.template.querySelector('.loginCard').style.display = 'block';
}

//check input validation of appointment
isInputValid() {
    let isValid = true;
    let inputNameFields = this.template.querySelectorAll('.input');
    inputNameFields.forEach(inputField => {
        if(!inputField.checkValidity()) {
            inputField.reportValidity();
            isValid = false;
        }
    });
    return isValid;
}

//login  button handler
loginNow(){
    if(this.isInputValid()){
   this.userName =  this.template.querySelector('.inputName').value;
   this.userEmail = this.template.querySelector('.inputEmail').value;
    loginHandle({name: this.userName, email : this.userEmail }).then(result =>{
        result.forEach(ele =>{
         this.userId = ele.Id;
        })
        if(result.length == 0){
            this.isLogOut = false;
            this.isLogin = true; 
            this.showToast('Invalid User','Please fill correct email or Name','error');
            this.closeModalHandler();           
        }else{
            this.showToast('Login Sucessfully','Sucessfull Login','success'); 
            this.isLogin = false;
            this.isLogOut = true;   
            this.closeModalHandler();            
        }
    })
}
}

//check input validation of appointment
isInputValidUpdate() {
    let isValid = true;
    let inputNameFields = this.template.querySelectorAll('.inputNew');
    inputNameFields.forEach(inputField => {
        if(!inputField.checkValidity()) {
            inputField.reportValidity();
            isValid = false;
        }
    });
    return isValid;
}

//sign Up btn Handler
SignUpHandler(){
    if(this.isInputValidUpdate()){
        let userName =  this.template.querySelector('.inputNameNew').value;
        let userEmail = this.template.querySelector('.inputEmailNew').value;
        searchEmail({email : userEmail}).then(res =>{
            if(res.length == 0){
                signUpHandle({name: userName, email : userEmail}).then(result =>{            
                    this.isLogOut = false;
                    this.isLogin = true;                 
                    this.showToast('Sign Up','Sign up Successfull. please Log In','success');               
                    this.closeModalHandler(); 
                })
            }else{
                this.isLogOut = false;
                this.isLogin = true; 
                this.showToast('Duplicate Email','Invalid Email ! Please check your email','error');               
                this.closeModalHandler();
            }           
        })       
    }    
}

//back to login page
BackloginHandler(){
    this.isLogInPage = true;
    this.isSignUpPage = false;
}

//move to sighn up page
SignUpNow(){
    this.isLogInPage = false;
    this.isSignUpPage = true; 
}

//save result handler
saveResultHandler(){
    if(this.isLogin == true && this.isLogOut == false){
         this.loginHandler().then(res=>{
            this.createRecordHandler();
         })        
    }else{
        this.createRecordHandler();
    }
}

//create record of your typing test
createRecordHandler(){
    saveRecordHandle({dt: this.todayDate, tim : this.secTimer, acc: this.accuracy, wpm: this.wpm, corrChar : this.correctChar, inCorrChar : this.incorrectChar, userId : this.userId}).then(res => {
        this.showToast('Save Sucessfully','Record Save','success'); 
     })
}

//close your modal
closeModalHandler(){
    this.template.querySelector('.loginCard').style.display = 'none';
}

//logout handler
logoutHandler(){
    this.userName = '';    
    this.isLogOut = false;
    this.isLogin = true; 
}

//dashboard handler
dashboardHandler(){
    if(this.isLogin){
        this.loginHandler();
    }else{
        this.isTyping = false;  
        retriveRecords({user : this.userId}).then(result =>{
        this.records = result;              
        this.isDashBoard = true;
        }) 
    }
}

//return randomly paragraph 
returnRandomPara(){
    let res = this.paragraphSentence[(Math.floor(Math.random() * this.paragraphSentence.length))];   
  return res;
}

//time handler for color
timeHandle(event){    
    this.template.querySelector(`[data-id="${this.secTimer}"]`).style.color = ''; 
    this.timer = event.currentTarget.dataset.id;   
    this.secTimer =  event.currentTarget.dataset.id;
    this.template.querySelector(`[data-id="${this.secTimer}"]`).style.color = 'yellow';
    this.resetHandler();
}

//reset Handler for all value reset and also reset our paragraph
resetHandler(){  
    this.template.querySelector('.textA').value = '';     
    this.correctChar = 0;
    this.incorrectChar = 0; 
    this.wpm = 0;
    this.accuracy = 0;    
    for(let i = this.index; i>=0; i--){
        this.template.querySelector(`[data-index="${i}"]`).style.color = '';  
    }    
    this.template.querySelector('.paraGraph').innerText = '';
    this.template.querySelector('.time').innerHTML = '';
    let para = this.template.querySelector('.paraGraph').innerText = this.returnRandomPara();
    this.paragraphWord = para.split("");    
    this.template.querySelector('.paraGraph').innerHTML = this.getParagraphWithSpanTag(para); 
    this.index = -1; 
    this.timer = this.secTimer; 
    this.template.querySelector(`[data-id="30"]`).style.color = '';
    this.template.querySelector(`[data-id="${this.secTimer}"]`).style.color = 'yellow';    
    this.isRunTime = true;    
    this.isTyping = true;
    clearInterval(this.timeSet);    
}

//home handler for going home 
homeHandler(){     
    this.isDashBoard = false;
    this.isChartDisplay = false;
    this.isChartDisplay = false;
    this.isChartJsInitialized = false;
    this.isTyping = true;  
    let para = this.template.querySelector('.paraGraph').innerText;
    this.paragraphWord = para.split("");
    this.template.querySelector('.paraGraph').innerHTML = this.getParagraphWithSpanTag(para);   
    this.resetHandler();
}

//this is for increasing time
timeRuningHandler(){
    this.isRunTime = false;
    this.timeSet = setInterval(() => {
        this.timeDesc(); 
    }, 1000);   
}

//this is for time desc for timer
timeDesc(){    
    if(this.timer == 0){ 
        this.isDashBoard = false;
        this.isTyping = false;  
        this.isChartDisplay = true;
        this.isChartJsInitialized = true;     
        this.accuracy = this.findAcccuracyHandler(this.correctChar, this.incorrectChar); 
        var wordPerMin = this.template.querySelector('.textA').value; 
        this.wpm = this.findWordPerMinHandler(wordPerMin, this.secTimer);   
        this.lineChartJsHandler();       
        clearInterval(this.timeSet);
    }
 this.template.querySelector('.time').innerHTML = this.timer;
 this.timer--;
}

 //make a chart
 lineChartJsHandler(){ 
    this.yValues = [];
    this.yValues.push(this.correctChar);
    this.yValues.push(this.incorrectChar); 
   this.chartInterval =  setInterval(() => { 
    const temp = this.template.querySelector('.lineChart');
    if(temp){      
        Promise.all([ loadScript(this, ChartJS)]).then(() => {
          let configNew = {
                type: "doughnut",
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
                        display: true
                    }
                }
            }
            const temp = this.template.querySelector('.lineChart').getContext( "2d" );
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
        clearInterval(this.chartInterval);
    }, 1000);     
}

//check paragrapah and textarea charecter
paraGraphHandler(index, word){
    if(word == this.paragraphWord[index]){                                                                                                                      
        this.correctChar++;
        this.template.querySelector(`[data-index="${index}"]`).style.color = '#fff';
    }else{
        this.incorrectChar++;
        this.template.querySelector(`[data-index="${index}"]`).style.color = 'red';        
        this.incorrectIndexArr.push(index);
    }
    
}

//increase and decrease index and also backspace
checkHandler(event){
    if(this.isRunTime){
        this.timeRuningHandler();
    }
    if(this.paragraphWord.length == this.index-1){
        this.isDashBoard = false;
        this.isTyping = false;  
        this.isChartDisplay = true;
        this.isChartJsInitialized = true;     
        this.accuracy = this.findAcccuracyHandler(this.correctChar, this.incorrectChar); 
        var wordPerMin = this.template.querySelector('.textA').value; 
        this.wpm = this.findWordPerMinHandler(wordPerMin, this.secTimer);   
        this.lineChartJsHandler();   
        this.clearInterval(this.timeSet);
    }
if(event.keyCode == 8){    
    this.template.querySelector(`[data-index="${this.index}"]`).style.color = '';
    this.index--;
    if(this.incorrectIndexArr.includes(this.index)){
        if(!this.incorrectChar<=0){
        this.incorrectChar--;
        }
    }
}else if(event.keyCode == 16){
   
}
else{   
    this.index++;
    let para = this.template.querySelector('.textA').value; 
    this.word = para.charAt(para.length - 1);    
    this.paraGraphHandler(this.index, this.word);
}
}

// calculate word per mint
findWordPerMinHandler(sentence, timer){
    let res = 0; 
   let wordArr = sentence.split(" ");   
   if(timer == 15){
    res = wordArr.length * 4;
   }else if(timer == 30){
    res = wordArr.length * 2;
   }else if(timer == 60){
    res = wordArr.length * 1;
   }else if(timer == 120){
    res = wordArr.length/2;
   }
   return res;
}

//find accuracy of word;
findAcccuracyHandler(correct, inccorect){
let res = 0;
var totalChar = correct + inccorect;
res = Math.ceil((correct/totalChar)*100);
return res;
}

//add span with paragraph
getParagraphWithSpanTag(paraGraph){
    let result = '';
    if(paraGraph != null && paraGraph != undefined){
        let paraGraphArr = paraGraph.split("");
        for(let i = 0; i < paraGraphArr.length; i++){
            let ele = `<span data-index="${i}">`+paraGraphArr[i]+'</span>';
            result += ele;
        }
    }
    return result;
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