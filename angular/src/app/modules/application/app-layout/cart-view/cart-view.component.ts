import { Component, OnInit } from '@angular/core';
import { CartService} from '../../../../cart.service'

@Component({
  selector: 'app-cart-view',
  templateUrl: './cart-view.component.html',
  styleUrls: ['./cart-view.component.css']
})
export class CartViewComponent implements OnInit {

  public articles: any = [];

  constructor(private cartService: CartService) { }

  ngOnInit(): void {
    this.cartService.getArticles()
      .subscribe(res => this.articles = res);
    
  }

  removeFromCart(item: any){
    this.cartService.removeCardArticle(item);
  }

}
