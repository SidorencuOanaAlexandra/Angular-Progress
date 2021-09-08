import { Component, Input, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import {DataProviderAppUser} from '../../../../../core/data/user.model';
import { ProgressServiceFactory } from '../../../../../core/data/progress-service-factory';
import { getUserConfig } from '../../../../../core/data/user.config';
import { DataProviderUserRole } from '../../../../../core/data/user-role.model';
import { getUserRoleConfig } from '../../../../../core/data/user-role.config';
import { ToastrService } from 'ngx-toastr';
import { HttpClient } from '@angular/common/http';


@Component({
  selector: 'app-user-view',
  templateUrl: './user-view.component.html',
  styleUrls: ['./user-view.component.css']
})
export class UserViewComponent implements OnInit {

  public currentAppUserId: string = '';
  public currentAppUserName: string = '';

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

  public editDataItem: DataProviderAppUser;
  public isNew: boolean;
  public userRoleList: Array<DataProviderUserRole> = [];
  public dataService;
  public userRoleDataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;


  constructor(private progressServiceFactory: ProgressServiceFactory, 
    private toastr: ToastrService,
    private http: HttpClient) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderAppUser>(
        getUserConfig(),
        this.state
      );

    this.view = this.dataService.dataChanges();

    this.userRoleDataService =
      this.progressServiceFactory.getService<DataProviderUserRole>(
        getUserRoleConfig(),
        this.state2
      );

    this.dataService.errors.subscribe((error) => {
      if(error && error['error']){
      this.toastr.error(error['error'].message);
      
      }
      });
}


  public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();

    this.userRoleDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.userRoleList = data['data'];
    });
    this.dataService.read();
    this.userRoleDataService.read();
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public addHandler() {
    this.editDataItem = new DataProviderAppUser();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(user: DataProviderAppUser) {
    if (this.isNew) {
      this.dataService.create(user);
    } else {
      this.dataService.update(user);
    }

    this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {
    this.dataService.remove(dataItem);
    this.dataService.read();
  }

  gridUserSelectionChange(appUserGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentAppUserId = selectedData.AppUserId;
    this.currentAppUserName = selectedData.UserName;
  }

  public userRoles(id: string): any {
    return this.userRoleList.find((x) => x.AppUserId === id);
  }

  public seeReport() {
    alert("Report has been generated! Check your files!");
    console.log("O sa vedem report");
    this.http.put<any>(`http://localhost:8810/SportsArt/rest/artSport/SIAppUser/report-user`, {});
  }

}

 
