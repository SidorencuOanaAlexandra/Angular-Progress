import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ArticlesViewRentComponent } from './articles-view-rent.component';

describe('ArticlesViewRentComponent', () => {
  let component: ArticlesViewRentComponent;
  let fixture: ComponentFixture<ArticlesViewRentComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ArticlesViewRentComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ArticlesViewRentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
