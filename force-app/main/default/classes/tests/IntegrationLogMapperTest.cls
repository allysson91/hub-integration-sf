@IsTest
private class IntegrationLogMapperTest {

    @IsTest
    static void toRecord_deveMapearCamposPrincipais() {
        Id accountId = TestDataFactory.account().build().Id;

        Integration_Log__c record = IntegrationLogMapper.toRecord(
            IntegrationLogDTO.create()
                .forIntegration('Hub Salesforce')
                .forOperation('GET /cep/:cep')
                .withHttp('GET', 'callout:Hub_Salesforce_Principal/api/cep/01001000', 200)
                .withPayloads(null, '{"ok":true}')
                .forRecord(accountId)
                .withCorrelationId('corr-123')
                .fromSource('AddressQueueable')
                .took(150)
                .success()
        );

        System.assertEquals('Hub Salesforce', record.IntegrationName__c);
        System.assertEquals('GET /cep/:cep', record.Operation__c);
        System.assertEquals('GET', record.HttpMethod__c);
        System.assertEquals(200, record.StatusCode__c);
        System.assertEquals('{"ok":true}', record.ResponseBody__c);
        System.assertEquals(String.valueOf(accountId), record.RecordId__c);
        System.assertEquals('corr-123', record.CorrelationId__c);
        System.assertEquals('AddressQueueable', record.Source__c);
        System.assertEquals(150, record.DurationMs__c);
        System.assertEquals(IntegrationLogConstants.STATUS_SUCCESS, record.Status__c);
    }

    @IsTest
    static void toRecord_deveTruncarCamposComLimite() {
        String longText = repeat('x', 40000);
        String longEndpoint = repeat('e', 300);

        Integration_Log__c record = IntegrationLogMapper.toRecord(
            IntegrationLogDTO.create()
                .forIntegration(repeat('i', 100))
                .forOperation(repeat('o', 100))
                .withHttp('POST_TOO_LONG', longEndpoint, 500)
                .withPayloads(longText, longText)
                .error(longText)
        );

        System.assertEquals(80, record.IntegrationName__c.length());
        System.assertEquals(80, record.Operation__c.length());
        System.assertEquals(10, record.HttpMethod__c.length());
        System.assertEquals(255, record.Endpoint__c.length());
        System.assertEquals(32768, record.RequestBody__c.length());
        System.assertEquals(32768, record.ResponseBody__c.length());
        System.assertEquals(32768, record.ErrorMessage__c.length());
    }

    private static String repeat(String value, Integer times) {
        String result = '';

        for (Integer index = 0; index < times; index++) {
            result += value;
        }

        return result;
    }
}
