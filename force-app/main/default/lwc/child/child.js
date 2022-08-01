import { LightningElement, api } from 'lwc';
import Records from '@salesforce/apex/AccountContoller.method';

export default class Child extends LightningElement {

    accounts;
    error;
    @api userInput;

    @api
    handleSearch() {
        Records ({accountName : this.userInput})
            .then((result) => {
                this.accounts = result;
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.accounts = undefined;
            });
    }

}