import { LightningElement, track } from 'lwc';
import IMAGES from "@salesforce/resourceUrl/NewImage";
import createAccRecord from "@salesforce/apex/insertAccRecLWC.createAccRecord";
export default class HelloWorld extends LightningElement {
   @track name = '';
   @track email = '';
   @track age = '';
    logo = IMAGES;
    changeHandler(event) {
      this.name = event.target.value;     
    }
    changeHandler2(event) {       
        this.email = event.target.value;   
    }
    changeHandler3(event) {       
        this.age = event.target.value;
    }
    insertRecord(){
        createAccRecord({name:this.name,rating:'Hot'}).then(result=>{
            console.log('sucessfully Inserted',result)
        })
    }
    
}

// export default class helloWorld extends LightningElement {

// }