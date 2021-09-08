import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { first } from 'rxjs/operators';
import { LoginService } from '../login.service';


@Component({
  selector: 'app-login-user',
  templateUrl: './login-user.component.html',
  styleUrls: ['./login-user.component.css']
})
export class LoginUserComponent implements OnInit {

  loginForm: FormGroup;
  loading = false;
  submitted = false;
  isLogged = false;

  constructor(
      private formBuilder: FormBuilder,
      private route: ActivatedRoute,
      private router: Router,
      private loginService: LoginService
  ) {}

  ngOnInit() {
      this.loginForm = this.formBuilder.group({
          username: ['', Validators.required],
          password: ['', Validators.required]
      });
  }

  // convenience getter for easy access to form fields
  get f() { return this.loginForm.controls; }

  onSubmit() {
      this.submitted = true;

      // stop here if form is invalid
      if (this.loginForm.invalid) {
          return;
      }

     this.loading = true;
     this.loginService.login(this.f.username.value, this.f.password.value)
          .subscribe((data) => {
            console.log(data['response']['_retVal']) ;  
            if (data['response']['_retVal'] != "false"){
                alert("Successfully logged in!");
                this.isLogged = true;
                this.loginService.setAppUserId(data['response']['_retVal']);
                this.router.navigate(['/choose-role']);
            }
            else{
                alert("error");
                this.loading = false;
            }
          });
    }
        

}
   

