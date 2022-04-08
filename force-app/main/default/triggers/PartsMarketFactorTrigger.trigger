trigger PartsMarketFactorTrigger on Parts_Market_Factor__c (
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    GME_TriggerDispatcher.Run(new PartsMarketFactorTriggerHandler());
}