public with sharing class PartsOrderController {
    @AuraEnabled(Cacheable = true)
    public static Parts_Order__c searchPartsOrder(String searchKey) {
        String strKey = '%' + searchKey + '%';
        Parts_Order__c partsOrder = [ SELECT Id, Parts_Order_Number__c, DistributeCode__c, DealerCode__c, OrderType__c, Description__c, (SELECT Id, Name, Parts_Order_Line_Item_Number__c,	QuantityRequested__c,  Confirmed_Quantity__c, OrderedProduct__r.AMOSProductCode__c, OrderedProduct__r.AMOSSAC__c FROM Parts_Order_Line_Item__r)  FROM Parts_Order__c WHERE Parts_Order_Number__c LIKE: strKey LIMIT 1 ];
        if(partsOrder.Id == null) {
            throw new AuraHandledException('No Record Found');
        }
        return partsOrder; 
    }
}