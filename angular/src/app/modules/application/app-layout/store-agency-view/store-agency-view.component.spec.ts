import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StoreAgencyViewComponent } from './store-agency-view.component';

describe('StoreAgencyViewComponent', () => {
  let component: StoreAgencyViewComponent;
  let fixture: ComponentFixture<StoreAgencyViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StoreAgencyViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StoreAgencyViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
