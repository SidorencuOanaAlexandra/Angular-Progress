import { Component, Inject, Injectable, Injector, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { LoginService } from '../../login/login.service';

@Component({
  selector: 'app-app-layout',
  templateUrl: './app-layout.component.html',
  styleUrls: ['./app-layout.component.css']
})


@Injectable({
  providedIn: 'root',
})

export class AppLayoutComponent{
  
  public isLogged = false;
  constructor(
    private router: Router,
    private loginService: LoginService
  ){
        if(this.loginService.getAppUserId() != ""){
            console.log("e logat");
            this.isLogged = true;
        }
  }

}
