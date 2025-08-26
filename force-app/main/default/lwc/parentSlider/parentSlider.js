import { LightningElement } from 'lwc';

export default class ParentSlider extends LightningElement {
    
    autoScroll = false;
    slides = [];

    get sliderData() {
        return this.slides;
    }

    eventMethod(event){
        console.log('event====>',JSON.stringify(event));
        console.log('event=detail===>',JSON.stringify(event.detail));

        
        this.slides = event.detail;
    }

}