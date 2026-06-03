@IsTest
private class AddressEnrichmentQueueableTest {

    @IsTest
    static void execute_deveDelegarParaAddressService() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        Id accountId = TestDataFactory.account().build().Id;
        IAddressService addressServiceMock =
            (IAddressService) mocks.mock(IAddressService.class);

        Application.Service.setMock(IAddressService.class, addressServiceMock);

        Test.startTest();
        System.enqueueJob(new AddressEnrichmentQueueable('01001000', accountId));
        Test.stopTest();

        ((IAddressService) mocks.verify(addressServiceMock))
            .enrichAddress('01001000', accountId);
    }
}
