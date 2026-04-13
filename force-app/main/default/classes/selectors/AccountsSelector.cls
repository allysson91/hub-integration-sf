// selectors/AccountsSelector.cls
public class AccountsSelector extends fflib_SObjectSelector implements IAccountsSelector {

    // Define quais campos sempre vêm nas queries
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Account.Id,
            Account.Name,
            Account.Phone,
            Account.Rating,
            Account.Industry
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Account.SObjectType;
    }

    public List<Account> selectById(Set<Id> ids) {
        return (List<Account>) selectSObjectsById(ids);
    }

    public List<Account> selectByRating(String rating) {
        return (List<Account>) Database.query(
            newQueryFactory()
                .setCondition('Rating = :rating')
                .toSOQL()
        );
    }
}