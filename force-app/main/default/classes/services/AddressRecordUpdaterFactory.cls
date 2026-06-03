public with sharing class AddressRecordUpdaterFactory {

    public IAddressRecordUpdater getUpdater(Schema.SObjectType sObjectType) {
        if (sObjectType == Account.SObjectType) {
            return new AccountAddressUpdater();
        }

        if (sObjectType == Contact.SObjectType) {
            return new ContactAddressUpdater();
        }

        throw new AddressException('Objeto nao suportado para enriquecimento de endereco: ' + sObjectType);
    }
}
