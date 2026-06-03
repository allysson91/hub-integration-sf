public with sharing class IntegrationLogContext {

    public Id recordId { get; private set; }
    public String source { get; private set; }
    public String correlationId { get; private set; }

    public static IntegrationLogContext create() {
        return new IntegrationLogContext();
    }

    public static IntegrationLogContext fromAddressRequest(AddressEnrichmentRequest request) {
        if (request == null) {
            return create();
        }

        return create()
            .forRecord(request.recordId)
            .fromSource(request.source)
            .withCorrelationId(request.correlationId);
    }

    public IntegrationLogContext forRecord(Id recordId) {
        this.recordId = recordId;
        return this;
    }

    public IntegrationLogContext fromSource(String source) {
        this.source = source;
        return this;
    }

    public IntegrationLogContext withCorrelationId(String correlationId) {
        this.correlationId = correlationId;
        return this;
    }

    public IntegrationLogDTO applyTo(IntegrationLogDTO log) {
        if (log == null) {
            return log;
        }

        log.forRecord(recordId)
            .fromSource(String.isBlank(source) ? log.source : source)
            .withCorrelationId(correlationId);

        return log;
    }
}
