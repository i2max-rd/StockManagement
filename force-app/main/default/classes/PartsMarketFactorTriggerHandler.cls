public with sharing class PartsMarketFactorTriggerHandler implements GME_ITriggerHandler{
    public static Boolean TriggerDisabled = false;

    public Boolean IsDisabled() { 
        if (GME_TriggerSettings__c.getOrgDefaults().PartsMarketFactorTriggerDisabled__c == true) { 
            return true;
        } else { 
            return TriggerDisabled;
        }
    }
    public void BeforeInsert(List<SObject> newItems) {
    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }

    public void BeforeDelete(Map<Id, SObject> oldItems) {
    }

    public void AfterInsert(Map<Id, SObject> newItems) { 
        if (IsDisabled()) return;
        updatePartsNRRP(newItems);
    }

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) { 
        updatePartsNRRP(newItems);
    }
    public void AfterDelete(Map<Id, SObject> oldItems) {
    }

    public void AfterUndelete(Map<Id, SObject> oldItems) {
    }
    public static void updatePartsNRRP(Map<Id, SObject> newItems) { 
        Set<String> marketFactorSacSet = new Set<String>();
        for (Parts_Market_Factor__c factor : (List<Parts_Market_Factor__c>) newItems.values()) { 
            marketFactorSacSet.add(factor.SAC__c);
        }

        List<Product2> updateParts = new List<Product2>();
        Map<Id, Product2> targetParts = new Map<Id, Product2>(
            [
                SELECT Id, NSC_Department__c, AMOSSAC__c, MSRP__c, NRRP__c
                FROM Product2
                WHERE AMOSSAC__c IN :marketFactorSacSet AND RecordType.Name = 'Part'
            ]
        );

        for (Product2 part : targetParts.values()) { 
            for (Parts_Market_Factor__c factor : (List<Parts_Market_Factor__c>) newItems.values()) { 
                if (factor.SAC__c == part.AMOSSAC__c) { 
                    if (part.MSRP__c != null) { 
                        part.NRRP__c = factor.Market_Factor__c = part.MSRP__c;                    
                        break;
                    }
                }
            }
        }
        if (updateParts.size() > 0) { 
            Database.update(updateParts);
        }
    }
}
