import { LightningElement,api } from 'lwc';

export default class ControlImage extends LightningElement {
    @api url;
    @api altText;
}