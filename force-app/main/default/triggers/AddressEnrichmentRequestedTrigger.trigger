trigger AddressEnrichmentRequestedTrigger on Address_Enrichment_Requested__e (after insert) {
    new AddressEnrichmentRequestedTriggerHandler().afterInsert(Trigger.new);
}
