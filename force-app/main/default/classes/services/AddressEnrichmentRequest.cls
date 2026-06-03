public with sharing class AddressEnrichmentRequest {
    public String cep { get; private set; }
    public Id recordId { get; private set; }
    public String source { get; private set; }
    public String correlationId { get; private set; }

    public AddressEnrichmentRequest(String cep, Id recordId) {
        this(cep, recordId, null, null);
    }

    public AddressEnrichmentRequest(String cep, Id recordId, String source, String correlationId) {
        this.cep = cep;
        this.recordId = recordId;
        this.source = source;
        this.correlationId = correlationId;
    }
}
