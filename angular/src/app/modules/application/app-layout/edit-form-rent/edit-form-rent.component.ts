import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { DataProviderRent } from '../../../../core/data/rent.model';


@Component({
  selector: 'app-edit-form-rent',
  templateUrl: './edit-form-rent.component.html',
  styleUrls: ['./edit-form-rent.component.css']
})
export class EditFormRentComponent  {

  @Input() addressList: any;

  public currentRent: DataProviderRent;
  public min: Date = new Date(1917, 0, 1);
  public max: Date = new Date(2020, 4, 31);

  public active = false;
  public editForm: FormGroup = new FormGroup({
    RentId: new FormControl(),
    AppUserId: new FormControl(),
    StoreAgencyId: new FormControl(),
    DateFrom: new FormControl(),
    DateTo: new FormControl(),
    RentStatus: new FormControl(),
  });

  @Input() public isNew = false;

  @Input() public set model(rent: DataProviderRent) {
    this.currentRent = rent;
    this.editForm.reset(rent);
  
    this.active = rent !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderRent> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentRent = Object.assign(
      this.currentRent,
      this.editForm.value
    );
    this.save.emit(this.currentRent);
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
