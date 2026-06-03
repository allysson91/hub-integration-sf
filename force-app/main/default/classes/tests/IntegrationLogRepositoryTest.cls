@IsTest
private class IntegrationLogRepositoryTest {

    @IsTest
    static void insertLogs_devePersistirRegistros() {
        IntegrationLogDTO log = IntegrationLogDTO.create()
            .forIntegration('Hub Salesforce')
            .forOperation('GET /cep/:cep')
            .withHttp('GET', 'callout:Hub_Salesforce_Principal/api/cep/01001000', 200)
            .withPayloads(null, '{"ok":true}')
            .success();

        Test.startTest();
        new IntegrationLogRepository().insertLogs(new List<IntegrationLogDTO>{ log });
        Test.stopTest();

        Integration_Log__c record = [
            SELECT IntegrationName__c, Operation__c, Status__c, HttpMethod__c, StatusCode__c
            FROM Integration_Log__c
            LIMIT 1
        ];

        System.assertEquals('Hub Salesforce', record.IntegrationName__c);
        System.assertEquals('GET /cep/:cep', record.Operation__c);
        System.assertEquals(IntegrationLogConstants.STATUS_SUCCESS, record.Status__c);
        System.assertEquals('GET', record.HttpMethod__c);
        System.assertEquals(200, record.StatusCode__c);
    }
}
