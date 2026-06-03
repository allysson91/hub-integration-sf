public with sharing class HubSalesforceService implements IHubSalesforceService {

    private final HubSalesforceGateway gateway;

    public HubSalesforceService() {
        this(new HubSalesforceGateway());
    }

    @TestVisible
    private HubSalesforceService(HubSalesforceGateway gateway) {
        this.gateway = gateway;
    }

    public HubSalesforceCepDTO getCep(String cep) {
        return getCep(cep, null);
    }

    public HubSalesforceCepDTO getCep(String cep, IntegrationLogContext logContext) {
        String body = gateway.get(HubSalesforceRoutes.cep(cep), logContext);
        HubSalesforceCepResponseDTO hubResponse =
            (HubSalesforceCepResponseDTO) JSON.deserialize(body, HubSalesforceCepResponseDTO.class);

        if (hubResponse == null || hubResponse.data == null) {
            throw new HubSalesforceException('Resposta vazia ao consultar CEP.');
        }

        if (hubResponse.success == false) {
            throw new HubSalesforceException(hubResponse.message);
        }

        return toCepDTO(hubResponse);
    }

    private static HubSalesforceCepDTO toCepDTO(HubSalesforceCepResponseDTO hubResponse) {
        HubSalesforceCepDTO response = new HubSalesforceCepDTO();
        response.cep = hubResponse.data.cep;
        response.logradouro = hubResponse.data.street;
        response.complemento = hubResponse.data.complement;
        response.bairro = hubResponse.data.neighborhood;
        response.localidade = hubResponse.data.city;
        response.uf = hubResponse.data.state;
        response.ibge = hubResponse.data.ibge;
        response.gia = hubResponse.data.gia;
        response.ddd = hubResponse.data.ddd;
        response.siafi = hubResponse.data.siafi;
        response.erro = false;
        return response;
    }
}
