public with sharing class AccountAddressUpdater implements IAddressRecordUpdater {

    public void registerAddressUpdate(
        Id recordId,
        HubSalesforceCepDTO address,
        fflib_ISObjectUnitOfWork uow
    ) {
        Account accountToUpdate = new Account(
            Id = recordId,
            BillingStreet = buildStreet(address),
            BillingCity = address.localidade,
            BillingStateCode = address.uf,
            BillingCountryCode = 'BR',
            BillingPostalCode = address.cep
        );

        uow.registerDirty(accountToUpdate);
    }

    private static String buildStreet(HubSalesforceCepDTO address) {
        if (String.isBlank(address.complemento)) {
            return address.logradouro;
        }

        return address.logradouro + '\n' + address.complemento;
    }
}
