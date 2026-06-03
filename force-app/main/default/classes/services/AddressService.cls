public with sharing class AddressService implements IAddressService {

    private final IHubSalesforceService hubSalesforceService;
    private final AddressRecordUpdaterFactory updaterFactory;

    public AddressService() {
        this(
            (IHubSalesforceService) Application.Service.newInstance(IHubSalesforceService.class),
            new AddressRecordUpdaterFactory()
        );
    }

    @TestVisible
    private AddressService(
        IHubSalesforceService hubSalesforceService,
        AddressRecordUpdaterFactory updaterFactory
    ) {
        this.hubSalesforceService = hubSalesforceService;
        this.updaterFactory = updaterFactory;
    }

    public void enrichAddress(String cep, Id recordId) {
        validate(recordId);

        HubSalesforceCepDTO address = hubSalesforceService.getCep(cep);
        IAddressRecordUpdater updater = updaterFactory.getUpdater(recordId.getSObjectType());
        updater.updateAddress(recordId, address);
    }

    private static void validate(Id recordId) {
        if (recordId == null) {
            throw new AddressException('RecordId nao informado.');
        }
    }
}
