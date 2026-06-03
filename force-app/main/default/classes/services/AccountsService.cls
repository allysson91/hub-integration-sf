public class AccountsService implements IAccountsService {

    public void updateRatingForHotAccounts(Set<Id> accountIds) {

        // 1. Selector via Application (mockável)
        IAccountsSelector selector =
            (IAccountsSelector) Application.Selector.newInstance(Account.SObjectType);

        // 2. UnitOfWork via Application (mockável)
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        List<Account> accounts = selector.selectById(accountIds);

        for (Account acc : accounts) {
            if (acc.Industry == 'Technology') {
                acc.Rating = 'Hot';
                uow.registerDirty(acc);  // registra, não executa ainda
            }
        }

        uow.commitWork();  // único ponto de DML — mockável no teste
    }
}