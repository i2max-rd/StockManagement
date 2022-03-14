trigger MarketFactorTrigger on Parts_Market_Factor__c (after update) {
    
    Map<String, Id> marketFactorMap = new Map<String, Id>();

    for (Parts_Market_Factor__c mf : Trigger.new) {
    marketFactorMap.put(mf.SAC__c, mf.Id);
    Product2[] pList = [SELECT Id, AMOSSAC__c, MSRP__c, NRRP__c FROM Product2 WHERE AMOSSAC__c IN :marketFactorMap.keySet()];
    System.debug('pList : ' + pList);
    for(Product2 p : pList){
            p.NRRP__c = p.MSRP__c * mf.Market_Factor__c;
            System.debug('p.NRRP__c : ' + p.NRRP__c);
        }
        update pList;
    }
}
