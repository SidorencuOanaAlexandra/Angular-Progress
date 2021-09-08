import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { UserRoleViewComponent } from './modules/application/app-layout/UserRoleView/user-role-view/user-role-view.component';
import {UserViewComponent} from './modules/application/app-layout/AppUserView/user-view/user-view.component';
import {RentViewComponent} from './modules/application/app-layout/rent-view/rent-view.component';
import {RentAppUserViewComponent} from './modules/application/app-layout/rent-app-user-view/rent-app-user-view.component'
import {ArticlesViewRentComponent} from './modules/application/app-layout/articles-view-rent/articles-view-rent.component';
import {CartViewComponent} from './modules/application/app-layout/cart-view/cart-view.component';
import { LoginUserComponent } from './modules/login/login-user/login-user.component';
import { ChooseRoleComponent } from './modules/login/choose-role/choose-role.component';
import { AppLayoutComponent } from './modules/application/app-layout/app-layout.component';
import { StoreViewComponent } from './modules/application/app-layout/store-view/store-view.component';
import { StoreAgencyViewComponent } from './modules/application/app-layout/store-agency-view/store-agency-view.component';
import { AppComponent } from './app.component';


const routes: Routes = [
  {path: 'rent-view', component:RentViewComponent },
  {path: 'user-view', component:UserViewComponent},
  {path: 'user-role-view', component:UserRoleViewComponent},
  {path: 'rent-app-user-view/:id', component:RentAppUserViewComponent},
  {path: 'card', component:CartViewComponent},
  {path: 'articles', component:ArticlesViewRentComponent},
  {path: 'card', component:CartViewComponent},
  {path: 'login', component: LoginUserComponent},
  {path: 'choose-role', component: ChooseRoleComponent},
  {path: 'store-view',component:StoreViewComponent},
  {path: 'store-agency-view',component:StoreAgencyViewComponent}
]


@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
