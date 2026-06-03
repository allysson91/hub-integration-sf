public with sharing class AccountAddressUpdater implements IAddressRecordUpdater {

    public void updateAddress(Id recordId, HubSalesforceCepDTO address) {
        Account accountToUpdate = new Account(
            Id = recordId,
            BillingStreet = buildStreet(address),
            BillingCity = address.localidade,
            BillingStateCode = address.uf,
            BillingCountryCode = 'BR',
            BillingPostalCode = address.cep
        );

        update accountToUpdate;
    }

    private static String buildStreet(HubSalesforceCepDTO address) {
        if (String.isBlank(address.complemento)) {
            return address.logradouro;
        }

        return address.logradouro + '\n' + address.complemento;
    }
}
