public class Accounts extends fflib_SObjectDomain implements IAccounts {

    // Construtor obrigatório pelo FFLIB
    public Accounts(List<Account> records) {
        super(records);
    }

    // Factory interna — obrigatória para o Application.Domain funcionar
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> records) {
            return new Accounts((List<Account>) records);
        }
    }

    // Hook do FFLIB — chamado automaticamente no trigger antes de insert
    public override void onBeforeInsert() {
        validateRequiredFields();
        applyDefaultRating();
    }

    public void validateRequiredFields() {
        for (Account acc : (List<Account>) Records) {
            if (String.isBlank(acc.Phone)) {
                acc.addError('Telefone é obrigatório.');
            }
        }
    }

    public void applyDefaultRating() {
        for (Account acc : (List<Account>) Records) {
            if (acc.Rating == null) {
                acc.Rating = 'Warm';
            }
        }
    }
}