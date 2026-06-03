public interface IAddressRecordUpdater {
    void registerAddressUpdate(
        Id recordId,
        HubSalesforceCepDTO address,
        fflib_ISObjectUnitOfWork uow
    );
}
