import { LightningElement , api, wire, track} from 'lwc';
//import getContactList from '@salesforce/apex/FirstAppClass.getContactList'
//import { LastName,fun1 } from 'c/utillLwc';
//import {lName,fun1} from './firstUtil'
//mport getAnimalName from '@salesforce/apex/WoodlandCreatures.makeGetCallout';
import getAnimalName from '@salesforce/apex/WoodlandCreatures.makePOSTCallout';


export default class FirstLWC extends LightningElement {
   /*  percent = 10;

     percentageValueHandler(event) {
     //this.percent = event.target.value
     this.template.querySelector('c-second-lwc').methodToAlert( event.target.value)
    }

    get percentage() {
     return `width:${this.percent}%`
    }

    errorCallback(error,stack) {
        console.log(error.message)
        console.log(stack)
    } */

    animalname='' ;
    error;

    handleClick() {
        getAnimalName ()
        .then(result => {this.animalname = result })
        .catch(error => {this.error = error })
    }

}