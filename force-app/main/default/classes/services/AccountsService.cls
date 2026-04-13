public class AccountsService implements IAccountsService {

    public void updateRatingForHotAccounts(Set<Id> accountIds) {

        // 1. Busca dados via Selector
        IAccountsSelector selector =
            (IAccountsSelector) Application.Selector.newInstance(Account.SObjectType);

        List<Account> accounts = selector.selectById(accountIds);

        // 2. Aplica lógica
        List<Account> toUpdate = new List<Account>();
        for (Account acc : accounts) {
            if (acc.Industry == 'Technology') {
                acc.Rating = 'Hot';
                toUpdate.add(acc);
            }
        }

        // 3. DML direto por enquanto (Unit of Work vem depois)
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}