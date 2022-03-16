@isTest
private class ProductTriggerTest {
@TestSetup
static void makeData(){
    Parts_Market_Factor__c mf = new Parts_Market_Factor__c(SAC__c = '20a', Market_Factor__c = 2);
    insert mf;                                                       
    }

    @isTest
    static void upsertProductWithRelatedSac() {

        Parts_Market_Factor__c mf = [SELECT Id, SAC__c, Market_Factor__c FROM Parts_Market_Factor__c WHERE SAC__c = '20a'];
        Product2 product = new Product2(Name = 'Test Product',
        AMOSSAC__c = '20a',
        MSRP__c = 100,
        NRRP__c = 100 * mf.Market_Factor__c,
        AMOSProductCode__c = 'TEST200');
        
        Test.startTest();
        System.debug('AMOSSAC__c : ' + product.AMOSSAC__c);
        System.debug('MSRP__c : ' + product.MSRP__c);
        System.debug('NRRP__c : ' + product.NRRP__c);
        Database.UpsertResult result = Database.upsert(product, true);
        Test.stopTest();
        
        if (result.isSuccess()) {
            System.debug(result.getId());
        }
        
        if(result.getErrors().size() > 0){
            System.debug(result.getErrors()[0].getMessage());
        }
    }

    @isTest
    static void upsertProductWithoutRelatedSac() {

        Product2 product = new Product2(Name = 'Test Product',
        AMOSSAC__c = ' ',
        MSRP__c = 100,
        NRRP__c = 100 * 1,
        AMOSProductCode__c = 'TEST200');
        
        Test.startTest();
        System.debug('AMOSSAC__c : ' + product.AMOSSAC__c);
        System.debug('MSRP__c : ' + product.MSRP__c);
        System.debug('NRRP__c : ' + product.NRRP__c);
        Database.UpsertResult result = Database.upsert(product, true);
        Test.stopTest();
        
        if (result.isSuccess()) {
            System.debug(result.getId());
        }
        
        if(result.getErrors().size() > 0){
            System.debug(result.getErrors()[0].getMessage());
        }
    }

}
