import { ActivatedRoute} from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import {DataProviderRent} from '../../../../core/data/rent.model'
import { getRentConfig } from '../../../../core/data/rent.config';
import { ProgressServiceFactory } from '../../../../core/data/progress-service-factory';
import {DataProviderStoreAgency} from '../../../../core/data/storeAgency.model'
import { getStoreAgencyConfig } from '../../../../core/data/storeAgency.config';


@Component({
  selector: 'app-rent-app-user-view',
  templateUrl: './rent-app-user-view.component.html',
  styleUrls: ['./rent-app-user-view.component.css']
})
export class RentAppUserViewComponent implements OnInit {

  private UserId: string = '';


  public currentRent: string = '';

  public state: any = {
    skip: 0,
    take: 5,
    filter: {
      logic: 'and',
      filters: [],
    },
  };

  public username: any = {
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

  public adressList: Array<DataProviderStoreAgency> = [];
  public adressDataService;

  constructor(private progressServiceFactory: ProgressServiceFactory,private route: ActivatedRoute) { 
    this.dataService =
    this.progressServiceFactory.getService<DataProviderRent>(
      getRentConfig(),
      this.state
    );

    this.view = this.dataService.dataChanges();

    this.adressDataService =
    this.progressServiceFactory.getService<DataProviderStoreAgency>(
      getRentConfig(),
      this.stateAdress
    );

    



  }

  ngOnInit(): void {
    const id = String(this.route.snapshot.paramMap.get('id'));
    this.UserId = id;
   
    this.adressDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.adressList = data['data'];
    });
    this.state.filter.filters = [{field: "AppUserId", operator: "eq", value: this.UserId}];
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.read(this.state);
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
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

  public saveHandler(customer: DataProviderRent) {
    if (this.isNew) {
      this.dataService.create(customer);
    } else {
      this.dataService.update(customer);
    }

    this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {
    this.dataService.remove(dataItem);
   

  }

  gridUserSelectionChange(customerGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentRent = selectedData.RentId;
  }

  public adresses(id: string): any {
    return this.adressList.find((x) => x.StoreAgencyId === id);
  }

}
