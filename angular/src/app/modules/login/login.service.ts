import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({ providedIn: 'root' })
export class LoginService {

   public AppUserId: string = '';
   public RoleTypeId: string = '';
   public StoreId: string = '';

   constructor(private http: HttpClient) {}

    login(username: string, password: string){
        const body = {   "request":{
                                    "username": username,
                                    "password": password
                                   }
                     };
                    // http://localhost:8810/ArticoleSportive/static/ServiceREST.json
        return this.http.put<any>(`http://localhost:8810/ArticoleSportive/rest/ServiceREST/SIAppUser/login`, body);
    }

    public setRoleTypeId(id: string){
        this.RoleTypeId = id;
    }

    public setAppUserId(id: string){
        this.AppUserId = id;
    }

    public setStoreId(id: string){
        this.StoreId = id;
    }

    public getRoleTypeId(): string{
        return this.RoleTypeId;
    }

    public getAppUserId(): string{
        return this.AppUserId;
    }

    public getStoreId(): string{
        return this.StoreId;
    }
}