public with sharing class TransactionController {
    @AuraEnabled
    public static void createTrans(Decimal UQuantity, Decimal CQuantity, Datetime TDate, string Status, string Description, string PInventory){
        
        Parts_Inventory_Transaction__c p = new Parts_Inventory_Transaction__c(

            Updated_Quantity__c = UQuantity,
            Confirmed_Quantity__c = CQuantity,
            Transaction_Date__c = TDate,
            Status__c = Status,
            Description__c = Description,
            Parts_Inventory__c = PInventory
        );
        insert p;

    }

}
