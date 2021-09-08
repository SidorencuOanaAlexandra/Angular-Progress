import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditFormUserRoleComponent } from './edit-form-user-role.component';

describe('EditFormUserRoleComponent', () => {
  let component: EditFormUserRoleComponent;
  let fixture: ComponentFixture<EditFormUserRoleComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditFormUserRoleComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditFormUserRoleComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
