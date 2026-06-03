@IsTest
private class AccountsTest {

    @IsTest
    static void applyDefaultRating_deveDefinirWarm_quandoRatingNulo() {
        // Given
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Empresa A', Phone = '11999990000', Rating = null)
        };

        // When
        Accounts domain = new Accounts(accounts);
        domain.applyDefaultRating();

        // Then
        Assert.areEqual('Warm', accounts[0].Rating, 'Rating deveria ser Warm por padrão');
    }

    @IsTest
    static void applyDefaultRating_naoDeveSubstituir_quandoRatingJaDefinido() {
        // Given
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Empresa B', Rating = 'Hot')
        };

        // When
        Accounts domain = new Accounts(accounts);
        domain.applyDefaultRating();

        // Then
        Assert.areEqual('Hot', accounts[0].Rating, 'Rating existente não deveria ser sobrescrito');
    }

    @IsTest
    static void validateRequiredFields_deveAdicionarErro_quandoTelefoneNulo() {
        // Given
        Account acc = new Account(Name = 'Empresa C', Phone = null);
        Accounts domain = new Accounts(new List<Account>{ acc });

        // When
        domain.validateRequiredFields();

        // Then
        Assert.isFalse(acc.getErrors().isEmpty(), 'Deveria ter erro de validação');
        Assert.areEqual(
            'Telefone é obrigatório.',
            acc.getErrors()[0].getMessage()
        );
    }

    @IsTest
    static void validateRequiredFields_naoDeveAdicionarErro_quandoTelefonePreenchido() {
        // Given
        Account acc = new Account(Name = 'Empresa D', Phone = '11999990000');
        Accounts domain = new Accounts(new List<Account>{ acc });

        // When
        domain.validateRequiredFields();

        // Then
        Assert.isTrue(acc.getErrors().isEmpty(), 'Não deveria ter erro de validação');
    }

    @IsTest
    static void constructor_deveConstruirInstancia_deAccounts() {
        // Given
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Empresa E', Phone = '11999990000')
        };

        // When
        Accounts.Constructor c = new Accounts.Constructor();
        Accounts domain = (Accounts) c.construct(accounts);

        // Then
        Assert.isNotNull(domain, 'Domain deveria ser instanciado pelo Constructor');
    }

    @IsTest
    static void onBeforeInsert_deveValidarEAplicarRatingPadrao() {
        // Given — telefone nulo dispara erro, rating nulo recebe 'Warm'
        Account acc = new Account(Name = 'Empresa F', Phone = null, Rating = null);
        Accounts domain = new Accounts(new List<Account>{ acc });

        // When
        domain.onBeforeInsert();

        // Then
        Assert.isFalse(acc.getErrors().isEmpty(), 'Deveria ter erro de telefone obrigatório');
        Assert.areEqual('Warm', acc.Rating, 'Rating deveria ser Warm por padrão');
    }
}