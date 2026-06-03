public with sharing class AddressEnrichmentQueueable implements Queueable, Database.AllowsCallouts {

    private final String cep;
    private final Id recordId;

    public AddressEnrichmentQueueable(String cep, Id recordId) {
        this.cep = cep;
        this.recordId = recordId;
    }

    public void execute(QueueableContext context) {
        IAddressService addressService =
            (IAddressService) Application.Service.newInstance(IAddressService.class);

        addressService.enrichAddress(cep, recordId);
    }
}
