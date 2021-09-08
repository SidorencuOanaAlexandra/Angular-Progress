import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderRentArticle } from './rentArticle.model';

export function getRentArticleConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderRentArticle(),
    jsdo: {
      name: 'SIRentArticle',
    },
    ds: {
      countFnName: 'count',
    },
  };
}