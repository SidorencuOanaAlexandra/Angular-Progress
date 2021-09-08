import { Component, Input, OnChanges } from '@angular/core';
import {
  DataStateChangeEvent,
  GridComponent,
} from '@progress/kendo-angular-grid';
import { getStoreAgencyConfig } from '../../../../core/data/store-agency.config';
import { FormControl, FormGroup } from '@angular/forms';
import { ProgressServiceFactory } from '../../../../core/data/progress-service-factory';
import { DataProviderStoreAgency } from '../../../../core/data/store-agency.model';
import { ToastrService } from 'ngx-toastr';
import { AppLayoutComponent } from '../app-layout.component';
import { LoginService } from 'src/app/modules/login/login.service';

const createFormGroup: (item: any) => FormGroup = (dataItem: any) =>
  new FormGroup({
    StoreId: new FormControl(dataItem.StoreId),
    Address: new FormControl(dataItem.Address),
     });

@Component({
  selector: 'app-store-agency-view',
  templateUrl: './store-agency-view.component.html',
  styleUrls: ['./store-agency-view.component.css']
})
export class StoreAgencyViewComponent implements OnChanges {

  @Input() StoreId: string = '';
  @Input() storeId: string = '';
  @Input() roleType: string = '';

  public state: any = {
    skip: 0,
    take: 4,
    filter: {
      logic: 'and',
      filters: [],
   },
  };

  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  private editedRowIndex: number;
  private originalItem: any;
  public formGroup: FormGroup;

  constructor (private progressServiceFactory: ProgressServiceFactory, 
    private toastr: ToastrService,
    private appLayout: AppLayoutComponent,
    private loginService: LoginService) {
    this.dataService =
    this.progressServiceFactory.getService<DataProviderStoreAgency>(
      getStoreAgencyConfig(),
      this.state
    );

    this.view = this.dataService.dataChanges();

    this.dataService.errors.subscribe((error) => {
      if(error && error['error']){
      this.toastr.error(error['error'].message);
      }
      });

      this.roleType=loginService.getRoleTypeId();
      this.storeId=loginService.getStoreId();
  }

 public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
    });
    if(this.StoreId != ''){
      this.state.filter.filters = [{field: "StoreId", operator: "eq", value: this.StoreId}];
    }
   
    this.dataService.read(this.state);
  }

  public ngOnChanges(): void {
    if(this.StoreId != ''){
      this.state.filter.filters = [{field: "StoreId", operator: "eq", value: this.StoreId}];
    }
    this.dataService.read(this.state);
  }
  
  public editHandler(e: any): void {
    const { sender, rowIndex, dataItem } = e;
    this.originalItem = Object.assign({}, dataItem);
    this.editDataModel = dataItem;
    this.formGroup = createFormGroup(this.originalItem);
    this.closeEditor(sender);
    this.editedRowIndex = rowIndex;
    sender.editRow(rowIndex, this.formGroup);
  }
  
  public cancelHandler({ sender, rowIndex }: any): void {
    Object.assign(this.editDataModel, this.originalItem);
    this.closeEditor(sender, rowIndex);
  }
  
  public saveHandler({ sender, rowIndex, isNew }: any): void {
    const item: any = Object.assign(this.editDataModel, this.formGroup.value);
    item.StoreId = this.StoreId;
    if (isNew) {
      this.dataService.create(item);
    } else {
      this.dataService.update(item);
    }
  
    sender.closeRow(rowIndex);
  }
  
  public addHandler(e: any): void {
    const { sender } = e;
    this.editDataModel = this.dataService.createModel();
    this.formGroup = createFormGroup({});
    this.closeEditor(sender);
    sender.addRow(this.formGroup);
  }
  
  public removeHandler(e: any): void {
    const { dataItem } = e;
    this.dataService.remove(dataItem);
  }
  
  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }
  
  private closeEditor(
    grid: GridComponent,
    rowIndex: number = this.editedRowIndex
  ): void {
    grid.closeRow(rowIndex);
    this.editedRowIndex = undefined;
  }

}
  
    
   
  