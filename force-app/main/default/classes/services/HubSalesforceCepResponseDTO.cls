public with sharing class HubSalesforceCepResponseDTO {
    public Boolean success;
    public String message;
    public HubSalesforceCepDataDTO data;

    public class HubSalesforceCepDataDTO {
        public String cep;
        public String street;
        public String complement;
        public String neighborhood;
        public String city;
        public String state;
        public String stateName;
        public String region;
        public String ibge;
        public String gia;
        public String ddd;
        public String siafi;
    }
}
