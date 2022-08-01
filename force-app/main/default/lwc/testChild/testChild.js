import { LightningElement,api } from 'lwc';

export default class TestChild extends LightningElement {

    handleClick() 
    {
        const selectEvent = new CustomEvent('close', {
            detail: {colour : 'green'},
            bubbles: true,
            composed : true
        });

        this.dispatchEvent(selectEvent);
    }
}