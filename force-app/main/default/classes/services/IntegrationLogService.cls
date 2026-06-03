public with sharing class IntegrationLogService implements IIntegrationLogService {

    @TestVisible
    private static List<IntegrationLogDTO> registeredLogs = new List<IntegrationLogDTO>();

    private final IIntegrationLogRepository repository;

    public IntegrationLogService() {
        this(new IntegrationLogRepository());
    }

    @TestVisible
    private IntegrationLogService(IIntegrationLogRepository repository) {
        this.repository = repository;
    }

    public void save(IntegrationLogDTO log) {
        if (log == null) {
            return;
        }

        saveAll(new List<IntegrationLogDTO>{ log });
    }

    public void saveAll(List<IntegrationLogDTO> logs) {
        List<IntegrationLogDTO> normalizedLogs = normalize(logs);

        if (normalizedLogs.isEmpty()) {
            return;
        }

        try {
            repository.insertLogs(normalizedLogs);
        } catch (Exception ignored) {
            // Logging must never block the integration flow.
        }
    }

    public void register(IntegrationLogDTO log) {
        if (log != null) {
            registeredLogs.add(normalize(log));
        }
    }

    public void registerAll(List<IntegrationLogDTO> logs) {
        for (IntegrationLogDTO log : normalize(logs)) {
            registeredLogs.add(log);
        }
    }

    public void flushRegistered() {
        if (registeredLogs.isEmpty()) {
            return;
        }

        List<IntegrationLogDTO> logsToSave = new List<IntegrationLogDTO>();
        logsToSave.addAll(registeredLogs);
        registeredLogs.clear();

        saveAll(logsToSave);
    }

    private static List<IntegrationLogDTO> normalize(List<IntegrationLogDTO> logs) {
        List<IntegrationLogDTO> normalizedLogs = new List<IntegrationLogDTO>();

        if (logs == null) {
            return normalizedLogs;
        }

        for (IntegrationLogDTO log : logs) {
            if (log != null) {
                normalizedLogs.add(normalize(log));
            }
        }

        return normalizedLogs;
    }

    private static IntegrationLogDTO normalize(IntegrationLogDTO log) {
        if (String.isBlank(log.integrationName)) {
            log.integrationName = IntegrationLogConstants.HUB_SALESFORCE;
        }

        if (String.isBlank(log.direction)) {
            log.direction = IntegrationLogConstants.DIRECTION_OUTBOUND;
        }

        if (String.isBlank(log.status)) {
            log.status = IntegrationLogConstants.STATUS_PENDING;
        }

        if (log.occurredAt == null) {
            log.occurredAt = Datetime.now();
        }

        if (log.requestedBy == null) {
            log.requestedBy = UserInfo.getUserId();
        }

        return log;
    }
}
