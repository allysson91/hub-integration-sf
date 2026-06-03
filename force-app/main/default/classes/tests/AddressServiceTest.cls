@IsTest
private class AddressServiceTest {

    @IsTest
    static void enrichAddress_deveAtualizarBillingAddress_quandoRecordIdForAccount() {
        Account account = new Account(Name = 'Empresa CEP', Phone = '11999990000');
        insert account;

        mockHubSalesforceService();

        Test.startTest();
        IAddressService service =
            (IAddressService) Application.Service.newInstance(IAddressService.class);
        service.enrichAddress('01001-000', account.Id);
        Test.stopTest();

        Account updatedAccount = [
            SELECT BillingStreet, BillingCity, BillingStateCode, BillingCountryCode, BillingPostalCode
            FROM Account
            WHERE Id = :account.Id
        ];

        System.assertEquals('Praca da Se\nlado impar', updatedAccount.BillingStreet);
        System.assertEquals('Sao Paulo', updatedAccount.BillingCity);
        System.assertEquals('SP', updatedAccount.BillingStateCode);
        System.assertEquals('BR', updatedAccount.BillingCountryCode);
        System.assertEquals('01001000', updatedAccount.BillingPostalCode);
    }

    @IsTest
    static void enrichAddress_deveAtualizarMailingAddress_quandoRecordIdForContact() {
        Contact contact = new Contact(LastName = 'Contato CEP');
        insert contact;

        mockHubSalesforceService();

        Test.startTest();
        IAddressService service =
            (IAddressService) Application.Service.newInstance(IAddressService.class);
        service.enrichAddress('01001000', contact.Id);
        Test.stopTest();

        Contact updatedContact = [
            SELECT MailingStreet, MailingCity, MailingStateCode, MailingCountryCode, MailingPostalCode
            FROM Contact
            WHERE Id = :contact.Id
        ];

        System.assertEquals('Praca da Se\nlado impar', updatedContact.MailingStreet);
        System.assertEquals('Sao Paulo', updatedContact.MailingCity);
        System.assertEquals('SP', updatedContact.MailingStateCode);
        System.assertEquals('BR', updatedContact.MailingCountryCode);
        System.assertEquals('01001000', updatedContact.MailingPostalCode);
    }

    @IsTest
    static void enrichAddress_deveFalhar_quandoObjetoNaoForSuportado() {
        Opportunity opportunity = new Opportunity(
            Name = 'Opp CEP',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10)
        );
        insert opportunity;

        mockHubSalesforceService();

        try {
            IAddressService service =
                (IAddressService) Application.Service.newInstance(IAddressService.class);
            service.enrichAddress('01001000', opportunity.Id);
            System.assert(false, 'Era esperado erro para objeto nao suportado.');
        } catch (AddressException e) {
            System.assert(e.getMessage().contains('Objeto nao suportado'));
        }
    }

    private static void mockHubSalesforceService() {
        Application.Service.setMock(IHubSalesforceService.class, new HubSalesforceServiceMock());
    }

    private class HubSalesforceServiceMock implements IHubSalesforceService {
        public HubSalesforceCepDTO getCep(String cep) {
            HubSalesforceCepDTO response = new HubSalesforceCepDTO();
            response.cep = '01001000';
            response.logradouro = 'Praca da Se';
            response.complemento = 'lado impar';
            response.bairro = 'Se';
            response.localidade = 'Sao Paulo';
            response.uf = 'SP';
            response.ibge = '3550308';
            response.gia = '1004';
            response.ddd = '11';
            response.siafi = '7107';
            response.erro = false;
            return response;
        }
    }
}
