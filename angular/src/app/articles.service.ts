import { Injectable } from '@angular/core';
import {DataProviderArticle} from './data/article.model';
import {Observable, of, EMPTY} from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { tap, map } from "rxjs/operators";
import { catchError } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class ArticlesService {

  private articleUrl = "http://localhost:8810/ArticoleSportive/rest/ServiceREST/SIArticle";

  constructor(private http: HttpClient) { }

  getArticles(): Observable<DataProviderArticle[]> {
    return this.http.get<{dsArticle: {ttArticle: [DataProviderArticle]}}>(this.articleUrl).pipe(
      tap( response => console.log(response)),
      map(response => response['dsArticle']['ttArticle'])
    );
  }
}
