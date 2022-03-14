trigger ProductTrigger on Product2 (before insert, before update) {
    
    Map<String, Id> productMap = new Map<String, Id>();
    for (Product2 p : Trigger.new) {
    productMap.put(p.AMOSSAC__c, p.Id);
    
    Parts_Market_Factor__c[] fList = [SELECT Id, Market_Factor__c, SAC__c FROM Parts_Market_Factor__c WHERE SAC__c IN :productMap.keySet()];
    Set<String> marketFactorSac = new Set<String>();
    for(Parts_Market_Factor__c f : fList){
        marketFactorSac.add(f.SAC__c);
    }
            
    if(!marketFactorSac.contains(p.AMOSSAC__c)){
        Parts_Market_Factor__c marketFactor = new Parts_Market_Factor__c();
        for(String sac : productMap.keySet()){
            marketFactor.SAC__c = sac;
            marketFactor.Market_Factor__c = 1;
            p.NRRP__c = p.MSRP__c * marketFactor.Market_Factor__c;
            
        }
        System.debug(marketFactor);
        insert marketFactor;
    }else{
        for(Parts_Market_Factor__c f : fList){
        p.NRRP__c = p.MSRP__c * f.Market_Factor__c;
        }
    }
    }
}




    
    
