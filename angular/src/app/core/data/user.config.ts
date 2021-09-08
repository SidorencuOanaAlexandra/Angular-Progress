import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderAppUser } from './user.model';

export function getUserConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderAppUser(),
    jsdo: {
      name: 'SIAppUser',
    },
    ds: {
      countFnName: 'count',
    },
  };
}
