public with sharing class IntegrationLogRepository implements IIntegrationLogRepository {

    public void insertLogs(List<IntegrationLogDTO> logs) {
        List<Integration_Log__c> records = IntegrationLogMapper.toRecords(logs);

        if (records.isEmpty()) {
            return;
        }

        Database.insert(records, false);
    }
}
