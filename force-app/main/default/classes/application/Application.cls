public class Application {

    public static final fflib_Application.UnitOfWorkFactory UnitOfWork =
        new fflib_Application.UnitOfWorkFactory(
            new List<SObjectType>{
                Account.SObjectType,
                Contact.SObjectType,
                Integration_Log__c.SObjectType
            }
        );

    public static final fflib_Application.ServiceFactory Service =
        new fflib_Application.ServiceFactory(
            new Map<Type, Type>{
                IHubSalesforceService.class => HubSalesforceService.class,
                IAddressService.class => AddressService.class,
                IIntegrationLogService.class => IntegrationLogService.class
            }
        );

    public static final fflib_Application.SelectorFactory Selector =
        new fflib_Application.SelectorFactory(
            new Map<SObjectType, Type>()
        );

    public static final fflib_Application.DomainFactory Domain =
        new fflib_Application.DomainFactory(
            Application.Selector,
            new Map<SObjectType, Type>()
        );
}
