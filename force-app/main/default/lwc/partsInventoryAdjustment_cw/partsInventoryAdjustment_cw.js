import { LightningElement, api, wire } from 'lwc';
import {getRecord, createRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import PARTS_INVENTORY_TRANSACTION_OBJECT from '@salesforce/schema/Parts_Inventory_Transaction__c';
import UPDATEDQTY_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Updated_Quantity__c';
import CONFIRMEDQTY_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Confirmed_Quantity__c';
import TRANSACTIONDATE_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Transaction_Date__c';
import STATUS_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Status__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Description__c';
import PARTSINVENTORY_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Parts_Inventory__c';

const FIELDS = 'Parts_Inventory__c.Quantity__c';

export default class PartsInventoryAdjustment_cw extends LightningElement {
    @api recordId;

    updatedQtyVal;
    confirmedQtyVal;
    transactionStatusVal;
    transactionDateVal;
    descriptionVal;
    partsInventory;

    @wire(getRecord, { recordId:'$recordId', fields: FIELDS})
    wiredRecord({ error, data }) {
        if (error) {

        } else if (data) { 
            this.existQty = data.fields.Quantity__c.value;
            this.confirmedQtyVal = data.fields.Quantity__c.value;
        }
    }

    updatedQty(event) {
        this.updatedQtyVal = event.target.value;
        this.confirmedQtyVal = Number(this.updatedQtyVal) + Number(this.existQty);
    }

    confirmedQty(event) {
        this.confirmedQtyVal = event.target.value;
        this.updatedQtyVal = Number(this.confirmedQtyVal) - Number(this.existQty);
    }

    transactionStatus(event) { 
        this.transactionStatusVal = event.target.value;
    }

    transactionDate(event) { 
        this.transactionDateVal = event.target.value;
    }

    description(event) { 
        this.descriptionVal = event.target.value;
    }
    
    // validation function 
    confirmedValidation() { 
        let confirmCmp = this.template.querySelector(".confirmCmp");
        let confirmValue = confirmCmp.value;
        let updateCmp = this.template.querySelector(".updateCmp");
        let updateValue = updateCmp.value;
            
           if (confirmValue < 0) { 
               confirmCmp.setCustomValidity("Positive value is required");
               confirmCmp.reportValidity();
               return false;
            } else { 
                confirmCmp.setCustomValidity("");
                confirmCmp.reportValidity();
            }
            
            if (this.transactionStatusVal == 'Loss' || this.transactionStatusVal == 'Wastage/Spillage') { 
                if (updateValue > 0) { 
                    updateCmp.setCustomValidity("Negative value is required");
                    updateCmp.reportValidity();
                    return false;
                } else { 
                    updateCmp.setCustomValidity("");
                    updateCmp.reportValidity();
                }
            }
            
            if (this.transactionStatusVal == 'Arrival of Claimed parts' || this.transactionStatusVal == 'Parts return' || this.transactionStatusVal == 'Other surplus') { 
                if (updateValue < 0) { 
                    updateCmp.setCustomValidity("Positive value is required");
                    updateCmp.reportValidity();
                    return false;
                } else { 
                    updateCmp.setCustomValidity("");
                    updateCmp.reportValidity();
                }
            }

         return true;
    }
    
    // INSERT RECORD
    createTransaction() { 
        if(!this.confirmedValidation()) { 
            return;
         }
        const fields = {};
        fields[UPDATEDQTY_FIELD.fieldApiName] = this.updatedQtyVal;
        fields[CONFIRMEDQTY_FIELD.fieldApiName] = this.confirmedQtyVal;
        fields[STATUS_FIELD.fieldApiName] = this.transactionStatusVal;
        fields[TRANSACTIONDATE_FIELD.fieldApiName] = this.transactionDateVal;
        fields[DESCRIPTION_FIELD.fieldApiName] = this.descriptionVal;
        fields[PARTSINVENTORY_FIELD.fieldApiName] = this.recordId;

        const recordInput = {apiName : PARTS_INVENTORY_TRANSACTION_OBJECT.objectApiName , fields};
        createRecord(recordInput)
            .then(Parts_Inventory_Transaction__c => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Parts Inventory Transaction created',
                        variant: 'success',
                    }),
                );
                this.updatedQtyVal = null;
                this.transactionStatusVal = null;
                this.transactionDateVal = null;
                this.descriptionVal = null;
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
}