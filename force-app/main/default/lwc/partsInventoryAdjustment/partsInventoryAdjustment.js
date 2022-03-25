import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createTrans from '@salesforce/apex/transactionController.createTrans';
import Quantity__c_FIELD from '@salesforce/schema/Parts_Inventory__c.Quantity__c';
import Updated_Quantity__c_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Updated_Quantity__c';
import Confirmed_Quantity__c_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Confirmed_Quantity__c';
import Transaction_Date__c_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Transaction_Date__c';
import Description__c_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Description__c';
import Status__c_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Status__c';
import Parts_Inventory__c_FIELD from '@salesforce/schema/Parts_Inventory_Transaction__c.Parts_Inventory__c';


export default class createRecordForm extends LightningElement {
    @api recordId;
    updatedQuantity;
    confirmedQuantity;
    transactionDate;
    status;
    description;
    currentQuantity;

    @wire(getRecord, { recordId: "$recordId", fields: [Quantity__c_FIELD] })
    wireInventory({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.currentQuantity = data.fields.Quantity__c.value;
            this.confirmedQuantity = data.fields.Quantity__c.value;
        }
    }

    updatedQuantityHandler(event){
        this.updatedQuantity = event.target.value;
        this.confirmedQuantity = parseFloat(this.currentQuantity) + parseFloat(this.updatedQuantity);
    }
    confirmedQuantityHandler(event){
        this.confirmedQuantity = event.target.value;
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
    


    validation(){
     let inputConfirmedQty = this.template.querySelector('.confirmedQtyId');
     let inputConfirmedQtyValue = inputConfirmedQty.value;
     let inputUpdatedQty = this.template.querySelector('.updatedQtyId');
     let inputUpdatedQtyValue = inputUpdatedQty.value;

        if(inputConfirmedQtyValue < 0){
            inputConfirmedQty.setCustomValidity('Confirmed Quantity must be Positive.'); 
            inputConfirmedQty.reportValidity();
            return false;
        }else{
            inputConfirmedQty.setCustomValidity(''); 
            inputConfirmedQty.reportValidity();
        }

        if(this.status == 'Loss' || this.status == 'Wastage/Spillage'){
            if(inputUpdatedQtyValue > 0){
                inputUpdatedQty.setCustomValidity('Please check the value.');
                inputUpdatedQty.reportValidity();
                return false;
            }else{
                inputUpdatedQty.setCustomValidity(''); 
                inputUpdatedQty.reportValidity();
            }
        }

        if(this.status == 'Arrival of Claimed parts' || this.status == 'Parts return' || this.status == 'Other surplus'){
            if(inputUpdatedQtyValue < 0){
                inputUpdatedQty.setCustomValidity('Please check the value.'); 
                inputUpdatedQty.reportValidity();
                return false;
            }else{
                inputUpdatedQty.setCustomValidity(''); 
                inputUpdatedQty.reportValidity();
            }
        }
        
    return true;
 }

    handleClick(){
         if(!this.validation()){
             return;               // 오류 발생 했을 때 실행됨.
          }

         const recordInput = {
             [Updated_Quantity__c_FIELD.fieldApiName] : this.updatedQuantity,
             [Confirmed_Quantity__c_FIELD.fieldApiName] : this.confirmedQuantity,
             [Transaction_Date__c_FIELD.fieldApiName] : this.transactionDate,
             [Status__c_FIELD.fieldApiName] : this.status,
             [Description__c_FIELD.fieldApiName] : this.description,
             [Parts_Inventory__c_FIELD.fieldApiName] : this.recordId
            };
        
        createTrans({ trans : recordInput })
        .then(result=>{
            this.dispatchEvent(new ShowToastEvent({
                title: "Transaction created",
                variant: "success"
            }));
            updateRecord({ fields: { Id: this.recordId } });
            this.updatedQuantity = null;
            this.transactionDate = null;
            this.status = null;
            this.description = null;
        }).catch(error=>{
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: "error"
            }));
        });
    }
}

// error 는 object.