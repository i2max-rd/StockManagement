trigger partsMarketFactorTrigger on Product2 (before insert, before update, before delete, after insert, after update, after delete) {

    if (Trigger.isBefore) { 
        if (Trigger.isDelete) { 

        } else { 
            Set<String> marketFactorSACSet = new Set<String>();
            Set<String> productSACSet = new Set<String>(); 
            
            for(Product2 p : Trigger.new) { 
                productSACSet.add(p.AMOSSAC__c);
                System.debug(productSACSet);
            }

            List<Parts_Market_Factor__c> factorList = [SELECT Id, Name, SAC__c, Market_Factor__c FROM Parts_Market_Factor__c WHERE SAC__c in :productSACSet];
            System.debug(factorList);
            
        

        }
    } else { 

    }

}