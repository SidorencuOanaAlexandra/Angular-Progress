import { Component, OnChanges, Input, OnInit } from '@angular/core';
import { DataStateChangeEvent, GridComponent } from '@progress/kendo-angular-grid';
import { ProgressServiceFactory } from '../../../../core/data/progress-service-factory';
import { DataProviderArticleStock } from '../../../../core/data/article-stock.model';
import { getArticleStockConfig } from '../../../../core/data/article-stock.config';
import { ToastrService } from 'ngx-toastr';
import { DataProviderStoreAgency } from '../../../../core/data/store-agency.model';
import { getStoreAgencyConfig } from '../../../../core/data/store-agency.config';
import { LoginService } from '../../../login/login.service';

@Component({
  selector: 'app-article-stock',
  templateUrl: './article-stock.component.html',
  styleUrls: ['./article-stock.component.css']
})
export class ArticleStockComponent implements OnChanges {
  public currentArticleStock: string = '';
  @Input() ArticleId: string = '';
  public roleType: string = '';

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
    take: 5,
  };

  public dataService;
  public dataServiceData: any;
  public storeAgencyList: Array<DataProviderStoreAgency> = [];
  public storeAgencyDataService;
  public view;
  public editDataModel: any;
  public editDataItem: any;
  public isNew: boolean;

  constructor (private progressServiceFactory: ProgressServiceFactory, 
              private toastr: ToastrService,
              private loginService: LoginService) {
    this.dataService =
    this.progressServiceFactory.getService<DataProviderArticleStock>(
      getArticleStockConfig(),
      this.state
    );
    this.view = this.dataService.dataChanges();
    this.storeAgencyDataService =
      this.progressServiceFactory.getService<DataProviderStoreAgency>(
        getStoreAgencyConfig(),
        this.state2
      );
  }

 public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
    });
    if(this.ArticleId != ''){
      this.state.filter.filters = [{field: "ArticleId", operator: "eq", value: this.ArticleId}];
    }
    this.storeAgencyDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.storeAgencyList = data['data'];
    });
    this.dataService.read(this.state);
    this.dataService.read();
    this.storeAgencyDataService.read();
    this.roleType = this.loginService.getRoleTypeId();
  }

  public ngOnChanges(): void {
    if(this.ArticleId != ''){
      this.state.filter.filters = [{field: "ArticleId", operator: "eq", value: this.ArticleId}];
    }
    this.dataService.read(this.state);
  }
  
  public addHandler() {
    this.editDataItem = new DataProviderArticleStock();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(articleStock: DataProviderArticleStock) {
    articleStock.ArticleId = this.ArticleId;
    if (this.isNew) {
      this.dataService.create(articleStock);
    } else {
      this.dataService.update(articleStock);
    }
    this.editDataItem = undefined;
    this.dataService.errors.subscribe((error) => {
      if (error && error['error']) {
        this.toastr.error(error['error'].message);
        this.dataService.read(this.state);
      }
    });
  }

  public removeHandler({ dataItem }) {
    this.dataService.remove(dataItem);
  }
 
  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public storeAgency(id: string): any {
    return this.storeAgencyList.find((x) => x.StoreAgencyId === id);
  }
}
