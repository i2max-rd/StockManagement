@isTest
private class MarketFactorTriggerTest {
    @TestSetup
    static void makeData(){
        Product2 product = new Product2(Name = 'Test Product',
                                        AMOSSAC__c = '20a',
                                        MSRP__c = 100,
                                        AMOSProductCode__c = 'TEST200');

        insert product;  
    }

    @isTest
    static void updateMarketFactor(){

        Parts_Market_Factor__c mf = new Parts_Market_Factor__c(SAC__c = '20a', Market_Factor__c = 2);
        insert mf;     

        mf.Market_Factor__c = 3;

        Test.startTest();
        Database.SaveResult result = Database.update(mf, true);
        Test.stopTest();
        
        if (result.isSuccess()) {
            System.debug(result.getId());
        }
        
        if(result.getErrors().size() > 0){
            System.debug(result.getErrors()[0].getMessage());
        }
    }

}
