import { Injectable } from '@angular/core';
import {DataProviderArticle} from './data/article.model';
import {BehaviorSubject} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CartService {

  public cartProductList : any = [];
  public articleList = new BehaviorSubject<any>([]);

  constructor() { }

  getArticles(){
    return this.articleList.asObservable();
  }

  setArticle(product: any){
    this.cartProductList.push(...product);
    this.articleList.next(product);
  }

  addToCard(product: any){
    var ok = 0;
    this.cartProductList.forEach(function (value) {
      if(value.ArticleId == product.ArticleId)
      {
        ok=1;
        value.quantity = value.quantity + 1;
      }
    });
    if(ok==0){
    this.cartProductList.push(product);
    this.articleList.next(this.cartProductList);
    }
    console.log(this.cartProductList);
  }

  removeCardArticle(product: any){
    this.cartProductList.map((a:any, intex:any)=>{
      if(product.ArticleId === a.ArticleId)
        this.cartProductList.splice(intex,1);
    })
  }

  removeAllCard(){
    this.cartProductList = [];
    this.articleList.next(this.cartProductList);
  }
}
