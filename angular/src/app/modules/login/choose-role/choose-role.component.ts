import { Component, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { ProgressServiceFactory } from 'src/app/core/data/progress-service-factory';
import { getRoleConfig } from 'src/app/core/data/role-type.config';
import { DataProviderRoleType } from 'src/app/core/data/role-type.model';
import { getStoreConfig } from 'src/app/core/data/store.config';
import { DataProviderStore } from 'src/app/core/data/store.model';
import { getUserRoleConfig } from 'src/app/core/data/user-role.config';
import { DataProviderUserRole } from 'src/app/core/data/user-role.model';
import { LoginService } from '../login.service';

@Component({
  selector: 'app-choose-role',
  templateUrl: './choose-role.component.html',
  styleUrls: ['./choose-role.component.css']
})
export class ChooseRoleComponent implements OnInit {

  public currentUserRole: number = 0;

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

  public userRoleList: Array<DataProviderUserRole> = [];
  public roleTypeList: Array<DataProviderRoleType> = [];
  public storeList: Array<DataProviderStore> = [];
  public userRoleService;
  public roleTypeDataService;
  public storeDataService;
  public dataServiceData: any;
  public selectedRole: any;
  public RoleTypeId: any;
  public StoreId: any;
  public hasChosenRole = false;
  public AppUserId: string;
  
  constructor(private progressServiceFactory: ProgressServiceFactory,  
              private toastr: ToastrService,
              private router: Router,
              private loginService: LoginService) {

    this.userRoleService =
      this.progressServiceFactory.getService<DataProviderUserRole>(
        getUserRoleConfig(),
        this.state
      );

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

    this.userRoleService.errors.subscribe((error) => {
      if(error && error['error']){
      this.toastr.error(error['error'].message);

      }
      });

    this.AppUserId = this.loginService.getAppUserId();
  }

  public isLogged(): boolean{
      console.log("isLogged in choose role" + this.loginService.getAppUserId());
      return (this.loginService.getAppUserId() != "");
  }

  public hasRole(): boolean{
    console.log("hasRole in choose role" + this.loginService.getRoleTypeId());
    return (this.loginService.getRoleTypeId() != "");
  }

  public ngOnInit(): void {
    this.dataServiceData = this.userRoleService.dataChanges();

    this.userRoleService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.userRoleList = data['data'];
    });

    if(this.AppUserId != ''){
      this.state.filter.filters = [{field: "AppUserId", operator: "eq", value: this.AppUserId}];
      
    }
    this.userRoleService.read(this.state);

    this.roleTypeDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.roleTypeList = data['data'];
    });
    this.roleTypeDataService.read();

    this.storeDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.storeList = data['data'];
    });
    this.storeDataService.read();

  }

  public roleTypes(id: string): any {
    return this.roleTypeList.find((x) => x.RoleTypeId === id)
  }

  public stores(id: string): any {
    return this.storeList.find((x) => x.StoreId === id)
  }

  public sendData() {
    console.log(this.selectedRole);
    this.hasChosenRole = true;
    this.RoleTypeId = this.userRoleList.find((x) => x.UserRoleId === this.selectedRole).RoleTypeId;
    this.StoreId = this.userRoleList.find((x) => x.UserRoleId === this.selectedRole).StoreId;
    this.loginService.setRoleTypeId(this.RoleTypeId);
    this.loginService.setAppUserId(this.AppUserId);
    this.loginService.setStoreId(this.StoreId);

  }

}
