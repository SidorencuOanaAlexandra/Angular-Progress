
import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderStore } from './store.model';

export function getStoreConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderStore(),
    jsdo: {
      name: 'SIStore',
    },
    ds: {
      countFnName: 'count',
    },
  };
}
