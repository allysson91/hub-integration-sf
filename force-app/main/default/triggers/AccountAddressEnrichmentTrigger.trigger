trigger AccountAddressEnrichmentTrigger on Account (after insert, after update) {
    AccountAddressEnrichmentTriggerHandler handler =
        new AccountAddressEnrichmentTriggerHandler();

    if (Trigger.isInsert) {
        handler.afterInsert(Trigger.new);
    }

    if (Trigger.isUpdate) {
        handler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}
