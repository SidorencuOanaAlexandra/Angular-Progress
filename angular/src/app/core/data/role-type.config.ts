import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderRoleType } from './role-type.model';


export function getRoleConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderRoleType(),
    jsdo: {
      name: 'SIRoleType',
    },
    ds: {
      countFnName: 'count',
    },
  };
}