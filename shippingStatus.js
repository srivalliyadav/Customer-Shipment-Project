import { LightningElement , track , api } from 'lwc';

import getStatus from '@salesforce/apex/shipmentStatusController.getStatus';
export default class ShippingStatus extends LightningElement {
 
@api recordId;
@track status;
@track error;

    connectedCallback() {
        if (this.recordId) {
            this.fetchStatus();
        }
    }

    fetchStatus() {
        getStatus({ recordId: this.recordId })
        .then(result => {

            this.status = result;
            this.error = undefined;
        })
        .catch(error => {
            this.status = undefined;
            this.error = 'Tracking number cannot be found or is empty';
        
        })
    }

}