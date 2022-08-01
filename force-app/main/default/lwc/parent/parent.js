import { LightningElement, track, wire } from 'lwc';
import getAccountList from '@salesforce/apex/AccountCOntroller.getAccountList';
import { refreshApex } from '@salesforce/apex';
import deleteAccount from '@salesforce/apex/AccountCOntroller.deleteAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class LightningSpinnerLWCExample extends LightningElement {

  handle() {
    var x= 0;
    let y = '';
    var x = 0;

  }

}