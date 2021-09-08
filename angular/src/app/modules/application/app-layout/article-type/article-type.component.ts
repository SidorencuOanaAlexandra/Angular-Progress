import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { ProgressServiceFactory } from '../../../../core/data/progress-service-factory';
import { DataProviderArticleType } from '../../../../core/data/article-type.model';
import { getArticleTypeConfig } from '../../../../core/data/article-type.config';
import { ToastrService } from 'ngx-toastr';
import { LoginService } from '../../../login/login.service';

@Component({
  selector: 'app-article-type',
  templateUrl: './article-type.component.html',
  styleUrls: ['./article-type.component.css']
})
export class ArticleTypeComponent implements OnInit {
  public currentArticleType: string = '';
  public roleType: string = '';

  public state: any = {
    skip: 0,
    take: 5,
    filter: {
      logic: 'and',
      filters: [],
    },
  };

  public editDataItem: DataProviderArticleType;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  public articleTypeList: Array<DataProviderArticleType> = [];

  constructor(private progressServiceFactory: ProgressServiceFactory, 
              private toastr: ToastrService,
              private loginService: LoginService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderArticleType>(
        getArticleTypeConfig(),
        this.state
      );
    this.view = this.dataService.dataChanges();
  }

  public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.read();
    this.roleType = this.loginService.getRoleTypeId();
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public addHandler() {
    this.editDataItem = new DataProviderArticleType();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(articleType: DataProviderArticleType) {
    if (this.isNew) {
      this.dataService.create(articleType);
    } else {
      this.dataService.update(articleType);
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
}
