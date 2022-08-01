import { api, LightningElement } from 'lwc';

export default class SecondLwc extends LightningElement {
    @api percentValue = 20;

    @api 
    methodToAlert(value) {
        //alert('ALERT')
        this.percentValue = value;
    }
}