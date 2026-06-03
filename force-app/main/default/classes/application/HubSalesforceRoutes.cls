public with sharing class HubSalesforceRoutes {

    public static String cep(String cep) {
        return '/cep/' + normalizeCep(cep);
    }

    public static String normalizeCep(String cep) {
        if (String.isBlank(cep)) {
            throw new HubSalesforceException('CEP nao informado.');
        }

        String normalizedCep = cep.replaceAll('[^0-9]', '');

        if (normalizedCep.length() != 8) {
            throw new HubSalesforceException('CEP deve conter 8 digitos.');
        }

        return normalizedCep;
    }
}
