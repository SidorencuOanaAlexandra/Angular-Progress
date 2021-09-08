import { Component,Input, OnInit, ViewChild } from '@angular/core';
import {
  DataStateChangeEvent,
  GridComponent,
} from '@progress/kendo-angular-grid';
import { DataProviderRentArticle } from '../../../../core/data/rentArticle.model';
import { getRentArticleConfig } from '../../../../core/data/rentArticle.config';
import { ProgressServiceFactory } from '../../../../core/data/progress-service-factory';
import { FormControl, FormGroup } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import {DataProviderArticle} from '../../../../data/article.model'
import {getArticleConfig} from '../../../../data/article.config'

const createFormGroup: (item: any) => FormGroup = (dataItem: any) =>
  new FormGroup({
    RentArticleId: new FormControl(dataItem.RentArticleId),
    RentId: new FormControl(dataItem.RentId),
    ArticleId: new FormControl(dataItem.ArticleId),
    NumberOfArticles: new FormControl(dataItem.NumberOfArticles),
  });
@Component({
  selector: 'app-rent-article-view',
  templateUrl: './rent-article-view.component.html',
  styleUrls: ['./rent-article-view.component.css']
})
export class RentArticleViewComponent implements OnInit {
  
  @Input() RentId: string = '';
  @Input() RoleTypeId: string = '';
  
  @ViewChild('rentArticleGrid') rentArticleGrid: GridComponent;

  public state: any = {
    skip: 0,
    take: 10,
    filter: {
      logic: 'and',
      filters: [],
   },
  };

  public stateModel: any = {
    skip: 0,
    take: 100,
  };

  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  private editedRowIndex: number;
  private originalItem: any;
  public formGroup: FormGroup;

  public modelsList: Array<DataProviderArticle> = [];
  public modelDataService;


  constructor (private progressServiceFactory: ProgressServiceFactory,private toastr: ToastrService) {
    this.dataService =
    this.progressServiceFactory.getService<DataProviderRentArticle>(
      getRentArticleConfig(),
      this.state
    );

    this.modelDataService =
      this.progressServiceFactory.getService<DataProviderArticle>(
        getArticleConfig(),
        this.stateModel
      );

    this.view = this.dataService.dataChanges();

    this.dataService.errors.subscribe((error) => {
      if(error && error['error']){
        if(error['error'].message != ""){
        this.toastr.error(error['error'].message);
        }
        this.dataService.read(this.state);
      }
    });
  }


  ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
    });

    this.modelDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.modelsList = data['data'];
    });
  
    if(this.RentId != ''){
      this.state.filter.filters = [{field: "RentId", operator: "eq", value: this.RentId}];
      
    }


    console.log("Filter: " + this.state.filter.filters);
    this.dataService.read(this.state);
    this.modelDataService.read();
    
    
   
   
   
  }

  public ngOnChanges(): void {
    if (this.RentId != '' ) {
      this.rentArticleGrid.filterChange.emit({
      filters: [{field: 'RentId',operator: 'eq',value: this.RentId,},],logic: 'and',});}
    
      this.dataService.read();
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
    let item: any = Object.assign(this.editDataModel, this.formGroup.value);
    item.RentId = this.RentId;
    if (isNew) {
      this.dataService.create(item);
      this.dataService.read(this.state);
    } else {
      this.dataService.update(item);
      this.dataService.read(this.state);
      
    }
  
    sender.closeRow(rowIndex);
    this.state.filter.filters = [{field: "RentId", operator: "eq", value: this.RentId}];
    this.dataService.read(this.state);
  }
  
  public addHandler(e: any): void {
    const { sender } = e;
    this.editDataModel = this.dataService.createModel();
    this.formGroup = createFormGroup({});
    this.closeEditor(sender);
    sender.addRow(this.formGroup);
    this.state.filter.filters = [{field: "RentId", operator: "eq", value: this.RentId}];
    this.dataService.read(this.state);
  }
  
  public removeHandler(e: any): void {
    const { dataItem } = e;
    this.dataService.remove(dataItem);
    this.state.filter.filters = [{field: "RentId", operator: "eq", value: this.RentId}];
    this.dataService.read(this.state);
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    
    this.state.filter.fil
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

  public models(id: string): any {
    
    return this.modelsList.find((x) => x.ArticleId === id);
  }

}
