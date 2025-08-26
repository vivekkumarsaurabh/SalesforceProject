import { LightningElement } from 'lwc';

export default class GrandParentCmp extends LightningElement {
 messageReceived;
messageSend;
dataTosend ='';

  handleChange(event){
    this.dataTosend = event.target.value;
  }

  handleGrandParentSubmit() {
    this.messageSend = this.dataTosend;
  }

  handleParentEvent(event) {
    this.messageReceived = event.detail;
  }

  handleChildEvent(event) {
    this.messageReceived = event.detail;
  }

  handlegrandChildEvent(event) {
    this.messageReceived = event.detail;
  }
}