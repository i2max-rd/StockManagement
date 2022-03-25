public with sharing class PartsOrderController {
    @AuraEnabled(Cacheable = true)
    public static Parts_Order__c serachPartsOrder(String searchKey) {
        String strKey = '%' + searchKey + '%';
        Parts_Order__c partsOrder = [ SELECT Id, Parts_Order_Number__c,  (SELECT Id, Name, 	Quantity_Requested__c, Ordered_Product__r.AMOSProductCode__c, Ordered_Product__r.AMOSSAC__c FROM Parts_Order_Line_Item__r)  FROM Parts_Order__c WHERE Parts_Order_Number__c LIKE: strKey LIMIT 1 ];
        if(partsOrder.Id == null) {
            throw new AuraHandledException('No Record Found');
        }
        return partsOrder; 
    }
}