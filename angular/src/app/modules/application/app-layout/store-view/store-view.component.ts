import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent,
GridComponent } from '@progress/kendo-angular-grid';
import { ProgressServiceFactory } from '../../../../core/data/progress-service-factory';
import { getStoreConfig } from '../../../../core/data/store.config';
import { DataProviderStore } from '../../../../core/data/store.model';
import { ToastrService } from 'ngx-toastr';
import { LoginService } from 'src/app/modules/login/login.service';
import { AppLayoutComponent } from '../app-layout.component';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-store-view',
  templateUrl: './store-view.component.html',
  styleUrls: ['./store-view.component.css']
})
export class StoreViewComponent implements OnInit {
   
  public currentStore: string='';
  public storeId: string='';
  public roleType: string='';
  public storeName: string='';

  public state: any = {
    skip: 0,
    take: 4,
    filter: {
      logic: 'and',
      filters: [],
    },
  };

  public state2: any = {
    skip: 0,
    take: 100,
  };

  public editDataItem: DataProviderStore;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;



  constructor(private progressServiceFactory: ProgressServiceFactory,
    private toastr: ToastrService,
    private appLayout: AppLayoutComponent,
    private loginService: LoginService,
    private http: HttpClient) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderStore>(
        getStoreConfig(),
        this.state
      );
    this.roleType=loginService.getRoleTypeId();
    this.storeId=loginService.getStoreId();

    this.view = this.dataService.dataChanges();
    if(this.roleType!="1"){
      this.currentStore = this.storeId ;
    }
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

  ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.read();
    if(this.roleType!="1"){
      this.storeName = (this.dataService.find((x) => x.StoreId === this.storeId)).Description;
      console.log(this.storeName);
    }
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public addHandler() {
    this.editDataItem = new DataProviderStore();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(store: DataProviderStore) {
    if (this.isNew) {
      this.dataService.create(store);
    } else {
      this.dataService.update(store);
    }

    this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {
    this.dataService.remove(dataItem);
  }

  gridUserSelectionChange(storeGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentStore = selectedData.StoreId;
  }

  public seeReport(storeId:string) {
    alert("Report has been generated! Check your files!");
    console.log("O sa vedem report");
    this.http.put<any>(`http://localhost:8810/server/rest/ServiceREST/SIStore/report-store`, {storeId});
  }

}
