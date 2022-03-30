import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import findPartLineItem from '@salesforce/apex/searchOrderedParts.findPartLineItem';
import getPartsOrderLineItem from '@salesforce/apex/searchOrderedParts.getPartsOrderLineItem';
import getProductRequestForAMOSCallout from '@salesforce/apex/SendPartOrderToAMOS.getProductRequestForAMOSCallout'

const columns = [
    { 
        label: "Parts No",
        fieldName: 'Parts_Order_Number__c'
    },
    { 
        label: "Name",
        fieldName: 'Name'
    },{ 
        label: "Id",
        fieldName: 'Id'
    }
];
const COLS = [
    { 
        label: "Name",
        fieldName: 'Name'
    }, { 
        label: "Id",
        fieldName: 'Id'
    }, { 
        label: "Part Code",
        fieldName: 'Parts_Order_Line_Item_Number__c'
    }, { 
        label: "AMOS Product Code",
        fieldName: 'Ordered_Product__c'
    }
];

export default class orderPlacement extends LightningElement { 

    searchKey = '';
    searchData;
    columns = columns;
    COLS = COLS;
    errorMsg = '';
    selectedRows = [];
    partsOrderId = '';
    lineItems;
    check = false;


    handlePartName(event) { 
       this.errorMsg = '';
       const searchKey = event.target.value;
       this.searchKey = searchKey;
    }

    handleSearch() { 
        
        findPartLineItem({searchKey : this.searchKey})
            .then(result => { 
                this.searchData = result;
                // console.log(this.searchData);
                // console.log(this.searchKey);
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

    getSelectedName(event) { 
        const selectedRows = event.detail.selectedRows;
        // console.log(JSON.stringify(selectedRows));
        var setRows = [];
        setRows.push(selectedRows[0]);
        this.idValue = setRows[0].Id;
    
        this.check = true;
      
        getPartsOrderLineItem({partsOrderId: this.idValue})
            .then(result => { 
                // console.log(result);
                this.lineItems = result;
                // console.log(this.lineItems);
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

    handleRequestOrder() { 
        
        console.log(this.idValue);
        getProductRequestForAMOSCallout({productRequestId: this.idValue})
            .then(result => { 
                console.log(result);
            })
    }
}