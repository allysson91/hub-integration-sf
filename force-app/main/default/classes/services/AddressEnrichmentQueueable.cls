public with sharing class AddressEnrichmentQueueable implements Queueable, Database.AllowsCallouts {

    private final List<AddressEnrichmentRequest> requests;

    public AddressEnrichmentQueueable(String cep, Id recordId) {
        this(new List<AddressEnrichmentRequest>{
            new AddressEnrichmentRequest(cep, recordId)
        });
    }

    public AddressEnrichmentQueueable(List<AddressEnrichmentRequest> requests) {
        this.requests = new List<AddressEnrichmentRequest>();

        if (requests != null) {
            this.requests.addAll(requests);
        }
    }

    public void execute(QueueableContext context) {
        IAddressService addressService =
            (IAddressService) Application.Service.newInstance(IAddressService.class);

        addressService.enrichAddresses(requests);
    }
}
