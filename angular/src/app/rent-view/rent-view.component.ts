import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { DataProviderRent} from '../core/data/rent.model'
import { getRentConfig } from '../core/data/rent.config';
import { ProgressSessionService } from '../core/data/progress-session.service';
import { ProgressServiceFactory } from '../core/data/progress-service-factory';
import { DataProviderService } from '../core/data/service-config';


@Component({
  selector: 'app-rent-view',
  templateUrl: './rent-view.component.html',
  styleUrls: ['./rent-view.component.css']
})
export class RentViewComponent implements OnInit {

  public currentRent: number = 0;

  public state: any = {
    skip: 0,
    take: 10,
    filter: {
      logic: 'and',
      filters: [],
    },
  };

  public state2: any = {
    skip: 0,
    take: 100,
  };

  public editDataItem: DataProviderRent;
  public isNew: boolean;
 // public stateList: Array<DataProviderState> = [];
  public dataService;
  //public stateDataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;


  constructor(private progressServiceFactory: ProgressServiceFactory) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderRent>(
        getRentConfig(),
        this.state
      );

    this.view = this.dataService.dataChanges();

    // this.stateDataService =
    //   this.progressServiceFactory.getService<DataProviderRent>(
    //     getStateConfig(),
    //     this.state2
    //   );
  }


  public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();

    // this.stateDataService.dataChanges().subscribe((data) => {
    //   if (data && data['data']) this.stateList = data['data'];
    // });
    this.dataService.read();
    //this.stateDataService.read();
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
    this.dataService.read();
    //this.dataServiceData = this.dataService.dataChanges();

  }

  gridUserSelectionChange(customerGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentRent = selectedData.RentId;
  }

  // public states(id: string): any {
  //   return this.stateList.find((x) => x.State === id);
  // }
}

 
