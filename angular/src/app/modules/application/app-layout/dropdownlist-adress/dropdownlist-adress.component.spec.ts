import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DropdownlistAdressComponent } from './dropdownlist-adress.component';

describe('DropdownlistAdressComponent', () => {
  let component: DropdownlistAdressComponent;
  let fixture: ComponentFixture<DropdownlistAdressComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DropdownlistAdressComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DropdownlistAdressComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
