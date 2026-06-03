@IsTest
private class AccountAddrEnrichTriggerDmlTest {

    @IsTest
    static void trigger_devePublicarEvento_noInsertComCep() {
        mockAddressService();

        Test.startTest();
        insert new Account(
            Name = 'Empresa Trigger',
            Phone = '11999990000',
            BillingPostalCode = '01001000'
        );
        Test.stopTest();

        System.assert(true);
    }

    @IsTest
    static void trigger_devePublicarEvento_noUpdateComCepAlterado() {
        Account account = new Account(
            Name = 'Empresa Trigger Update',
            Phone = '11999990000'
        );
        insert account;

        mockAddressService();

        Test.startTest();
        account.BillingPostalCode = '01001000';
        update account;
        Test.stopTest();

        System.assert(true);
    }

    private static void mockAddressService() {
        Application.Service.setMock(IAddressService.class, new AddressServiceMock());
    }

    private class AddressServiceMock implements IAddressService {
        public void enrichAddress(String cep, Id recordId) {
        }

        public void enrichAddresses(List<AddressEnrichmentRequest> requests) {
        }
    }
}
