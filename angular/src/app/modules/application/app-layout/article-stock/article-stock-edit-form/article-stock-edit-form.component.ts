import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { DataProviderArticleStock } from '../../../../../core/data/article-stock.model';

@Component({
  selector: 'app-article-stock-edit-form',
  templateUrl: './article-stock-edit-form.component.html',
  styleUrls: ['./article-stock-edit-form.component.css']
})
export class ArticleStockEditFormComponent{
  public currentArticleStock: DataProviderArticleStock;
  @Input() storeAgencyList: any;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    StoreAgencyId: new FormControl(),
    StockAmount: new FormControl(),
    ValidFrom: new FormControl(),
    ValidTo: new FormControl(),
  });

  @Input() public isNew = false;

  @Input() public set model(articleStock: DataProviderArticleStock) {
    this.currentArticleStock = articleStock;
    this.editForm.reset(articleStock);

    this.active = articleStock !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderArticleStock> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentArticleStock = Object.assign(
      this.currentArticleStock,
      this.editForm.value
    );
    this.save.emit(this.currentArticleStock);
    this.active = false;
  }

  public onCancel(e): void {
    e.preventDefault();
    this.closeForm();
  }

  public closeForm(): void {
    this.active = false;
    this.cancel.emit();
  }

}
