public interface IAddressEnrichmentEventPublisher {
    void publish(List<Address_Enrichment_Requested__e> events);
}
