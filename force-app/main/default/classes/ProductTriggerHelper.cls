public without sharing class ProductTriggerHelper {
    public static List<Product2> getPartItemsList(List<SObject> items) {
        Id partRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Parts').getRecordTypeId();

        List<Product2> partItems = new List<Product2>();
        for (Product2 item : (List<Product2>) items) {
            if (item.RecordTypeId == partRecordTypeId && String.isNotEmpty(item.AMOSSAC__c)) {
                partItems.add(item);
            }
        }
        return partItems;
    }

    public static Map<Id, SObject> getPartItemsMap(Map<Id, SObject> items) {
        Id partRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Parts').getRecordTypeId();

        Map<Id, SObject> partItems = new Map<Id, SObject>();
        for (Product2 item : (List<Product2>) items.values()) {
            if (item.RecordTypeId == partRecordTypeId && String.isNotEmpty(item.AMOSSAC__c)) {
                partItems.put(item.Id, item);
            }
        }
        return partItems;
    }

    public static void createPartsMarketFactors(List<Product2> partsList) { 
        Set<String> newPartsSacSet = new Set<String>();
        for (Product2 prod : partsList) {
            newPartsSacSet.add(prod.AMOSSAC__c);
        }

        // Get Factors already exist
        Set<String> factorsNscSacSet = new Set<String>();
        for (Parts_Market_Factor__c factor : [
            SELECT SAC__c
            FROM Parts_Market_Factor__c
            WHERE SAC__c IN :newPartsSacSet
        ]) {

            factorsNscSacSet.add(factor.SAC__c);
        } 

        List<Parts_Market_Factor__c> insertList = new List<Parts_Market_Factor__c>();
        Set<String> insertSet = new Set<String>();
        for (Product2 part : partsList) {
            if (
                !factorsNscSacSet.contains(part.AMOSSAC__c) &&
                !insertSet.contains(part.AMOSSAC__c)
            ) {
                insertSet.add(part.AMOSSAC__c);
                insertList.add(
                    new Parts_Market_Factor__c(
                        SAC__c = part.AMOSSAC__c,
                        Market_Factor__c = 1
                    )
                );
            }
        }
        if (!insertList.isEmpty()) {
            Database.insert(insertList);
        }
    }

    public static void updateNRRP(List<SObject> newItems, Map<Id, SObject> oldItems) { 
        Set<String> partsSacSet = new Set<String>();
        for (Product2 prod : (List<Product2>) newItems) { 
            partsSacSet.add(prod.AMOSSAC__c);
        }
        List<Parts_Market_Factor__c> partsMarketFactorList = [
            // SELECT Id, NSC__c, SAC__c, MarketFactor__c
            SELECT Id, SAC__c, Market_Factor__c
            FROM Parts_Market_Factor__c
            WHERE SAC__c IN :partsSacSet
        ];

        Map<String, Parts_Market_Factor__c> partsMarketFactorMap = new Map<String, Parts_Market_Factor__c>();
        for (Parts_Market_Factor__c factor : partsMarketFactorList) {
            partsMarketFactorMap.put(factor.SAC__c, factor);
            // partsMarketFactorMap.put(factor.SAC__c + factor.NSC__c, factor);
        }

        if (Trigger.isUpdate) {
            for (Product2 prod : (List<Product2>) newItems) {
                if (prod.MSRP__c != ((Product2) oldItems.get(prod.Id)).MSRP__c) {
                    prod.NRRP__c =
                        prod.MSRP__c * partsMarketFactorMap.get(prod.AMOSSAC__c).Market_Factor__c;
                }
            }
        } else {
            for (Product2 prod : (List<Product2>) newItems) {
                if (partsMarketFactorMap.containsKey(prod.AMOSSAC__c)) {
                    prod.NRRP__c =
                        prod.MSRP__c * partsMarketFactorMap.get(prod.AMOSSAC__c).Market_Factor__c;
                }
            }
        }
    }
    public static void activateParts(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        Map<Id, SObject> activatedParts = new Map<Id, SObject>();
        Map<Id, SObject> deactivatedParts = new Map<Id, SObject>();
        for (Product2 prod : (List<Product2>) oldItems.values()) {
            if (prod.IsActive == true && prod.MSRP__c != 0) {
                activatedParts.put(prod.Id, prod);
            } else if (prod.IsActive == false && prod.MSRP__c == 0) {
                deactivatedParts.put(prod.Id, prod);
            }
        }

        // Activate
        for (Product2 prod : (List<Product2>) deactivatedParts.values()) {
            if (((Product2) newItems.get(prod.Id)).MSRP__c != 0) {
                ((Product2) newItems.get(prod.Id)).IsActive = true;
            }
        }

        // Deactivate
        for (Product2 prod : (List<Product2>) activatedParts.values()) {
            if (((Product2) newItems.get(prod.Id)).MSRP__c == 0) {
                ((Product2) newItems.get(prod.Id)).IsActive = false;
            }
        }
    }
}