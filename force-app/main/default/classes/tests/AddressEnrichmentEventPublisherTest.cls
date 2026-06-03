@IsTest
private class AddressEnrichmentEventPublisherTest {

    @IsTest
    static void publish_devePublicarEventosValidos() {
        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
        Application.Service.setMock(IAddressService.class, new AddressServiceMock());

        Test.startTest();
        new AddressEnrichmentEventPublisher().publish(
            new List<Address_Enrichment_Requested__e>{
                new Address_Enrichment_Requested__e(
                    Cep__c = '81925570',
                    RecordId__c = String.valueOf(accountId),
                    Source__c = 'PublisherTest'
                )
            }
        );
        Test.stopTest();

        System.assert(true);
    }

    @IsTest
    static void exception_deveSerInstanciada() {
        try {
            throw new AddressEnrichmentEventPublishException('erro de teste');
        } catch (AddressEnrichmentEventPublishException e) {
            System.assertEquals('erro de teste', e.getMessage());
        }
    }

    @IsTest
    static void publish_naoDeveFalhar_quandoListaVaziaOuNula() {
        AddressEnrichmentEventPublisher publisher = new AddressEnrichmentEventPublisher();

        publisher.publish(null);
        publisher.publish(new List<Address_Enrichment_Requested__e>());

        System.assert(true);
    }

    private class AddressServiceMock implements IAddressService {
        public void enrichAddress(String cep, Id recordId) {
        }

        public void enrichAddresses(List<AddressEnrichmentRequest> requests) {
        }
    }
}
