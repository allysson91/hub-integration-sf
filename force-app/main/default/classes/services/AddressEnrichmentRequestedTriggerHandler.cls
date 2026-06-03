public with sharing class AddressEnrichmentRequestedTriggerHandler {

    public void afterInsert(List<Address_Enrichment_Requested__e> events) {
        List<AddressEnrichmentRequest> requests = new List<AddressEnrichmentRequest>();

        for (Address_Enrichment_Requested__e eventRecord : events) {
            if (String.isBlank(eventRecord.Cep__c) || String.isBlank(eventRecord.RecordId__c)) {
                continue;
            }

            try {
                requests.add(
                    new AddressEnrichmentRequest(
                        eventRecord.Cep__c,
                        (Id) eventRecord.RecordId__c,
                        eventRecord.Source__c,
                        eventRecord.CorrelationId__c
                    )
                );
            } catch (StringException ex) {
                continue;
            }
        }

        if (!requests.isEmpty()) {
            System.enqueueJob(new AddressEnrichmentQueueable(requests));
        }
    }
}
