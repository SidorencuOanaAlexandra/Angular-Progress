import { TestBed } from '@angular/core/testing';

import { ArticalsService } from './articals.service';

describe('ArticalsService', () => {
  let service: ArticalsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ArticalsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
