public interface IAddressService {
    void enrichAddress(String cep, Id recordId);
    void enrichAddresses(List<AddressEnrichmentRequest> requests);
}
