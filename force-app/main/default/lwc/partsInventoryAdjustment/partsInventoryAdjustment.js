import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createTrans from '@salesforce/apex/transactionController.createTrans';
import Quantity__c_FIELD from '@salesforce/schema/Parts_Inventory__c.Quantity__c';



export default class createRecordForm extends LightningElement {
    @api recordId;
    @wire(getRecord, { recordId: "$recordId", fields: [Quantity__c_FIELD] })
    onChangeUpdatedQuantity;
    updatedQuantity;
    onChangeConfirmedQuantity;
    confirmedQuantity;
    transactionDate;
    status;
    description;
    currentQuantity;
    selectedValue;

    @wire(getRecord, { recordId: "$recordId", fields: [Quantity__c_FIELD] })
    wireInventory({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.currentQuantity = data.fields.Quantity__c.value;
            this.onChangeConfirmedQuantity = data.fields.Quantity__c.value;
        }
    }

    updatedQuantityHandler(event){
        this.updatedQuantity = event.target.value;
        this.onChangeConfirmedQuantity = parseFloat(this.currentQuantity) + parseFloat(this.updatedQuantity);
        this.confirmedQuantity = parseFloat(this.currentQuantity) + parseFloat(this.updatedQuantity);
    }
    confirmedQuantityHandler(event){
        this.confirmedQuantity = event.target.value;
        this.onChangeUpdatedQuantity = parseFloat(this.confirmedQuantity) - parseFloat(this.currentQuantity);
        this.updatedQuantity = parseFloat(this.confirmedQuantity) - parseFloat(this.currentQuantity);
    }
    transactionDateHandler(event){
        this.transactionDate = event.target.value;
    }
    statusHandler(event){
        this.status = event.target.value;
    }
    descriptionHandler(event){
        this.description = event.target.value;
    }
    
    handleClick(){
        createTrans({
            UQuantity: this.updatedQuantity,
            CQuantity: this.confirmedQuantity,
            TDate: this.transactionDate,
            Status: this.status,
            Description: this.description,
            PInventory: this.recordId
        }).then(result=>{
            this.dispatchEvent(new ShowToastEvent({
                title: "Transaction created",
                variant: "success"
            }));
            updateRecord({ fields: { Id: this.recordId } });
            this.onChangeUpdatedQuantity = null;
            this.updatedQuantity = null;
            this.transactionDate = null;
            this.status = null;
            this.description = null;
            this.message = 'Transaction Created';
            console.log(this.updatedQuantity);
            console.log(this.status);
        }).catch(error=>{
            this.dispatchEvent(new ShowToastEvent({
                title: "Error",
                variant: "error"
            }));
            this.message = 'Error';
        });
    }
}

