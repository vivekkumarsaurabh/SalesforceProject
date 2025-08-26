import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CSVEditor extends LightningElement {    
    tableData;
    keyValue;
    text;
    isModal = false;
    isDownloadBtn = true;
    isUploadBtn = false;
    isClearBtn = true;
    tableArr=[];
    blankData = [];
    tableHeader = [];
    tableAlpha  = [];
 
    
    fileInsertHandler(){
        this.template.querySelector('.fileInput').click();
    }

   //upload file handler
    uploadFileHandler(event){
    const file = event.target.files[0];          
        var reader = new FileReader();
        reader.onload = () => {
            var base64 = reader.result.split(',')[1];     
            let mainString = atob(base64);
            var arr = mainString.split('\n');
            let head = 'S.No';
            this.tableHeader.push(head);
            this.tableAlpha.push('*');
            let k = 0;
            arr[0].split(',').forEach(ele =>{  
                    this.tableHeader.push(ele.trim());
                    this.tableAlpha.push((k+10).toString(36));
                    k++; 
            });
           
            for(let index = 1; index<arr.length; index++){               
                var rowarr = arr[index].split(',');
                var newArr=[];
                for(let row = 0; row < rowarr.length; row++){                                  
                    let e = (row+10).toString(36);
                    let dataObj = { key:`${e}${index-1}`, value:rowarr[row]};                     
                    newArr.push(dataObj);
                    if(!rowarr[row]){                      
                        let ef = (row+10).toString(36);
                        let dataf = `${ef}${index-1}`;                       
                        this.blankData.push(dataf);
                    }                   
                }
                this.tableArr.push(newArr);
            }           
            this.tableData = this.tableArr;
            this.isDownloadBtn = false;
            this.isUploadBtn = true;
            this.isClearBtn = false;
        }
        reader.readAsDataURL(file);
    }
    
    //editHandler
    editHandlerOpen(event){
      this.keyValue = event.currentTarget.dataset.keyval;
      this.isModal = true;
    }

    //textFill Handler
    textFillHandler(event){
    this.text = event.currentTarget.value;
    }

    //saveInput Handler
    filled = true;
    saveInputHandler(){  
        this.template.querySelector(`[data-key="${this.keyValue}"]`).style.background = 'green'; 
        for(let index = 0; index<this.tableData.length; index++){ 
            let dataObj = { key:this.keyValue, value:this.text};
            let arrObj = this.tableData[index];
            let foundIndexes = arrObj.findIndex(x => x.key == this.keyValue);
            arrObj[foundIndexes] = dataObj;          
        }

        for (let i = 0; i < this.blankData.length; i++) { 
            if (this.blankData[i] === this.keyValue) { 
                this.blankData.splice(i, 1); 
            }            
        }
          
        this.isModal = false;      
        let input = this.template.querySelector(`[data-key="${this.keyValue}"]`);
        input.scrollIntoView({ behavior: "smooth", block: "center", inline: "center" });
        setTimeout(() => {
            this.template.querySelector(`[data-key="${this.keyValue}"]`).style.background = 'green'; 
            this.template.querySelector(`[data-key="${this.keyValue}"]`).style.color = '#fff'; 
        }, 1000);
      

          //input.focus();
         
       //   input.style.animation = 'example 3s';
       this.filled = false;
       this.filled = true;
         
    }

    //discard cancel Handler
    discardCancelModal(){
        this.isModal = false;
    }
     
    //download handler
    downLoadhandler(){ 
        if(this.text != null){   
        for(let rem = 0; rem<this.tableHeader.length; rem++){
            if(this.tableHeader[rem] == 'S.No'){
                this.tableHeader.splice(rem, 1);
            }           
        }
        var ans = this.tableHeader.toString() +'\n';
        for(let iterate = 0; iterate<this.tableData.length; iterate++){
            let innerArray = this.tableData[iterate];
            for(let inner = 0; inner<innerArray.length; inner++){
                ans+= innerArray[inner].value + ',';
            }
           ans.slice(0, -1);
           ans+='\n';
        }
        var anchorTag = document.createElement('a');
        anchorTag.href="data:text/csv;charset=utf-8," + encodeURI(ans);
        anchorTag.target="_self";
        anchorTag.download="new csv.csv";
        anchorTag.innerHTML = "link text";
        document.body.appendChild(anchorTag);
        anchorTag.click();
        this.showToast('Download Sucessfull','Download successfully','sucess');
    }
    else{
        this.showToast('No Changes','You have doing no changes in your data','error');
    }
   }

   clearDatahandler(){  
    this.tableHeader = [];
    this.tableAlpha = [];
    this.blankData = [];
    this.tableArr = [];
    this.text = null;
    this.keyValue = null;    
    this.tableData = null;
    this.template.querySelector('.fileInput').value = '';
    this.isUploadBtn = false;
    this.isDownloadBtn = true;
    this.isClearBtn = true;
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