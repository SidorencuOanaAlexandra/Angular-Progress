import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { DataProviderStore } from '../../../../core/data/store.model';

@Component({
  selector: 'store-kendo-grid-edit-form',
  styleUrls: ['./edit-form-store.component.css'],
  templateUrl: './edit-form-store.component.html',
})
export class GridEditFormStoreComponent {
  @Input() stateList: any;

  public currentStore: DataProviderStore;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    Description: new FormControl()
  });

  @Input() public isNew = false;

  @Input() public set model(store: DataProviderStore) {
    this.currentStore = store;
    this.editForm.reset(store);

    this.active = store !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderStore> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentStore = Object.assign(
      this.currentStore,
      this.editForm.value
    );
    this.save.emit(this.currentStore);
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
