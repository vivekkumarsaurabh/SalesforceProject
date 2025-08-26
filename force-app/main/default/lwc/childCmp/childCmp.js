import { LightningElement, api } from 'lwc';

export default class ChildCmp extends LightningElement {

    @api messageReceived;
    messageSend;
  
    handleChildSubmit() {
      this.messageSend = "Hello";
      this.dispatchEvent(
        new CustomEvent("childevent", {
          detail: this.messageSend,
          bubbles: true,
          composed: true
        })
      );
    }
  
    handlegrandChildEvent(event) {
      this.messageReceived = event.detail;
    }
  
}