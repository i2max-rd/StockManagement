public with sharing class TransactionController {
    @AuraEnabled
    public static void createTrans(Parts_Inventory_Transaction__c trans){
        String errorMessage;
        try {
            insert trans;
        } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
        }
    }

}


// AuraHandleException 으로 try catch 사용