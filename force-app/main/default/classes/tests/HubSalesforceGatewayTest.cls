@IsTest
private class HubSalesforceGatewayTest {

    @IsTest
    static void send_deveMontarEndpointSemBarraInicial() {
        Test.setMock(HttpCalloutMock.class, new SuccessMock('GET', null, false));

        Test.startTest();
        String response = new HubSalesforceGateway().send('GET', 'health', null);
        Test.stopTest();

        System.assertEquals('{"ok":true}', response);
    }

    @IsTest
    static void post_deveEnviarBodyJson() {
        Test.setMock(HttpCalloutMock.class, new SuccessMock('POST', '{"name":"Teste"}', true));

        Test.startTest();
        String response = new HubSalesforceGateway().post('/accounts', '{"name":"Teste"}');
        Test.stopTest();

        System.assertEquals('{"ok":true}', response);
    }

    @IsTest
    static void put_deveEnviarMetodoPut() {
        Test.setMock(HttpCalloutMock.class, new SuccessMock('PUT', '{"name":"Teste"}', true));

        Test.startTest();
        String response = new HubSalesforceGateway().put('/accounts/001', '{"name":"Teste"}');
        Test.stopTest();

        System.assertEquals('{"ok":true}', response);
    }

    @IsTest
    static void patch_deveEnviarMetodoPatch() {
        Test.setMock(HttpCalloutMock.class, new SuccessMock('PATCH', '{"rating":"Hot"}', true));

        Test.startTest();
        String response = new HubSalesforceGateway().patch('/accounts/001', '{"rating":"Hot"}');
        Test.stopTest();

        System.assertEquals('{"ok":true}', response);
    }

    @IsTest
    static void deleteRequest_deveEnviarMetodoDelete() {
        Test.setMock(HttpCalloutMock.class, new SuccessMock('DELETE', null, false));

        Test.startTest();
        String response = new HubSalesforceGateway().deleteRequest('/accounts/001');
        Test.stopTest();

        System.assertEquals('{"ok":true}', response);
    }

    @IsTest
    static void send_deveValidarRotaObrigatoria() {
        try {
            new HubSalesforceGateway().send('GET', null, null);
            System.assert(false, 'Era esperado erro para rota nao informada.');
        } catch (HubSalesforceException e) {
            System.assert(e.getMessage().contains('Rota'));
        }
    }

    private class SuccessMock implements HttpCalloutMock {
        private String expectedMethod;
        private String expectedBody;
        private Boolean expectsJsonBody;

        private SuccessMock(String expectedMethod, String expectedBody, Boolean expectsJsonBody) {
            this.expectedMethod = expectedMethod;
            this.expectedBody = expectedBody;
            this.expectsJsonBody = expectsJsonBody;
        }

        public HttpResponse respond(HttpRequest request) {
            System.assert(request.getEndpoint().startsWith('callout:Hub_Salesforce_Principal/api/'));
            System.assertEquals(expectedMethod, request.getMethod());
            System.assertEquals('application/json', request.getHeader('Accept'));

            if (expectsJsonBody) {
                System.assertEquals('application/json', request.getHeader('Content-Type'));
                System.assertEquals(expectedBody, request.getBody());
            }

            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{"ok":true}');
            return response;
        }
    }
}
