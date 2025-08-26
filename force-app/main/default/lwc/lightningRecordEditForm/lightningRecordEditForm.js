import { LightningElement, api } from 'lwc';

export default class LightningRecordEditForm extends LightningElement {
    layoutInformation = [];
    @api objectApiName;
    @api recordId;

    connectedCallback(){
        console.log("recordIddd===>",this.recordId);
        console.log('objectAPINAme==>',this.objectApiName);
        
        
      this.layoutInformation = [
        {
          "sectionName": "Basic Information",
          "columns": [
            {
              "fields": [
                { "apiName": "Name", "req":true}
              ]
            },
            {
              "fields": [
                { "apiName": "Site", "req":false},
                { "apiName": "Phone" , "req":false}
              ]
            }
          ]
        }  
      ] 
    }
}