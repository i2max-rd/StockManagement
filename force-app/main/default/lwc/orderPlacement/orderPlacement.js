import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import findPartLineItem from '@salesforce/apex/searchOrderedParts.findPartLineItem';
import getPartsOrderLineItem from '@salesforce/apex/searchOrderedParts.getPartsOrderLineItem';
import generateBody from '@salesforce/apex/SendPartOrderToAMOS.generateBody';

// const columns = [
//     { 
//         label: "Parts No",
//         fieldName: 'Parts_Order_Number__c'
//     },
//     { 
//         label: "Name",
//         fieldName: 'Name'
//     },{ 
//         label: "Id",
//         fieldName: 'Id'
//     }
// ];
export default class orderPlacement extends LightningElement { 

    searchKey = '';
    searchData;
    // columns = columns;
    errorMsg = '';
    selectedRows = [];
    lineItems;
    idValue;
    // check = false;

    selectedRecordId; 

    handlePartName(event) { 
       this.errorMsg = '';
       const searchKey = event.target.value;
       this.searchKey = searchKey;
    }

    handleSearch() { 

        findPartLineItem({searchKey : this.searchKey})
            .then(result => { 

                this.searchData = result;
                
                this.idValue = result[0].Id;
                
                console.log(result[0].Id);
                console.log(this.searchData);
                // this.check = true;
                getPartsOrderLineItem({partsOrderId: this.idValue})
                    .then(result => { 
                            this.lineItems = result;
                            console.log(this.lineItems);
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
        generateBody ({productRequestId: this.idValue})
            .then(result => { 
                console.log(result);
            })
    }
}