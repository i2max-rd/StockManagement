import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import findParts from '@salesforce/apex/searchOrderedParts.findParts';
import getPartsOrderLineItem from '@salesforce/apex/searchOrderedParts.getPartsOrderLineItem';


const columns = [
    { 
        label: 'Name',
        fieldName: 'Name'
    }, { 
        label: 'Parts No',
        fieldName: 'Parts_Order_Number__c'
    }, { 
        label: "Id",
        fieldName: 'Id'
    }
];

export default class orderPlacement extends LightningElement { 

    @track searchKey = '';
    searchData;
    columns = columns;
    errorMsg = '';

    handleKeyChange(event) { 
        const searchKey = event.target.value;
        this.searchKey = searchKey;
        this.handleSearch();
    }

    handleSearch() { 
        if(!this.searchKey) { 
            this.errorMsg = 'Please enter part name to search.';
            this.searchData = undefined;
            return;
        }

        findParts({searchKey : this.searchKey})
            .then(result => { 
                this.searchData = result;
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