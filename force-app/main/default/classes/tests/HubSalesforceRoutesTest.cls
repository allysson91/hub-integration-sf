@IsTest
private class HubSalesforceRoutesTest {

    @IsTest
    static void cep_deveRetornarApenasRotaFinal() {
        System.assertEquals(
            '/cep/01001000',
            HubSalesforceRoutes.cep('01001-000')
        );
    }

    @IsTest
    static void cep_deveValidarCepInvalido() {
        try {
            HubSalesforceRoutes.cep('123');
            System.assert(false, 'Era esperado erro para CEP invalido.');
        } catch (HubSalesforceException e) {
            System.assert(e.getMessage().contains('8 digitos'));
        }
    }
}
