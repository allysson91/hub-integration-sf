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
        enrichAddresses(new List<AddressEnrichmentRequest>{
            new AddressEnrichmentRequest(cep, recordId)
        });
    }

    public void enrichAddresses(List<AddressEnrichmentRequest> requests) {
        validate(requests);

        List<AddressEnrichmentResult> results = new List<AddressEnrichmentResult>();

        for (AddressEnrichmentRequest request : requests) {
            IAddressRecordUpdater updater = updaterFactory.getUpdater(request.recordId.getSObjectType());
            HubSalesforceCepDTO address = hubSalesforceService.getCep(request.cep);
            results.add(new AddressEnrichmentResult(request, address, updater));
        }

        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        try {
            AddressEnrichmentTriggerControl.bypassAccountPublishing = true;

            for (AddressEnrichmentResult result : results) {
                result.updater.registerAddressUpdate(
                    result.request.recordId,
                    result.address,
                    uow
                );
            }

            uow.commitWork();
        } finally {
            AddressEnrichmentTriggerControl.bypassAccountPublishing = false;
        }
    }

    private static void validate(List<AddressEnrichmentRequest> requests) {
        if (requests == null || requests.isEmpty()) {
            throw new AddressException('Nenhuma solicitacao de enriquecimento informada.');
        }

        for (AddressEnrichmentRequest request : requests) {
            if (request == null || request.recordId == null) {
                throw new AddressException('RecordId nao informado.');
            }

            if (String.isBlank(request.cep)) {
                throw new AddressException('CEP nao informado.');
            }
        }
    }

    private class AddressEnrichmentResult {
        private AddressEnrichmentRequest request;
        private HubSalesforceCepDTO address;
        private IAddressRecordUpdater updater;

        private AddressEnrichmentResult(
            AddressEnrichmentRequest request,
            HubSalesforceCepDTO address,
            IAddressRecordUpdater updater
        ) {
            this.request = request;
            this.address = address;
            this.updater = updater;
        }
    }
}
