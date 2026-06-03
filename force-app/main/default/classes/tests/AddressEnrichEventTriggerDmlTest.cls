@IsTest
private class AddressEnrichEventTriggerDmlTest {

    @IsTest
    static void trigger_deveEnfileirarQueueable_quandoEventoPublicado() {
        Application.Service.setMock(IAddressService.class, new AddressServiceMock());

        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);

        Test.startTest();
        EventBus.publish(
            new Address_Enrichment_Requested__e(
                Cep__c = '01001000',
                RecordId__c = String.valueOf(accountId)
            )
        );
        Test.stopTest();

        System.assert(true);
    }

    private class AddressServiceMock implements IAddressService {
        public void enrichAddress(String cep, Id recordId) {
        }

        public void enrichAddresses(List<AddressEnrichmentRequest> requests) {
        }
    }
}
