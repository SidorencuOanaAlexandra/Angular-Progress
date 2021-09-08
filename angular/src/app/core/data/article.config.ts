import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderArticle } from './article.model';

export function getArticleConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderArticle(),
    jsdo: {
      name: 'SIArticle',
    },
    ds: {
      countFnName: 'count',
    },
  };
}