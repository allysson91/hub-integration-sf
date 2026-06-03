@IsTest
private class AccountsServiceTest {

    @IsTest
    static void updateRating_deveDefinirHot_quandoIndustriaTechnology() {
        // ── 1. SETUP DOS MOCKS ──────────────────────────────────────────
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IAccountsSelector selectorMock =
            (IAccountsSelector) mocks.mock(AccountsSelector.class);

        fflib_ISObjectUnitOfWork uowMock =
            (fflib_ISObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);

        // ── 2. DADOS DE TESTE ───────────────────────────────────────────
        Id fakeId = fflib_IDGenerator.generate(Account.SObjectType);
        Set<Id> accountIds = new Set<Id>{ fakeId };

        Account acc = new Account(
            Id       = fakeId,
            Name     = 'Tech Corp',
            Industry = 'Technology',
            Rating   = 'Warm'
        );

        // ── 3. STUB ─────────────────────────────────────────────────────
        mocks.startStubbing();
        mocks.when(selectorMock.selectById(
                (Set<Id>) fflib_Match.anyObject()))   // ← matcher, não instância
             .thenReturn(new List<Account>{ acc });
        mocks.stopStubbing();

        // ── 4. INJETA ───────────────────────────────────────────────────
        Application.Selector.setMock(Account.SObjectType, selectorMock);
        Application.UnitOfWork.setMock(uowMock);

        // ── 5. EXECUTA ──────────────────────────────────────────────────
        IAccountsService service =
            (IAccountsService) Application.Service.newInstance(IAccountsService.class);
        service.updateRatingForHotAccounts(accountIds);

        // ── 6. VERIFICA ─────────────────────────────────────────────────
        ((IAccountsSelector) mocks.verify(selectorMock))
            .selectById((Set<Id>) fflib_Match.anyObject());  // ← mesmo matcher

        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock))
            .registerDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object>{ Account.Rating => 'Hot' }
                )
            );

        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock))
            .commitWork();
    }

    @IsTest
    static void updateRating_naoDeveRegistrar_quandoIndustriaDiferente() {
        // ── 1. SETUP ────────────────────────────────────────────────────
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IAccountsSelector selectorMock =
            (IAccountsSelector) mocks.mock(AccountsSelector.class);

        fflib_ISObjectUnitOfWork uowMock =
            (fflib_ISObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);

        Id fakeId = fflib_IDGenerator.generate(Account.SObjectType);
        Set<Id> accountIds = new Set<Id>{ fakeId };

        Account acc = new Account(
            Id       = fakeId,
            Name     = 'Retail Corp',
            Industry = 'Retail',
            Rating   = 'Warm'
        );

        mocks.startStubbing();
        mocks.when(selectorMock.selectById(
                (Set<Id>) fflib_Match.anyObject()))   // ← matcher
             .thenReturn(new List<Account>{ acc });
        mocks.stopStubbing();

        Application.Selector.setMock(Account.SObjectType, selectorMock);
        Application.UnitOfWork.setMock(uowMock);

        // ── 2. EXECUTA ──────────────────────────────────────────────────
        IAccountsService service =
            (IAccountsService) Application.Service.newInstance(IAccountsService.class);
        service.updateRatingForHotAccounts(accountIds);

        // ── 3. VERIFICA ─────────────────────────────────────────────────
        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, fflib_ApexMocks.NEVER))
            .registerDirty(fflib_Match.anySObject());

        ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock))
            .commitWork();
    }
}