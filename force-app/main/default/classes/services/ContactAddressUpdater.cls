public with sharing class ContactAddressUpdater implements IAddressRecordUpdater {

    public void updateAddress(Id recordId, HubSalesforceCepDTO address) {
        Contact contactToUpdate = new Contact(
            Id = recordId,
            MailingStreet = buildStreet(address),
            MailingCity = address.localidade,
            MailingStateCode = address.uf,
            MailingCountryCode = 'BR',
            MailingPostalCode = address.cep
        );

        update contactToUpdate;
    }

    private static String buildStreet(HubSalesforceCepDTO address) {
        if (String.isBlank(address.complemento)) {
            return address.logradouro;
        }

        return address.logradouro + '\n' + address.complemento;
    }
}
