import { LightningElement } from 'lwc'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Feedback extends LightningElement {
    fields = ['Name__c', 'Email__c', 'phone__c', 'Rating__c', 'Any_Suggestion__c'];
    objectApiName = 'feedback__c';
    handleSuccess(){
        this.showToast('Saved Sussfully','Your feedback is saved. Thank You !','success');
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