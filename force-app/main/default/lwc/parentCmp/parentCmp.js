import { LightningElement, api } from 'lwc';

export default class ParentCmp extends LightningElement {
    @api messageReceived;
  messageSend;

  handleParentSubmit() {
    this.messageSend = "Hello";
    this.dispatchEvent(
      new CustomEvent("parentevent", {
        detail: this.messageSend,
        bubbles: true,
        composed: true
      })
    );
  }

  handleChildEvent(event) {
    this.messageReceived = event.detail;
    console.log('20',this.messageReceived);
  }

  handlegrandChildEvent(event) {
    this.messageReceived = event.detail;
    console.log('24',this.messageReceived);
  }
}