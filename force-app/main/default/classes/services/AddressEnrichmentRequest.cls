public with sharing class AddressEnrichmentRequest {
    public String cep { get; private set; }
    public Id recordId { get; private set; }

    public AddressEnrichmentRequest(String cep, Id recordId) {
        this.cep = cep;
        this.recordId = recordId;
    }
}
