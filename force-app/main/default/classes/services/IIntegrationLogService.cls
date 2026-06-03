public interface IIntegrationLogService {
    void save(IntegrationLogDTO log);
    void saveAll(List<IntegrationLogDTO> logs);
    void register(IntegrationLogDTO log);
    void registerAll(List<IntegrationLogDTO> logs);
    void flushRegistered();
}
