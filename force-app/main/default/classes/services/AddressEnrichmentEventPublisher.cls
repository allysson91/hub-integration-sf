public with sharing class AddressEnrichmentEventPublisher implements IAddressEnrichmentEventPublisher {

    public void publish(List<Address_Enrichment_Requested__e> events) {
        if (events == null || events.isEmpty()) {
            return;
        }

        List<Database.SaveResult> results = EventBus.publish(events);

        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                throw new AddressEnrichmentEventPublishException(
                    'Falha ao publicar Address_Enrichment_Requested__e.'
                );
            }
        }
    }
}
