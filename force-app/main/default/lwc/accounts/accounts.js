import { LightningElement, api, wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import searchImperativeContactList from '@salesforce/apex/AccountCOntroller.searchImperativeContactList';
export default class Accounts extends NavigationMixin(LightningElement) {
  handleClick() {
    this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
      attributes: {
          actionName: "new",
          objectApiName: "Account"
      }
  });
  }

  num=0 ;

  handleChange(event) {
    this.num = event.target.value;
  }
}

