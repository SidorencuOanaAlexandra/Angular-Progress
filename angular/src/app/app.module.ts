import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppLayoutComponent } from '../app/modules/application/app-layout/app-layout.component';
import { ArticleComponent } from '../app/modules/application/app-layout/article/article.component';
import { GridModule } from '@progress/kendo-angular-grid';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ProgressServiceFactory } from './core/data/progress-service-factory';
import { ProgressSessionService } from './core/data/progress-session.service';
import { DataProviderService } from './core/data/service-config';
import { InputsModule } from '@progress/kendo-angular-inputs';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { DropDownListModule } from '@progress/kendo-angular-dropdowns';
import { DialogModule } from '@progress/kendo-angular-dialog';
import { LabelModule } from '@progress/kendo-angular-label';
import { UserViewComponent } from './modules/application/app-layout/AppUserView/user-view/user-view.component';
import { UserRoleViewComponent } from './modules/application/app-layout/UserRoleView/user-role-view/user-role-view.component';
import { EditFormComponent } from './modules/application/app-layout/AppUserView/edit-form/edit-form.component';
import { EditFormUserRoleComponent } from './modules/application/app-layout/UserRoleView/edit-form-user-role/edit-form-user-role.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ArticleStockComponent } from './modules/application/app-layout/article-stock/article-stock.component';
import { ArticleGridEditFormComponent } from './modules/application/app-layout/article/article-edit-form/edit-form.component';
import { TypeDropDownListFilterComponent } from './modules/application/app-layout/article/type-dropdown-filter/dropdown-filter.component';
import { ArticleTypeComponent } from './modules/application/app-layout/article-type/article-type.component';
import { RentViewComponent } from './modules/application/app-layout/rent-view/rent-view.component';
import { RentArticleAppUserViewComponent } from  './modules/application/app-layout/rent-article-app-user-view/rent-article-app-user-view.component';
import { RentArticleViewComponent } from './modules/application/app-layout/rent-article-view/rent-article-view.component';
import { EditFormRentComponent } from './modules/application/app-layout/edit-form-rent/edit-form-rent.component';
import { RentAppUserViewComponent } from './modules/application/app-layout/rent-app-user-view/rent-app-user-view.component';
import { DropdownlistAdressComponent } from './modules/application/app-layout/dropdownlist-adress/dropdownlist-adress.component';
import { DropDownListFilterRentComponent } from './modules/application/app-layout/dropdownlist-filter-rent/dropdownlist-filter.component'
import { CommonModule } from '@angular/common';
import { ToastrModule } from 'ngx-toastr';
import { CartViewComponent } from './modules/application/app-layout/cart-view/cart-view.component';
import { ArticlesViewRentComponent } from './modules/application/app-layout/articles-view-rent/articles-view-rent.component';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { LoginUserComponent } from './modules/login/login-user/login-user.component';
import { ChooseRoleComponent } from './modules/login/choose-role/choose-role.component';
import { StoreViewComponent } from './modules/application/app-layout/store-view/store-view.component';
import { StoreAgencyViewComponent } from './modules/application/app-layout/store-agency-view/store-agency-view.component';
import { GridEditFormStoreComponent } from './modules/application/app-layout/edit-form-store/edit-form-store.component';
import { ArticleStockEditFormComponent } from './modules/application/app-layout/article-stock/article-stock-edit-form/article-stock-edit-form.component';
import { ArticleTypeEditFormComponent } from './modules/application/app-layout/article-type/article-type-edit-form/article-type-edit-form.component';

@NgModule({
  declarations: [
    AppComponent,
    AppLayoutComponent,
    ArticleComponent,
    TypeDropDownListFilterComponent,
    ArticleGridEditFormComponent,
    ArticleStockComponent,
    RentViewComponent,
    ArticleTypeComponent,
    UserViewComponent,
    UserRoleViewComponent,
    EditFormComponent,
    EditFormUserRoleComponent,
    RentArticleAppUserViewComponent,
    RentArticleViewComponent,
    EditFormRentComponent,
    RentAppUserViewComponent,
    DropdownlistAdressComponent,
    DropDownListFilterRentComponent,
    CartViewComponent,
    ArticlesViewRentComponent,
    LoginUserComponent,
    ChooseRoleComponent,
    StoreViewComponent,
    StoreAgencyViewComponent,
    GridEditFormStoreComponent,
    ArticleStockEditFormComponent,
    ArticleTypeEditFormComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    GridModule,
    ReactiveFormsModule,
    DropDownListModule,
    DialogModule,
    InputsModule,
    LabelModule,
    ToastrModule.forRoot(),
    BrowserAnimationsModule, 
    FormsModule
  ],
  providers: [
    DataProviderService,
    ProgressServiceFactory,
    ProgressSessionService,
    HttpClient
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
