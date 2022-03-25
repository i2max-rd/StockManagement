public with sharing class searchOrderedParts {
    @AuraEnabled(cacheable=true)
    public static List<Parts_Order__c> findPartLineItem(String searchKey) {
        string key = '%' + searchKey + '%';
        
        list<Parts_Order__c> partsList = [SELECT Id, Name, Parts_Order_Number__c, Order_Date__c FROM Parts_Order__c WHERE  Parts_Order_Number__c LIKE :key];
        
        if (partsList.isEmpty()) {
            throw new AuraHandledException('No Records Found');
        }
        return partsList;
    } 

    @AuraEnabled
    public static List<Parts_Order_Line_Item__c> getPartsOrderLineItem(String partsOrderId) { 
        return [SELECT Id, Name, Ordered_Product__c, Parts_Order_Line_Item_Number__c, Parts_Order__r.Parts_Order_Number__c, Parts_Order__c FROM Parts_Order_Line_Item__c WHERE Parts_Order__c =: partsOrderId];
    }

}