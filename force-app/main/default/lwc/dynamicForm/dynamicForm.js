import { LightningElement, api, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
//import DynamicFormsElement from "c/dynamicFormsElement";
export default class DynamicForm extends LightningElement {

@api recordId;
  @api objectApiName;
  @api label;
  @api fieldApiName;
  editMode = false;

  @wire(getRecord, {
    recordId: "$recordId",
    fields: [""],
    optionalFields: "$fieldName"
  })
  thisRecord;

  get fieldName() {
    return this.objectApiName + "." + this.fieldApiName;
  }

  get currentFieldValue() {
    return this?.thisRecord?.data?.fields[this.fieldApiName]?.value;
  }

  handleSliderChange(event) {
    this.broadcast(this.EVENT_TYPE.UPDATE, {
      newValue: event.detail.value,
      fieldApiName: this.fieldApiName
    });
  }

  handleMessage(message) {
    if (message.eventType === this.EVENT_TYPE.EDIT) {
      this.editMode = true;
    } else if (message.eventType === this.EVENT_TYPE.CANCEL) {
      this.editMode = false;
    } else if (message.eventType === this.EVENT_TYPE.SAVE_START) {
      this.showSpinner = true;
    } else if (message.eventType === this.EVENT_TYPE.SAVE_END) {
      this.showSpinner = false;
    }
  }

  connectedCallback() {
    this.subscribeToMessageChannel();
    this.broadcast(this.EVENT_TYPE.CHECK_EDIT);
  }

}