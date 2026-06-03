@IsTest
private class HubSalesforceServiceTest {

    @IsTest
    static void getCep_deveRetornarDto_quandoHubResponderSucesso() {
        Test.setMock(HttpCalloutMock.class, new CepSuccessMock());

        IHubSalesforceService service =
            (IHubSalesforceService) Application.Service.newInstance(IHubSalesforceService.class);

        Test.startTest();
        HubSalesforceCepDTO response = service.getCep('01001-000');
        Test.stopTest();

        System.assertEquals('01001-000', response.cep);
        System.assertEquals('Praca da Se', response.logradouro);
        System.assertEquals('Sao Paulo', response.localidade);
        System.assertEquals('SP', response.uf);
    }

    @IsTest
    static void getCep_devePropagarErro_quandoHubResponderErro() {
        Test.setMock(HttpCalloutMock.class, new CepErrorMock());

        IHubSalesforceService service =
            (IHubSalesforceService) Application.Service.newInstance(IHubSalesforceService.class);

        Test.startTest();
        try {
            service.getCep('01001000');
            System.assert(false, 'Era esperado erro do Hub Salesforce.');
        } catch (HubSalesforceException e) {
            System.assert(e.getMessage().contains('Status: 404'));
        }
        Test.stopTest();
    }

    private class CepSuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            System.assertEquals(
                'callout:Hub_Salesforce_Principal/api/cep/01001000',
                request.getEndpoint()
            );
            System.assertEquals('GET', request.getMethod());
            System.assertEquals('application/json', request.getHeader('Accept'));

            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody(
                '{"success":true,"message":"Endereco encontrado com sucesso.","data":' +
                '{"cep":"01001-000","street":"Praca da Se","complement":"lado impar",' +
                '"neighborhood":"Se","city":"Sao Paulo","state":"SP","stateName":"Sao Paulo",' +
                '"region":"Sudeste","ibge":"3550308","gia":"1004","ddd":"11","siafi":"7107"}}'
            );
            return response;
        }
    }

    private class CepErrorMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(404);
            response.setBody('{"message":"CEP nao encontrado"}');
            return response;
        }
    }
}
