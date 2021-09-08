import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { DataProviderArticle } from '../../../../../core/data/article.model';

@Component({
  selector: 'kendo-grid-edit-form',
  templateUrl: './edit-form.component.html',
  styleUrls: ['./edit-form.component.css']
})
export class ArticleGridEditFormComponent {
  @Input() articleTypeList: any;
  public currentArticle: DataProviderArticle;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    Model: new FormControl(),
    Manufacturer: new FormControl(),
    ArticleTypeId: new FormControl()
  });

  @Input() public isNew = false;

  @Input() public set model(article: DataProviderArticle) {
    this.currentArticle = article;
    this.editForm.reset(article);

    this.active = article !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderArticle> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentArticle = Object.assign(
      this.currentArticle,
      this.editForm.value
    );
    this.save.emit(this.currentArticle);
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
