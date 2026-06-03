@IsTest
private class AddressServiceTest {

    @IsTest
    static void enrichAddress_deveRegistrarBillingAddress_quandoRecordIdForAccount() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        Id accountId = TestDataFactory.account().build().Id;
        HubSalesforceCepDTO cep = TestDataFactory.cep().build();

        IHubSalesforceService hubServiceMock =
            (IHubSalesforceService) mocks.mock(IHubSalesforceService.class);
        fflib_ISObjectUnitOfWork uowMock =
            (fflib_ISObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);

        mocks.startStubbing();
        mocks.when(hubServiceMock.getCep('01001-000')).thenReturn(cep);
        mocks.stopStubbing();

        Application.Service.setMock(IHubSalesforceService.class, hubServiceMock);
        Application.UnitOfWork.setMock(uowMock);

        IAddressService service =
            (IAddressService) Application.Service.newInstance(IAddressService.class);
        service.enrichAddress('01001-000', accountId);

        ((IHubSalesforceService) mocks.verify(hubServiceMock)).getCep('01001-000');
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock))
            .registerDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object>{
                        Account.Id => accountId,
                        Account.BillingStreet => 'Praca da Se\nlado impar',
                        Account.BillingCity => 'Sao Paulo',
                        Account.BillingStateCode => 'SP',
                        Account.BillingCountryCode => 'BR',
                        Account.BillingPostalCode => '01001000'
                    }
                )
            );
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock)).commitWork();
    }

    @IsTest
    static void enrichAddress_deveRegistrarMailingAddress_quandoRecordIdForContact() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        Id contactId = TestDataFactory.contact().build().Id;
        HubSalesforceCepDTO cep = TestDataFactory.cep().build();

        IHubSalesforceService hubServiceMock =
            (IHubSalesforceService) mocks.mock(IHubSalesforceService.class);
        fflib_ISObjectUnitOfWork uowMock =
            (fflib_ISObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);

        mocks.startStubbing();
        mocks.when(hubServiceMock.getCep('01001000')).thenReturn(cep);
        mocks.stopStubbing();

        Application.Service.setMock(IHubSalesforceService.class, hubServiceMock);
        Application.UnitOfWork.setMock(uowMock);

        IAddressService service =
            (IAddressService) Application.Service.newInstance(IAddressService.class);
        service.enrichAddress('01001000', contactId);

        ((IHubSalesforceService) mocks.verify(hubServiceMock)).getCep('01001000');
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock))
            .registerDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object>{
                        Contact.Id => contactId,
                        Contact.MailingStreet => 'Praca da Se\nlado impar',
                        Contact.MailingCity => 'Sao Paulo',
                        Contact.MailingStateCode => 'SP',
                        Contact.MailingCountryCode => 'BR',
                        Contact.MailingPostalCode => '01001000'
                    }
                )
            );
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock)).commitWork();
    }

    @IsTest
    static void enrichAddress_deveFalhar_quandoObjetoNaoForSuportado() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        Id opportunityId = TestDataFactory.opportunity().build().Id;
        IHubSalesforceService hubServiceMock =
            (IHubSalesforceService) mocks.mock(IHubSalesforceService.class);
        fflib_ISObjectUnitOfWork uowMock =
            (fflib_ISObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);

        Application.Service.setMock(IHubSalesforceService.class, hubServiceMock);
        Application.UnitOfWork.setMock(uowMock);

        try {
            IAddressService service =
                (IAddressService) Application.Service.newInstance(IAddressService.class);
            service.enrichAddress('01001000', opportunityId);
            System.assert(false, 'Era esperado erro para objeto nao suportado.');
        } catch (AddressException e) {
            System.assert(e.getMessage().contains('Objeto nao suportado'));
        }

        ((IHubSalesforceService) mocks.verify(hubServiceMock, fflib_ApexMocks.NEVER))
            .getCep((String) fflib_Match.anyObject());
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, fflib_ApexMocks.NEVER))
            .commitWork();
    }
}
