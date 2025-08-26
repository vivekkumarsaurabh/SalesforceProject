import { LightningElement, wire, api, track } from 'lwc';
import retriveRecord from '@salesforce/apex/RetriveAccRecord.retriveRecord';

export default class WireExample extends LightningElement {
    @api recordId;
    @wire(retriveRecord,{id : '$recordId'}) contact;
}