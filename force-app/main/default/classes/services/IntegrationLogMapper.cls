public with sharing class IntegrationLogMapper {

    private static final Integer TEXT_10 = 10;
    private static final Integer TEXT_18 = 18;
    private static final Integer TEXT_80 = 80;
    private static final Integer TEXT_255 = 255;
    private static final Integer LONG_TEXT = 32768;

    public static Integration_Log__c toRecord(IntegrationLogDTO dto) {
        if (dto == null) {
            throw new IntegrationLogException('Log de integracao nao informado.');
        }

        return new Integration_Log__c(
            IntegrationName__c = truncate(dto.integrationName, TEXT_80),
            Operation__c = truncate(dto.operation, TEXT_80),
            Direction__c = dto.direction,
            Status__c = dto.status,
            HttpMethod__c = truncate(dto.httpMethod, TEXT_10),
            Endpoint__c = truncate(dto.endpoint, TEXT_255),
            StatusCode__c = dto.statusCode,
            RequestBody__c = truncate(dto.requestBody, LONG_TEXT),
            ResponseBody__c = truncate(dto.responseBody, LONG_TEXT),
            ErrorMessage__c = truncate(dto.errorMessage, LONG_TEXT),
            StackTrace__c = truncate(dto.stackTrace, LONG_TEXT),
            RecordId__c = dto.recordId == null ? null : truncate(String.valueOf(dto.recordId), TEXT_18),
            CorrelationId__c = truncate(dto.correlationId, TEXT_80),
            Source__c = truncate(dto.source, TEXT_80),
            DurationMs__c = dto.durationMs,
            RequestedBy__c = dto.requestedBy,
            OccurredAt__c = dto.occurredAt
        );
    }

    public static List<Integration_Log__c> toRecords(List<IntegrationLogDTO> logs) {
        List<Integration_Log__c> records = new List<Integration_Log__c>();

        if (logs == null) {
            return records;
        }

        for (IntegrationLogDTO log : logs) {
            if (log != null) {
                records.add(toRecord(log));
            }
        }

        return records;
    }

    private static String truncate(String value, Integer maxLength) {
        if (value == null || value.length() <= maxLength) {
            return value;
        }

        return value.substring(0, maxLength);
    }
}
