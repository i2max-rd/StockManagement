public with sharing class searchOrderedParts {
    @AuraEnabled(cacheable=true)
    public static list<Parts_Order__c> findParts(String searchKey) {
        string key = '%' + searchKey + '%';

        list<Parts_Order__c> partsList = [SELECT Id, Name, Parts_Order_Number__c FROM Parts_Order__c WHERE Name LIKE :key OR Parts_Order_Number__c LIKE :key];

        if (partsList.isEmpty()) {
            throw new AuraHandledException('No Records Found');
        }
        return partsList;
    } 

    @AuraEnabled
    public static List<Parts_Order_Line_Item__c> getPartsOrderLineItem(String partsOrderId) { 
        return [SELECT Id, Name FROM Parts_Order_Line_Item__c WHERE Parts_Order__c =: partsOrderId];
    }
}
