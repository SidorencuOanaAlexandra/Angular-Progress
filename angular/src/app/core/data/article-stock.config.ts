import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderArticleStock } from './article-stock.model';

export function getArticleStockConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderArticleStock(),
    jsdo: {
      name: 'SIArticleStock',
    },
    ds: {
      countFnName: 'count',
    },
  };
}
