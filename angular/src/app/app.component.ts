import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { LoginService } from './modules/login/login.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {

  constructor(
    private router: Router,
    private loginService: LoginService
  ){}

  public isLogged(): boolean{
      return (this.loginService.getAppUserId() != "");
  }

  public hasRole(): boolean{
    return (this.loginService.getRoleTypeId() != "");
  }

  public isSuperadmin(): boolean{
    return (this.loginService.getRoleTypeId() == "1");
  }
}
