public with sharing class ContactAddressUpdater implements IAddressRecordUpdater {

    public void registerAddressUpdate(
        Id recordId,
        HubSalesforceCepDTO address,
        fflib_ISObjectUnitOfWork uow
    ) {
        Contact contactToUpdate = new Contact(
            Id = recordId,
            MailingStreet = buildStreet(address),
            MailingCity = address.localidade,
            MailingStateCode = address.uf,
            MailingCountryCode = 'BR',
            MailingPostalCode = address.cep
        );

        uow.registerDirty(contactToUpdate);
    }

    private static String buildStreet(HubSalesforceCepDTO address) {
        if (String.isBlank(address.complemento)) {
            return address.logradouro;
        }

        return address.logradouro + '\n' + address.complemento;
    }
}
