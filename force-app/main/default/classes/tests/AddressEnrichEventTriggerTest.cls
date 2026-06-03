@IsTest
private class AddressEnrichEventTriggerTest {

    @IsTest
    static void afterInsert_deveEnfileirarQueueableComEventosValidos() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        Id accountId = TestDataFactory.account().build().Id;
        IAddressService addressServiceMock =
            (IAddressService) mocks.mock(IAddressService.class);

        Application.Service.setMock(IAddressService.class, addressServiceMock);

        List<Address_Enrichment_Requested__e> events = new List<Address_Enrichment_Requested__e>{
            new Address_Enrichment_Requested__e(
                Cep__c = '01001000',
                RecordId__c = String.valueOf(accountId)
            ),
            new Address_Enrichment_Requested__e(
                Cep__c = null,
                RecordId__c = String.valueOf(accountId)
            )
        };

        Test.startTest();
        new AddressEnrichmentRequestedTriggerHandler().afterInsert(events);
        Test.stopTest();

        ((IAddressService) mocks.verify(addressServiceMock))
            .enrichAddresses((List<AddressEnrichmentRequest>) fflib_Match.anyObject());
    }

    @IsTest
    static void afterInsert_naoDeveEnfileirarQueueable_quandoEventosInvalidos() {
        List<Address_Enrichment_Requested__e> events = new List<Address_Enrichment_Requested__e>{
            new Address_Enrichment_Requested__e(
                Cep__c = '',
                RecordId__c = ''
            )
        };

        Test.startTest();
        new AddressEnrichmentRequestedTriggerHandler().afterInsert(events);
        Test.stopTest();

        System.assertEquals(0, Limits.getQueueableJobs());
    }
}
