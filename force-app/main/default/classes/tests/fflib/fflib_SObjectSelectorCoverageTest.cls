@IsTest
private class fflib_SObjectSelectorCoverageTest {

    @IsTest
    static void selector_deveExercitarMetodosPublicosLegados() {
        AccountSelector selector = new AccountSelector();
        Set<Id> accountIds = new Set<Id>{ fflib_IDGenerator.generate(Account.SObjectType) };

        System.assertEquals('Account', selector.getSObjectName());
        System.assert(selector.getFieldListString().contains('Name'));
        System.assert(selector.getRelatedFieldListString('Owner').contains('Owner.Name'));
        System.assert(selector.buildQuery().contains('id in :idSet'));

        List<SObject> records = selector.selectSObjectsById(accountIds);
        System.assertEquals(0, records.size());

        Database.QueryLocator locator = selector.queryLocatorById(accountIds);
        System.assertNotEquals(null, locator);

        selector.assertIsAccessible();
    }

    private class AccountSelector extends fflib_SObjectSelector {
        public Schema.SObjectType getSObjectType() {
            return Account.SObjectType;
        }

        public List<Schema.SObjectField> getSObjectFieldList() {
            return new List<Schema.SObjectField>{
                Account.Id,
                Account.Name
            };
        }

        public String buildQuery() {
            return buildQuerySObjectById();
        }
    }
}
