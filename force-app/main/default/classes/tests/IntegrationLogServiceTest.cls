@IsTest
private class IntegrationLogServiceTest {

    @IsTest
    static void save_devePersistirLogNormalizado() {
        FakeRepository repository = new FakeRepository();
        IntegrationLogService service = new IntegrationLogService(repository);

        service.save(
            IntegrationLogDTO.create()
                .forOperation('GET /cep/:cep')
                .withHttp('GET', 'callout:Hub/api/cep/01001000', 200)
                .success()
        );

        System.assertEquals(1, repository.logs.size());
        System.assertEquals(IntegrationLogConstants.HUB_SALESFORCE, repository.logs[0].integrationName);
        System.assertEquals(IntegrationLogConstants.DIRECTION_OUTBOUND, repository.logs[0].direction);
        System.assertEquals(IntegrationLogConstants.STATUS_SUCCESS, repository.logs[0].status);
        System.assertNotEquals(null, repository.logs[0].occurredAt);
        System.assertEquals(UserInfo.getUserId(), repository.logs[0].requestedBy);
    }

    @IsTest
    static void flushRegistered_devePersistirLogsRegistradosELimparBuffer() {
        FakeRepository repository = new FakeRepository();
        IntegrationLogService service = new IntegrationLogService(repository);
        IntegrationLogService.registeredLogs.clear();

        service.register(
            IntegrationLogDTO.create()
                .forIntegration('Hub Salesforce')
                .forOperation('GET /cep/:cep')
                .pending()
        );

        System.assertEquals(1, IntegrationLogService.registeredLogs.size());

        service.flushRegistered();

        System.assertEquals(1, repository.logs.size());
        System.assertEquals(0, IntegrationLogService.registeredLogs.size());
    }

    @IsTest
    static void save_naoDevePropagarErroDePersistencia() {
        FailingRepository repository = new FailingRepository();
        IntegrationLogService service = new IntegrationLogService(repository);

        service.save(
            IntegrationLogDTO.create()
                .forOperation('GET /cep/:cep')
                .error('Falha controlada')
        );

        System.assertEquals(true, repository.called);
    }

    private class FakeRepository implements IIntegrationLogRepository {
        private List<IntegrationLogDTO> logs = new List<IntegrationLogDTO>();

        public void insertLogs(List<IntegrationLogDTO> logs) {
            this.logs.addAll(logs);
        }
    }

    private class FailingRepository implements IIntegrationLogRepository {
        private Boolean called = false;

        public void insertLogs(List<IntegrationLogDTO> logs) {
            called = true;
            throw new IntegrationLogException('Erro simulado.');
        }
    }
}
