import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { DataProviderAppUser } from '../../../../../core/data/user.model';


@Component({
  selector: 'app-edit-form',
  templateUrl: './edit-form.component.html',
  styleUrls: ['./edit-form.component.css']
})
export class EditFormComponent {

  @Input() userRoleList: any;

  public currentAppUser: DataProviderAppUser;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    Name: new FormControl(),
    UserName: new FormControl(),
    Password: new FormControl()
  });

  @Input() public isNew = false;

  @Input() public set model(user: DataProviderAppUser) {
    this.currentAppUser = user;
    this.editForm.reset(user);

    this.active = user !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderAppUser> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentAppUser = Object.assign(
      this.currentAppUser,
      this.editForm.value
    );
    this.save.emit(this.currentAppUser);
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
