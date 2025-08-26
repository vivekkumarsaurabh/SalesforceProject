import { LightningElement, api } from 'lwc';


export default class DragANDDrop extends LightningElement {
    @api recordId;

    data = this.recordId;
}