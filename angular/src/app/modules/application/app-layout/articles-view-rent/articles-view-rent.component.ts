import { Component, OnInit } from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {DataProviderArticle} from '../../../../data/article.model';
import {AppRoutingModule} from '../../../../app-routing.module';
import { Observable } from 'rxjs';
import {ArticlesService} from '../../../../articles.service';
import {CartService} from '../../../../cart.service';

@Component({
  selector: 'app-articles-view-rent',
  templateUrl: './articles-view-rent.component.html',
  styleUrls: ['./articles-view-rent.component.css']
})
export class ArticlesViewRentComponent implements OnInit {

  articles: any[] = [];

  constructor(private articleService: ArticlesService, private cartService:CartService) { }

  ngOnInit(): void {
    this.getArticles();
  }

  getArticles(): void{
    this.articleService.getArticles()
      .subscribe(articles => {
        this.articles = articles
        this.articles.forEach((a:any) => {
          Object.assign(a,{quantity:1});
        })
      });
  }

  addToCart(article: DataProviderArticle){
    this.cartService.addToCard(article);
  }



}
