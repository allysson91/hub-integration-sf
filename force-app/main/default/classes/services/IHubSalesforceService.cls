public interface IHubSalesforceService {
    HubSalesforceCepDTO getCep(String cep);
    HubSalesforceCepDTO getCep(String cep, IntegrationLogContext logContext);
}
