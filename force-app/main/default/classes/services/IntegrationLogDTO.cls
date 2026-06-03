public with sharing class IntegrationLogDTO {

    public String integrationName;
    public String operation;
    public String direction;
    public String status;
    public String httpMethod;
    public String endpoint;
    public Integer statusCode;
    public String requestBody;
    public String responseBody;
    public String errorMessage;
    public String stackTrace;
    public Id recordId;
    public String correlationId;
    public String source;
    public Long durationMs;
    public Id requestedBy;
    public Datetime occurredAt;

    public static IntegrationLogDTO create() {
        IntegrationLogDTO log = new IntegrationLogDTO();
        log.occurredAt = Datetime.now();
        log.requestedBy = UserInfo.getUserId();
        log.direction = IntegrationLogConstants.DIRECTION_OUTBOUND;
        log.status = IntegrationLogConstants.STATUS_PENDING;
        return log;
    }

    public IntegrationLogDTO forIntegration(String integrationName) {
        this.integrationName = integrationName;
        return this;
    }

    public IntegrationLogDTO forOperation(String operation) {
        this.operation = operation;
        return this;
    }

    public IntegrationLogDTO outbound() {
        this.direction = IntegrationLogConstants.DIRECTION_OUTBOUND;
        return this;
    }

    public IntegrationLogDTO inbound() {
        this.direction = IntegrationLogConstants.DIRECTION_INBOUND;
        return this;
    }

    public IntegrationLogDTO withHttp(String method, String endpoint, Integer statusCode) {
        this.httpMethod = method;
        this.endpoint = endpoint;
        this.statusCode = statusCode;
        return this;
    }

    public IntegrationLogDTO withPayloads(String requestBody, String responseBody) {
        this.requestBody = requestBody;
        this.responseBody = responseBody;
        return this;
    }

    public IntegrationLogDTO forRecord(Id recordId) {
        this.recordId = recordId;
        return this;
    }

    public IntegrationLogDTO withCorrelationId(String correlationId) {
        this.correlationId = correlationId;
        return this;
    }

    public IntegrationLogDTO fromSource(String source) {
        this.source = source;
        return this;
    }

    public IntegrationLogDTO took(Long durationMs) {
        this.durationMs = durationMs;
        return this;
    }

    public IntegrationLogDTO success() {
        this.status = IntegrationLogConstants.STATUS_SUCCESS;
        return this;
    }

    public IntegrationLogDTO pending() {
        this.status = IntegrationLogConstants.STATUS_PENDING;
        return this;
    }

    public IntegrationLogDTO ignored() {
        this.status = IntegrationLogConstants.STATUS_IGNORED;
        return this;
    }

    public IntegrationLogDTO error(Exception ex) {
        this.status = IntegrationLogConstants.STATUS_ERROR;

        if (ex != null) {
            this.errorMessage = ex.getMessage();
            this.stackTrace = ex.getStackTraceString();
        }

        return this;
    }

    public IntegrationLogDTO error(String message) {
        this.status = IntegrationLogConstants.STATUS_ERROR;
        this.errorMessage = message;
        return this;
    }
}
