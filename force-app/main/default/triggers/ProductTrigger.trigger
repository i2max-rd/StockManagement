trigger ProductTrigger on Product2 (before insert, before update) {
    
    Set<String> productSac = new Set<String>();
    Set<String> marketFactorSac = new Set<String>();

    Parts_Market_Factor__c[] fList = [SELECT Id, Market_Factor__c, SAC__c FROM Parts_Market_Factor__c LIMIT 2000];
    List<Parts_Market_Factor__c> newFList = new List<Parts_Market_Factor__c>();
    for(Parts_Market_Factor__c mf : fList){
        marketFactorSac.add(mf.SAC__c);
        newFList.add(mf);
    }

    for (Product2 p : Trigger.new) {
        productSac.add(p.AMOSSAC__c);
    
    if(!marketFactorSac.contains(p.AMOSSAC__c)){
        for(Parts_Market_Factor__c marketFactor : newFList){
            for(String sac : productSac){
                marketFactor.SAC__c = sac;
                marketFactor.Market_Factor__c = 1;
                p.NRRP__c = p.MSRP__c * marketFactor.Market_Factor__c;
            }
            System.debug(marketFactor);
            insert marketFactor;
        }
    }else{
        for(Parts_Market_Factor__c marketFactor : newFList){
        p.NRRP__c = p.MSRP__c * marketFactor.Market_Factor__c;
        }
    }
    }
}
