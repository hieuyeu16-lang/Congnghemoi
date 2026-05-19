import { jest } from '@jest/globals';
import request from 'supertest';

const dbMock = {
  testConnection: async () => ({ value: 1 }),
  query: async () => ({ rows: [{ now: new Date().toISOString() }] })
};

jest.unstable_mockModule('./db.js', () => dbMock);

const { default: app } = await import('./app.js');

describe('Backend health API', () => {
  it('returns status ok and connected db', async () => {
    const response = await request(app).get('/api/health');
    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      status: 'ok',
      timestamp: expect.any(String),
      db: 'connected'
    });
  });
});
