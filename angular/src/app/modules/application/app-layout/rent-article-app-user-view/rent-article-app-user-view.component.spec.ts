import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RentArticleAppUserViewComponent } from './rent-article-app-user-view.component';

describe('RentArticleAppUserViewComponent', () => {
  let component: RentArticleAppUserViewComponent;
  let fixture: ComponentFixture<RentArticleAppUserViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RentArticleAppUserViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RentArticleAppUserViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
