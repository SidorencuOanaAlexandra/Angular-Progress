import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RentAppUserViewComponent } from './rent-app-user-view.component';

describe('RentAppUserViewComponent', () => {
  let component: RentAppUserViewComponent;
  let fixture: ComponentFixture<RentAppUserViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RentAppUserViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RentAppUserViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
