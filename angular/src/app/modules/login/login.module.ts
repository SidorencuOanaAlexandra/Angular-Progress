import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { LoginRoutingModule } from './login-routing.module';
import { LoginUserComponent } from './login-user/login-user.component';
import { ChooseRoleComponent } from './choose-role/choose-role.component';


@NgModule({
  declarations: [
    LoginUserComponent,
    ChooseRoleComponent
    
  ],
  imports: [
    CommonModule,
    LoginRoutingModule
  ]
})
export class LoginModule { }
