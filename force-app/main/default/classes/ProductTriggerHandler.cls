public without sharing class ProductTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        List<Product2> partItems = ProductTriggerHelper.getPartItemsList(Trigger.new);
        if (partItems.size() > 0) {
            ProductTriggerHelper.createPartsMarketFactors(partItems);
            ProductTriggerHelper.updateNRRP(partItems, null);
        }
    }

    public override void beforeUpdate() {
        Map<Id, SObject> newPartItems = ProductTriggerHelper.getPartItemsMap(Trigger.newMap);
        Map<Id, SObject> oldPartItems = ProductTriggerHelper.getPartItemsMap(Trigger.oldMap);
        if (newPartItems.size() > 0 && oldPartItems.size() > 0) {
            ProductTriggerHelper.updateNRRP(newPartItems.values(), oldPartItems);
        }
    }

    public override void afterInsert() {
    }

    public override void afterUpdate() {
    }
}