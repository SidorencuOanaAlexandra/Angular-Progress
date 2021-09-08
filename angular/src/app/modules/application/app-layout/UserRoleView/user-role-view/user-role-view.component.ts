import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { ProgressServiceFactory } from '../../../../../core/data/progress-service-factory';
import { DataProviderUserRole } from '../../../../../core/data/user-role.model';
import { getUserRoleConfig } from '../../../../../core/data/user-role.config';
import { FormControl, FormGroup } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { DataProviderRoleType } from 'src/app/core/data/role-type.model';
import { getRoleConfig } from 'src/app/core/data/role-type.config';
import { DataProviderStore } from 'src/app/core/data/store.model';
import { getStoreConfig } from 'src/app/core/data/store.config';
import { LoginService } from 'src/app/modules/login/login.service';

const createFormGroup: (item: any) => FormGroup = (dataItem: any) =>
  new FormGroup({
    UserRoleId: new FormControl(dataItem.UserRoleId),
    AppUSerId: new FormControl(dataItem.AppUserId),
    RoleTypeId: new FormControl(dataItem.RoleTypeId),
    StoreId: new FormControl(dataItem.StoreId),
  });

@Component({
  selector: 'app-user-role-view',
  templateUrl: './user-role-view.component.html',
  styleUrls: ['./user-role-view.component.css']
})
export class UserRoleViewComponent implements OnChanges {

  public currentUserRole: number = 0;
  @Input() UserName: string = '';
  @Input() AppUserId: string = '';

  public state: any = {
    skip: 0,
    take: 3,
    filter: {
      logic: 'and',
      filters: [],
    },
  };

  public state2: any = {
    skip: 0,
    take: 3,
  };

  public state3: any = {
    skip: 0,
    take: 10,
  };

  public editDataItem: DataProviderUserRole;
  public isNew: boolean;
  public roleTypeList: Array<DataProviderRoleType> = [];
  public storeList: Array<DataProviderStore> = [];
  public roleTypeDataService;
  public storeDataService;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  public formGroup: FormGroup;

  constructor(private progressServiceFactory: ProgressServiceFactory,  
    private toastr: ToastrService,
    private loginService: LoginService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderUserRole>(
        getUserRoleConfig(),
        this.state
      );

    this.view = this.dataService.dataChanges();

    this.roleTypeDataService =
      this.progressServiceFactory.getService<DataProviderRoleType>(
        getRoleConfig(),
        this.state2
      );

    this.storeDataService =
    this.progressServiceFactory.getService<DataProviderStore>(
      getStoreConfig(),
      this.state3
    );

    this.dataService.errors.subscribe((error) => {
      if(error && error['error']){
      this.toastr.error(error['error'].message);

      }
      });
  }

  public isLogged(): boolean{
    console.log("isLogged in user role" + this.loginService.getAppUserId());
    return (this.loginService.getAppUserId() != "");
  }

  public hasRole(): boolean{
    console.log("hasRole in choose role" + this.loginService.getRoleTypeId());
    return (this.loginService.getRoleTypeId() != "");
  }


  public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
    });
    if(this.AppUserId != ''){
      this.state.filter.filters = [{field: "AppUserId", operator: "eq", value: this.AppUserId}];
      
    }
    this.dataService.read(this.state);

    this.roleTypeDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.roleTypeList = data['data'];
    });
    this.roleTypeDataService.read();

    this.storeDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.storeList = data['data'];
    });
    this.storeDataService.read();

  }

  public ngOnChanges(): void {
    if(this.AppUserId != ''){
      this.state.filter.filters = [{field: "AppUserId", operator: "eq", value: this.AppUserId}];
    }
    this.dataService.read(this.state);
  }


  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public addHandler() {
    this.editDataItem = new DataProviderUserRole();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(customer: DataProviderUserRole) {
    if (this.isNew) {
      this.dataService.create(customer);
    } else {
      this.dataService.update(customer);
    }

    this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {
    this.dataService.remove(dataItem);
    this.dataService.read();
    //this.dataServiceData = this.dataService.dataChanges();

  }

  public roleTypes(id: string): any {
    return this.roleTypeList.find((x) => x.RoleTypeId === id)
  }

  public stores(id: string): any {
    console.log(this.storeList);
    return this.storeList.find((x) => x.StoreId === id)
  }

}
