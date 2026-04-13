public interface IAccountsSelector extends fflib_ISObjectSelector {
    List<Account> selectById(Set<Id> ids);
    List<Account> selectByRating(String rating);
}