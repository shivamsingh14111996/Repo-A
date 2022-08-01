import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NavigationDemo extends NavigationMixin (LightningElement){
    navigateToNewContactWithDefaults() {
        const defaultValues = encodeDefaultFieldValues({
            FirstName: 'Morag',
            LastName: 'de Fault',
            LeadSource: 'Other'
        });

        console.log(defaultValues);

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }
}