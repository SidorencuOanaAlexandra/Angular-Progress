import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderArticleType } from './article-type.model';

export function getArticleTypeConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderArticleType(),
    jsdo: {
      name: 'SIArticleType',
    },
    ds: {
      countFnName: 'count',
    },
  };
}
