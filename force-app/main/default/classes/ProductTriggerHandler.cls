/**
 * @description       :
 * @author            : Seongho Kang
 * @group             : gme-service-i2max
 * @last modified on  : 03-09-2022
 * @last modified by  : Seongho Kang
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   11-17-2021   Seongho Kang   Initial Version
 * 1.1	 11-19-2021	  Seongho Kang   Fix NRRP update logic
 * 1.2   11-22-2021   Seongho Kang   Error handling flags added
 * 1.3   12-29-2021   Seongho Kang   Add inventory creation
 * 2.0   01-10-2021	  Seongho Kang   Replace trigger handler, Implement helper class
 * 2.1   01-24-2022   Seongho Kang   Remove pricebook entry
 **/
public without sharing class ProductTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        List<Product2> partItems = ProductTriggerHelper.getPartItemsList(Trigger.new);
        if (partItems.size() > 0) {
            ProductTriggerHelper.createPartsMarketFactors(partItems);
            // ProductTriggerHelper.createPartsPriceMatrix(partItems);
            ProductTriggerHelper.updateNRRP(partItems, null);
            // ProductTriggerHelper.updateCountry(partItems);
        }
    }

    public override void beforeUpdate() {
        Map<Id, SObject> newPartItems = ProductTriggerHelper.getPartItemsMap(Trigger.newMap);
        Map<Id, SObject> oldPartItems = ProductTriggerHelper.getPartItemsMap(Trigger.oldMap);
        if (newPartItems.size() > 0 && oldPartItems.size() > 0) {
            ProductTriggerHelper.updateNRRP(newPartItems.values(), oldPartItems);
            ProductTriggerHelper.activateParts(newPartItems, oldPartItems);
        }
    }

    public override void afterInsert() {
    }

    public override void afterUpdate() {
    }
}