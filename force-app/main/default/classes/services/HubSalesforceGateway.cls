public with sharing class HubSalesforceGateway {

    public static final String METHOD_GET = 'GET';
    public static final String METHOD_POST = 'POST';
    public static final String METHOD_PUT = 'PUT';
    public static final String METHOD_PATCH = 'PATCH';
    public static final String METHOD_DELETE = 'DELETE';

    private static final String CALLOUT_PREFIX = 'callout:';
    private static final String NAMED_CREDENTIAL = 'Hub_Salesforce_Principal';
    private static final String API_PREFIX = '/api';
    private static final Integer TIMEOUT_MS = 120000;

    public String get(String route) {
        return send(METHOD_GET, route, null);
    }

    public String post(String route, String body) {
        return send(METHOD_POST, route, body);
    }

    public String put(String route, String body) {
        return send(METHOD_PUT, route, body);
    }

    public String patch(String route, String body) {
        return send(METHOD_PATCH, route, body);
    }

    public String deleteRequest(String route) {
        return send(METHOD_DELETE, route, null);
    }

    public String send(String method, String route, String body) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(buildEndpoint(route));
        request.setMethod(method);
        request.setTimeout(TIMEOUT_MS);
        request.setHeader('Accept', 'application/json');

        if (!String.isBlank(body)) {
            request.setHeader('Content-Type', 'application/json');
            request.setBody(body);
        }

        HttpResponse response = new Http().send(request);
        Integer statusCode = response.getStatusCode();

        if (statusCode >= 200 && statusCode < 300) {
            return response.getBody();
        }

        throw new HubSalesforceException(
            'Erro ao chamar Hub Salesforce. Status: ' + statusCode + '. Body: ' + response.getBody()
        );
    }

    private static String buildEndpoint(String route) {
        if (String.isBlank(route)) {
            throw new HubSalesforceException('Rota do Hub Salesforce nao informada.');
        }

        String normalizedRoute = route.startsWith('/') ? route : '/' + route;
        return CALLOUT_PREFIX + NAMED_CREDENTIAL + API_PREFIX + normalizedRoute;
    }
}
