import { Component, Input, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { DataProviderArticle } from '../../../../core/data/article.model';
import { DataProviderArticleType } from '../../../../core/data/article-type.model';
import { getArticleConfig } from '../../../../core/data/article.config';
import { getArticleTypeConfig } from '../../../../core/data/article-type.config';
import { ProgressServiceFactory } from '../../../../core/data/progress-service-factory';
import { ToastrService } from 'ngx-toastr';
import { LoginService } from '../../../login/login.service';

@Component({
  selector: 'app-article',
  templateUrl: './article.component.html',
  styleUrls: ['./article.component.css'],
})
export class ArticleComponent implements OnInit {
  public currentArticle: string = '';
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

  public editDataItem: DataProviderArticle;
  public isNew: boolean;
  public articleTypeList: Array<DataProviderArticleType> = [];
  public dataService;
  public articleTypeDataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;

  constructor(private progressServiceFactory: ProgressServiceFactory, 
              private toastr: ToastrService, 
              private loginService: LoginService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderArticle>(
        getArticleConfig(),
        this.state
      );

    this.view = this.dataService.dataChanges();

    this.articleTypeDataService =
      this.progressServiceFactory.getService<DataProviderArticleType>(
        getArticleTypeConfig(),
        this.state2
      );
  }

  public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.articleTypeDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.articleTypeList = data['data'];
    });
    this.dataService.read();
    this.articleTypeDataService.read();
    this.roleType = this.loginService.getRoleTypeId();
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public addHandler() {
    this.editDataItem = new DataProviderArticle();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(article: DataProviderArticle) {
    if (this.isNew) {
      this.dataService.create(article);
    } else {
      this.dataService.update(article);
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

  gridUserSelectionChange(articleGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentArticle = selectedData.ArticleId;
  }

  public articleType(id: string): any {
    return this.articleTypeList.find((x) => x.ArticleTypeId === id);
  }
}
