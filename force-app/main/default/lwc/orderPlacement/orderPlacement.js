import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchPartsOrder from '@salesforce/apex/PartsOrderController.searchPartsOrder';
import generateBody from '@salesforce/apex/SendPartOrderToAMOS.generateBody';


export default class orderPlacement extends LightningElement {
partsOrderId;
partsOrderNumber;
distributeCode;
dealerCode;
orderType;
description;

lineItemArr2;
strSearchPartsOrder = '';

handleKeyChange(event) {
    this.strSearchPartsOrder = event.target.value;
}


handleSearch() {
    searchPartsOrder({searchKey : this.strSearchPartsOrder})
    .then(result => {
        
        var arr = new Array(result);
        
        //partsOrder data
        this.partsOrderId = arr[0].Id;
        this.partsOrderNumber = arr[0].Parts_Order_Number__c;
        this.distributeCode = arr[0].DistributeCode__c;
        this.dealerCode = arr[0].DealerCode__c;
        this.orderType = arr[0].OrderType__c;
        this.description = arr[0].Description__c;
        
        //partsLineItem data
        var lineItemArr =  arr[0].Parts_Order_Line_Item__r;
        console.log(lineItemArr);
        this.lineItemArr2 = lineItemArr;
        
    }).catch(error=>{
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error',
            message: error.body.message,
            variant: "error"
        }));
    });
}

sendPartOrder(){
    console.log(this.partsOrderId);
    
    generateBody({productRequestId : this.partsOrderId})
    .then(result => {
        
        console.log(result);

        
    }).catch(error=>{
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error',
            message: error.body.message,
            variant: "error"
        }));
    });




}




}