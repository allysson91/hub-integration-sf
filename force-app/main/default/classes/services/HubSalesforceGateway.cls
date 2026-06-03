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

    private final IIntegrationLogService integrationLogService;

    public HubSalesforceGateway() {
        this((IIntegrationLogService) Application.Service.newInstance(IIntegrationLogService.class));
    }

    @TestVisible
    private HubSalesforceGateway(IIntegrationLogService integrationLogService) {
        this.integrationLogService = integrationLogService;
    }

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
        Long startedAt = DateTime.now().getTime();
        String endpoint = buildEndpoint(route);
        Boolean logRegistered = false;

        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method);
        request.setTimeout(TIMEOUT_MS);
        request.setHeader('Accept', 'application/json');

        if (!String.isBlank(body)) {
            request.setHeader('Content-Type', 'application/json');
            request.setBody(body);
        }

        try {
            HttpResponse response = new Http().send(request);
            Integer statusCode = response.getStatusCode();
            Long durationMs = DateTime.now().getTime() - startedAt;

            if (statusCode >= 200 && statusCode < 300) {
                registerLog(
                    buildLog(method, endpoint, route, body)
                        .withHttp(method, endpoint, statusCode)
                        .withPayloads(body, response.getBody())
                        .took(durationMs)
                        .success()
                );
                logRegistered = true;
                return response.getBody();
            }

            HubSalesforceException hubException = new HubSalesforceException(
                'Erro ao chamar Hub Salesforce. Status: ' + statusCode + '. Body: ' + response.getBody()
            );

            registerLog(
                buildLog(method, endpoint, route, body)
                    .withHttp(method, endpoint, statusCode)
                    .withPayloads(body, response.getBody())
                    .took(durationMs)
                    .error(hubException)
            );
            logRegistered = true;

            throw hubException;
        } catch (Exception ex) {
            if (!logRegistered) {
                registerLog(
                    buildLog(method, endpoint, route, body)
                        .withPayloads(body, null)
                        .took(DateTime.now().getTime() - startedAt)
                        .error(ex)
                );
            }

            throw ex;
        }
    }

    private static String buildEndpoint(String route) {
        if (String.isBlank(route)) {
            throw new HubSalesforceException('Rota do Hub Salesforce nao informada.');
        }

        String normalizedRoute = route.startsWith('/') ? route : '/' + route;
        return CALLOUT_PREFIX + NAMED_CREDENTIAL + API_PREFIX + normalizedRoute;
    }

    private IntegrationLogDTO buildLog(String method, String endpoint, String route, String body) {
        return IntegrationLogDTO.create()
            .forIntegration(IntegrationLogConstants.HUB_SALESFORCE)
            .forOperation(method + ' ' + normalizeOperation(route))
            .withHttp(method, endpoint, null)
            .withPayloads(body, null)
            .fromSource('HubSalesforceGateway')
            .outbound();
    }

    private static String normalizeOperation(String route) {
        if (String.isBlank(route)) {
            return null;
        }

        return route.startsWith('/') ? route : '/' + route;
    }

    private void registerLog(IntegrationLogDTO log) {
        if (integrationLogService != null) {
            integrationLogService.register(log);
        }
    }
}
