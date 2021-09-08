import { Component,Input, OnInit } from '@angular/core';
import {
  DataStateChangeEvent,
  GridComponent,
} from '@progress/kendo-angular-grid';
import { DataProviderRentArticle } from '../../../../core/data/rentArticle.model';
import { getRentArticleConfig } from '../../../../core/data/rentArticle.config';
import { ProgressServiceFactory } from '../../../../core/data/progress-service-factory';
import { FormControl, FormGroup } from '@angular/forms';
import {DataProviderArticle} from '../../../../core/data/article.model'
import { getArticleConfig } from '../../../../core/data/article.config';

const createFormGroup: (item: any) => FormGroup = (dataItem: any) =>
  new FormGroup({
    RentArticleId: new FormControl(dataItem.RentArticleId),
    RentId: new FormControl(dataItem.RentId),
    ArticleId: new FormControl(dataItem.ArticleId),
    NumberOfArticles: new FormControl(dataItem.NumberOfArticles),
  });
@Component({
  selector: 'app-rent-article-app-user-view',
  templateUrl: './rent-article-app-user-view.component.html',
  styleUrls: ['./rent-article-app-user-view.component.css']
})
export class RentArticleAppUserViewComponent implements OnInit {

  @Input() RentId: string = '';
  

  public state: any = {
    skip: 0,
    take: 10,
    filter: {
      logic: 'and',
      filters: [],
   },
  };
  
  public stateArticle: any = {
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

  public articleList: Array<DataProviderArticle> = [];
  public articleDataService;


  constructor (private progressServiceFactory: ProgressServiceFactory) {
    this.dataService =
    this.progressServiceFactory.getService<DataProviderRentArticle>(
      getRentArticleConfig(),
      this.state
    );

    this.articleDataService =
      this.progressServiceFactory.getService<DataProviderArticle>(
        getArticleConfig(),
        this.stateArticle
      );

    this.view = this.dataService.dataChanges();
  }


  ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
    });
    if(this.RentId != ''){
      this.state.filter.filters = [{field: "RentId", operator: "eq", value: this.RentId}];
    }
    this.articleDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.articleList = data['data'];
    });
   
    this.dataService.read(this.state);
    this.articleDataService.read();
   
  }

  public ngOnChanges(): void {
    if(this.RentId != ''){
      this.state.filter.filters = [{field: "RentId", operator: "eq", value: this.RentId}];
    }
    this.dataService.read(this.state);
   
  }
  
  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
 
  }
  
  public articles(id: string): any {    
   
    return this.articleList.find((x) => x.ArticleId === id);    
  
  }
  


}
