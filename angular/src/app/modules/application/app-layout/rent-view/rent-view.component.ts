import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { DataProviderRent} from '../../../../core/data/rent.model'
import { getRentConfig } from '../../../../core/data/rent.config';
import { ProgressSessionService } from '../../../../core/data/progress-session.service';
import { ProgressServiceFactory } from '../../../../core/data/progress-service-factory';
import { DataProviderService } from '../../../../core/data/service-config';

import {DataProviderAppUser} from '../../../../core/data/appUser.model'
import { getAppUserConfig } from '../../../../core/data/appUser.config';
import {DataProviderStoreAgency} from '../../../../core/data/storeAgency.model'
import { getStoreAgencyConfig } from '../../../../core/data/storeAgency.config';
import { ToastrService } from 'ngx-toastr';
import { AppLayoutComponent } from '../app-layout.component';
import { LoginService } from 'src/app/modules/login/login.service';

@Component({
  selector: 'app-rent-view',
  templateUrl: './rent-view.component.html',
  styleUrls: ['./rent-view.component.css']
})
export class RentViewComponent implements OnInit {

  public currentRent: string = '';
  public myselection: any[];
  public StoreIdUser: string = '';
  public AppUserId: string = '';
  public RoleUser: string= '';

  public state: any = {
    skip: 0,
    take: 5,
    filter: {
      logic: 'and',
      filters: [],
    },
  };

  public stateUsername: any = {
    skip: 0,
    take: 100,
  };

  public stateAdress: any = {
    skip: 0,
    take: 100,
  };

  public editDataItem: DataProviderRent;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;

  public usernameList: Array<DataProviderAppUser> = [];
  public userNameDataService;
  
  public adressList: Array<DataProviderStoreAgency> = [];
  public adressDataService;
  

  constructor(private progressServiceFactory: ProgressServiceFactory,
    private toastr: ToastrService, 
    private appLayout: AppLayoutComponent,
    private loginService: LoginService) {

    this.dataService =
      this.progressServiceFactory.getService<DataProviderRent>(
        getRentConfig(),
        this.state
      );

    this.view = this.dataService.dataChanges();

    this.userNameDataService =
      this.progressServiceFactory.getService<DataProviderAppUser>(
        getAppUserConfig(),
        this.stateUsername
      );

    this.adressDataService =
      this.progressServiceFactory.getService<DataProviderStoreAgency>(
        getStoreAgencyConfig(),
        this.stateAdress
      );
    
    this.dataService.errors.subscribe((error) => {
      if(error && error['error']){
        this.toastr.error(error['error'].message);
        this.dataService.read(this.state);
      }
    });

    this.AppUserId = loginService.getAppUserId();
    this.RoleUser = loginService.getRoleTypeId();
    this.StoreIdUser = loginService.getStoreId();

    console.log("Suntem bineee");
    console.log("role type" + loginService.getRoleTypeId());
    console.log("app user" + loginService.getAppUserId());
    console.log("storeid" + loginService.getStoreId());

}

public CheckIfStoreAgencyIfBelongToStore(storeAgencyId: string): boolean{
  
  for(let item of this.adressList){
    console.log(item.StoreId + " " +  this.StoreIdUser);
    console.log(item.StoreAgencyId +" "+ storeAgencyId);
    if(item.StoreId == this.StoreIdUser && item.StoreAgencyId == storeAgencyId){
      console.log("egal");
      return true;
    }
  }
  return false;
}

public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.adressDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.adressList = data['data'];
    });
    this.adressDataService.read();

    this.dataService.dataChanges().subscribe((data) => {
      if (data && data['data']) {
        var data2: any[];
        if(this.RoleUser == "2"){
          data2 = data['data'].filter(item=>this.CheckIfStoreAgencyIfBelongToStore(item.StoreAgencyId) ); 
          data['data'] = data2;
        }else if(this.RoleUser == "3"){
          data2 = data['data'].filter(item=>this.CheckIfStoreAgencyIfBelongToStore(item.StoreAgencyId) && item.AppUserId == this.AppUserId ); 
          data['data'] = data2;
        }
        
        this.currentRent = data['data'][0]['RentId'];
        this.myselection = [this.currentRent];
        
       }
       
    });
    

    this.userNameDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.usernameList = data['data'];
    });

    this.dataService.read();
    this.userNameDataService.read();
    
    let data: any[]; 
      
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.dataChanges().subscribe((data) => {
      if (data && data['data']) {
        var data2: any[];
        if(this.RoleUser == "2"){
          data2 = data['data'].filter(item=>this.CheckIfStoreAgencyIfBelongToStore(item.StoreAgencyId) ); 
          data['data'] = data2;
        }else if(this.RoleUser == "3"){
          data2 = data['data'].filter(item=>this.CheckIfStoreAgencyIfBelongToStore(item.StoreAgencyId) && item.AppUserId == this.AppUserId ); 
          data['data'] = data2;
        }
        
        this.currentRent = data['data'][0]['RentId'];
        this.myselection = [this.currentRent];
        
       }
       
    });
    this.dataService.read(this.state);
  }

  public addHandler() {
    this.editDataItem = new DataProviderRent();
    this.isNew = true;
    
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(rent: DataProviderRent) {
    if (this.isNew) {
      this.dataService.create(rent);
    } else {
      this.dataService.update(rent);
    }

    this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {
    this.dataService.remove(dataItem);
   

  }

  gridUserSelectionChange(RentGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentRent = selectedData.RentId;
  }

  public usernames(id: string): any {
  
    return this.usernameList.find((x) => x.AppUserId === id);
  }

  public adresses(id: string): any {    
    
    return this.adressList.find((x) => x.StoreAgencyId === id);    
  
  }

  public getComboA(ceva:  any){

  }



}

 
