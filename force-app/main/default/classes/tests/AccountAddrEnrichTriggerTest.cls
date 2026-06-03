@IsTest
private class AccountAddrEnrichTriggerTest {

    @IsTest
    static void afterInsert_devePublicarEvento_quandoCepPreenchido() {
        EventPublisherSpy publisher = new EventPublisherSpy();
        Account account = TestDataFactory.account()
            .withBillingPostalCode('01001000')
            .build();

        new AccountAddressEnrichmentTriggerHandler(publisher)
            .afterInsert(new List<Account>{ account });

        System.assertEquals(1, publisher.events.size());
        System.assertEquals(String.valueOf(account.Id), publisher.events[0].RecordId__c);
        System.assertEquals('01001000', publisher.events[0].Cep__c);
        System.assertEquals('AccountTriggerInsert', publisher.events[0].Source__c);
    }

    @IsTest
    static void afterInsert_naoDevePublicarEvento_quandoCepVazio() {
        EventPublisherSpy publisher = new EventPublisherSpy();
        Account account = TestDataFactory.account().build();

        new AccountAddressEnrichmentTriggerHandler(publisher)
            .afterInsert(new List<Account>{ account });

        System.assertEquals(0, publisher.events.size());
    }

    @IsTest
    static void afterUpdate_devePublicarEvento_quandoCepMudou() {
        EventPublisherSpy publisher = new EventPublisherSpy();
        Account oldAccount = TestDataFactory.account()
            .withBillingPostalCode('01001000')
            .build();
        Account newAccount = TestDataFactory.account()
            .withId(oldAccount.Id)
            .withBillingPostalCode('02002000')
            .build();

        new AccountAddressEnrichmentTriggerHandler(publisher)
            .afterUpdate(
                new List<Account>{ newAccount },
                new Map<Id, Account>{ oldAccount.Id => oldAccount }
            );

        System.assertEquals(1, publisher.events.size());
        System.assertEquals(String.valueOf(newAccount.Id), publisher.events[0].RecordId__c);
        System.assertEquals('02002000', publisher.events[0].Cep__c);
        System.assertEquals('AccountTriggerUpdate', publisher.events[0].Source__c);
    }

    @IsTest
    static void afterUpdate_devePublicarEvento_quandoCepSaiuDeBrancoParaValor() {
        EventPublisherSpy publisher = new EventPublisherSpy();
        Account oldAccount = TestDataFactory.account().build();
        Account newAccount = TestDataFactory.account()
            .withId(oldAccount.Id)
            .withBillingPostalCode('01001000')
            .build();

        new AccountAddressEnrichmentTriggerHandler(publisher)
            .afterUpdate(
                new List<Account>{ newAccount },
                new Map<Id, Account>{ oldAccount.Id => oldAccount }
            );

        System.assertEquals(1, publisher.events.size());
        System.assertEquals('01001000', publisher.events[0].Cep__c);
    }

    @IsTest
    static void afterUpdate_naoDevePublicarEvento_quandoCepNaoMudou() {
        EventPublisherSpy publisher = new EventPublisherSpy();
        Account oldAccount = TestDataFactory.account()
            .withBillingPostalCode('01001000')
            .build();
        Account newAccount = TestDataFactory.account()
            .withId(oldAccount.Id)
            .withBillingPostalCode('01001000')
            .build();

        new AccountAddressEnrichmentTriggerHandler(publisher)
            .afterUpdate(
                new List<Account>{ newAccount },
                new Map<Id, Account>{ oldAccount.Id => oldAccount }
            );

        System.assertEquals(0, publisher.events.size());
    }

    @IsTest
    static void afterUpdate_naoDevePublicarEvento_quandoBypassAtivo() {
        EventPublisherSpy publisher = new EventPublisherSpy();
        Account oldAccount = TestDataFactory.account().build();
        Account newAccount = TestDataFactory.account()
            .withId(oldAccount.Id)
            .withBillingPostalCode('01001000')
            .build();

        AddressEnrichmentTriggerControl.bypassAccountPublishing = true;

        try {
            new AccountAddressEnrichmentTriggerHandler(publisher)
                .afterUpdate(
                    new List<Account>{ newAccount },
                    new Map<Id, Account>{ oldAccount.Id => oldAccount }
                );
        } finally {
            AddressEnrichmentTriggerControl.bypassAccountPublishing = false;
        }

        System.assertEquals(0, publisher.events.size());
    }

    private class EventPublisherSpy implements IAddressEnrichmentEventPublisher {
        private List<Address_Enrichment_Requested__e> events =
            new List<Address_Enrichment_Requested__e>();

        public void publish(List<Address_Enrichment_Requested__e> events) {
            this.events.addAll(events);
        }
    }
}
