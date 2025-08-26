import { LightningElement, api } from 'lwc';

export default class GrandChild extends LightningElement {
    @api messageReceived;
    messageSend;
    dataTosend='';
  
    handleChange(event){
      this.dataTosend = event.target.value;
    }
  
    handleGrandChildSubmit() {
      this.messageSend = this.dataTosend;
      this.dispatchEvent(
        new CustomEvent("grandchildevent", {
          detail: this.messageSend,
          bubbles: true,
          composed: true
        })
      )
    }
  
}