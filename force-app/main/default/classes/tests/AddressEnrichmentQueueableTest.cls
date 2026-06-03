@IsTest
private class AddressEnrichmentQueueableTest {

    @IsTest
    static void execute_deveChamarServiceEAtualizarAccount() {
        Account account = new Account(Name = 'Empresa Queueable', Phone = '11999990000');
        insert account;

        Test.setMock(HttpCalloutMock.class, new CepSuccessMock());

        Test.startTest();
        System.enqueueJob(new AddressEnrichmentQueueable('01001000', account.Id));
        Test.stopTest();

        Account updatedAccount = [
            SELECT BillingCity, BillingStateCode, BillingCountryCode, BillingPostalCode
            FROM Account
            WHERE Id = :account.Id
        ];

        System.assertEquals('Sao Paulo', updatedAccount.BillingCity);
        System.assertEquals('SP', updatedAccount.BillingStateCode);
        System.assertEquals('BR', updatedAccount.BillingCountryCode);
        System.assertEquals('01001000', updatedAccount.BillingPostalCode);
    }

    private class CepSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody(
                '{"success":true,"message":"Endereco encontrado com sucesso.","data":' +
                '{"cep":"01001000","street":"Praca da Se","complement":"lado impar",' +
                '"neighborhood":"Se","city":"Sao Paulo","state":"SP","stateName":"Sao Paulo",' +
                '"region":"Sudeste","ibge":"3550308","gia":"1004","ddd":"11","siafi":"7107"}}'
            );
            return response;
        }
    }
}
