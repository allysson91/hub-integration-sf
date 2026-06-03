public with sharing class AccountAddressEnrichmentTriggerHandler {

    private final IAddressEnrichmentEventPublisher publisher;

    public AccountAddressEnrichmentTriggerHandler() {
        this(new AddressEnrichmentEventPublisher());
    }

    @TestVisible
    private AccountAddressEnrichmentTriggerHandler(IAddressEnrichmentEventPublisher publisher) {
        this.publisher = publisher;
    }

    public void afterInsert(List<Account> newRecords) {
        if (AddressEnrichmentTriggerControl.bypassAccountPublishing) {
            return;
        }

        publishEvents(buildEventsForInsert(newRecords));
    }

    public void afterUpdate(List<Account> newRecords, Map<Id, Account> oldMap) {
        if (AddressEnrichmentTriggerControl.bypassAccountPublishing) {
            return;
        }

        publishEvents(buildEventsForUpdate(newRecords, oldMap));
    }

    private List<Address_Enrichment_Requested__e> buildEventsForInsert(List<Account> newRecords) {
        List<Address_Enrichment_Requested__e> events = new List<Address_Enrichment_Requested__e>();

        for (Account account : newRecords) {
            if (String.isNotBlank(account.BillingPostalCode)) {
                events.add(newEvent(account.Id, account.BillingPostalCode, 'AccountTriggerInsert'));
            }
        }

        return events;
    }

    private List<Address_Enrichment_Requested__e> buildEventsForUpdate(
        List<Account> newRecords,
        Map<Id, Account> oldMap
    ) {
        List<Address_Enrichment_Requested__e> events = new List<Address_Enrichment_Requested__e>();

        for (Account account : newRecords) {
            Account oldAccount = oldMap.get(account.Id);

            if (
                String.isNotBlank(account.BillingPostalCode) &&
                account.BillingPostalCode != oldAccount.BillingPostalCode
            ) {
                events.add(newEvent(account.Id, account.BillingPostalCode, 'AccountTriggerUpdate'));
            }
        }

        return events;
    }

    private void publishEvents(List<Address_Enrichment_Requested__e> events) {
        if (!events.isEmpty()) {
            publisher.publish(events);
        }
    }

    private static Address_Enrichment_Requested__e newEvent(Id recordId, String cep, String source) {
        return new Address_Enrichment_Requested__e(
            RecordId__c = String.valueOf(recordId),
            Cep__c = cep,
            Source__c = source,
            RequestedBy__c = UserInfo.getUserId(),
            CorrelationId__c = String.valueOf(recordId) + '-' + String.valueOf(DateTime.now().getTime())
        );
    }
}
