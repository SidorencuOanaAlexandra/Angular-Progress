import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { ProgressServiceFactory } from 'src/app/core/data/progress-service-factory';
import { getRoleConfig } from 'src/app/core/data/role-type.config';
import { DataProviderRoleType } from 'src/app/core/data/role-type.model';
import { getStoreConfig } from 'src/app/core/data/store.config';
import { DataProviderStore } from 'src/app/core/data/store.model';
import { DataProviderUserRole } from '../../../../../core/data/user-role.model';
import { DataProviderAppUser } from '../../../../../core/data/user.model';

@Component({
  selector: 'app-edit-form-user-role',
  templateUrl: './edit-form-user-role.component.html',
  styleUrls: ['./edit-form-user-role.component.css']
})
export class EditFormUserRoleComponent{

  @Input() userRoleList: any;

  public currentUserRole: DataProviderUserRole;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    RoleTypeId: new FormControl(),
    StoreId: new FormControl(),
    AppUserId: new FormControl()
  });
 
  @Input() public isNew = false;

  @Input() public set model(user: DataProviderUserRole) {
    this.currentUserRole = user;
    this.editForm.reset(user);

    this.active = user !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderUserRole> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentUserRole = Object.assign(
      this.currentUserRole,
      this.editForm.value
    );
    this.save.emit(this.currentUserRole);
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
