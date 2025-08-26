import { LightningElement, api } from 'lwc';
import manualShareGroupId from '@salesforce/label/c.manualShareGroupId';
import shareAccount from '@salesforce/apex/ShareObjectRecordWithLWC.manualShareRead';
export default class HideRecord extends LightningElement {
    @api recordId
    @api objectApiName
    error;
    handleCheckBox(event){
      console.log('recordId====>'+this.recordId+'objectApiName===>'+this.objectApiName);
      if(event.target.checked){
        //0055j0000098dJRAAY
        manualShareGroupId
        shareAccount({recordId : this.recordId , userId: '0055j0000098dJRAAY', objectName:this.objectApiName}).then(res =>{
            
        }).catch(error => {
            this.error = error;
        });
      } 
       console.log("Todo: " +event.target.checked);
    }
}