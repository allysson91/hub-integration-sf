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

        IAddressRecordUpdater updater = updaterFactory.getUpdater(recordId.getSObjectType());
        HubSalesforceCepDTO address = hubSalesforceService.getCep(cep);

        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
        updater.registerAddressUpdate(recordId, address, uow);
        uow.commitWork();
    }

    private static void validate(Id recordId) {
        if (recordId == null) {
            throw new AddressException('RecordId nao informado.');
        }
    }
}
