import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderStoreAgency } from './storeAgency.model';

export function getStoreAgencyConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderStoreAgency(),
    jsdo: {
      name: 'SIStoreAgency',
    },
    ds: {
      countFnName: 'count',
    },
  };
}