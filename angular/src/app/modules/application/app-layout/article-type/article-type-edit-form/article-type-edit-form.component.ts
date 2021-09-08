import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { DataProviderArticleType } from '../../../../../core/data/article-type.model';

@Component({
  selector: 'app-article-type-edit-form',
  templateUrl: './article-type-edit-form.component.html',
  styleUrls: ['./article-type-edit-form.component.css']
})
export class ArticleTypeEditFormComponent {

  @Input() articleTypeList: any;
  public currentArticleType: DataProviderArticleType;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    Description: new FormControl(),
  });

  @Input() public isNew = false;

  @Input() public set model(article: DataProviderArticleType) {
    this.currentArticleType = article;
    this.editForm.reset(article);

    this.active = article !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderArticleType> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentArticleType = Object.assign(
      this.currentArticleType,
      this.editForm.value
    );
    this.save.emit(this.currentArticleType);
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
