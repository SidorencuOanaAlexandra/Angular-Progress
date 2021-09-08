import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RentArticleViewComponent } from './rent-article-view.component';

describe('RentArticleViewComponent', () => {
  let component: RentArticleViewComponent;
  let fixture: ComponentFixture<RentArticleViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RentArticleViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RentArticleViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
