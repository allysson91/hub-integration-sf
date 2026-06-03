@IsTest
public class TestDataFactory {

    public static AccountBuilder account() {
        return new AccountBuilder();
    }

    public static ContactBuilder contact() {
        return new ContactBuilder();
    }

    public static OpportunityBuilder opportunity() {
        return new OpportunityBuilder();
    }

    public static CepBuilder cep() {
        return new CepBuilder();
    }

    public class AccountBuilder {
        private Id recordId = fflib_IDGenerator.generate(Account.SObjectType);
        private String name = 'Empresa Teste';
        private String phone = '11999990000';
        private String billingPostalCode;

        public AccountBuilder withId(Id recordId) {
            this.recordId = recordId;
            return this;
        }

        public AccountBuilder withName(String name) {
            this.name = name;
            return this;
        }

        public AccountBuilder withBillingPostalCode(String billingPostalCode) {
            this.billingPostalCode = billingPostalCode;
            return this;
        }

        public Account build() {
            return new Account(
                Id = recordId,
                Name = name,
                Phone = phone,
                BillingPostalCode = billingPostalCode
            );
        }
    }

    public class ContactBuilder {
        private Id recordId = fflib_IDGenerator.generate(Contact.SObjectType);
        private String lastName = 'Contato Teste';

        public ContactBuilder withId(Id recordId) {
            this.recordId = recordId;
            return this;
        }

        public ContactBuilder withLastName(String lastName) {
            this.lastName = lastName;
            return this;
        }

        public Contact build() {
            return new Contact(
                Id = recordId,
                LastName = lastName
            );
        }
    }

    public class OpportunityBuilder {
        private Id recordId = fflib_IDGenerator.generate(Opportunity.SObjectType);
        private String name = 'Oportunidade Teste';

        public OpportunityBuilder withId(Id recordId) {
            this.recordId = recordId;
            return this;
        }

        public Opportunity build() {
            return new Opportunity(
                Id = recordId,
                Name = name,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(10)
            );
        }
    }

    public class CepBuilder {
        private String cep = '01001000';
        private String logradouro = 'Praca da Se';
        private String complemento = 'lado impar';
        private String bairro = 'Se';
        private String localidade = 'Sao Paulo';
        private String uf = 'SP';

        public CepBuilder withoutComplemento() {
            this.complemento = null;
            return this;
        }

        public HubSalesforceCepDTO build() {
            HubSalesforceCepDTO response = new HubSalesforceCepDTO();
            response.cep = cep;
            response.logradouro = logradouro;
            response.complemento = complemento;
            response.bairro = bairro;
            response.localidade = localidade;
            response.uf = uf;
            response.ibge = '3550308';
            response.gia = '1004';
            response.ddd = '11';
            response.siafi = '7107';
            response.erro = false;
            return response;
        }
    }
}
