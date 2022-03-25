import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import serachPartsOrder from '@salesforce/apex/PartsOrderController.serachPartsOrder';
import Id_FIELD from '@salesforce/schema/Parts_Order_Line_Item__c.Id';
import Name_FIELD from '@salesforce/schema/Parts_Order_Line_Item__c.Name';
import Quantity_Requested__c_FIELD from '@salesforce/schema/Parts_Order_Line_Item__c.Quantity_Requested__c';
import Ordered_Product_AMOSProductCode__c_FIELD from '@salesforce/schema/Parts_Order_Line_Item__c.Ordered_Product__r.AMOSProductCode__c';


const COLUMNS = [
    { label: 'Id', fieldName: 'Id' },
    { label: 'Name', fieldName: 'Name' },
    { label: 'Quantity Requested', fieldName: 'Quantity_Requested__c'},
    { label: 'AMOSProductCode', fieldName: 'Ordered_Product__r.AMOSProductCode__c'}
    
];

export default class orderPlacement extends LightningElement {
partsOrderId;
partsOrderNumber;
columns = COLUMNS;
lineItemArr2;
strSearchPartsOrder = '';

handleKeyChange(event) {
    this.strSearchPartsOrder = event.target.value;
}

handleSearch() {
    serachPartsOrder({searchKey : this.strSearchPartsOrder})
    .then(result => {
        
        var arr = new Array(result);
        
        this.partsOrderId = arr[0].Id;
        this.partsOrderNumber = arr[0].Parts_Order_Number__c;
        
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
}