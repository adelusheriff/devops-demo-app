const request = require('supertest');
const createApp = require('../src/app');

const app = createApp();

describe('GET /', () => {
  it('serves the HTML landing page', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
    expect(res.headers['content-type']).toMatch(/html/);
  });
});

describe('GET /api/info', () => {
  it('returns 200 and a welcome message', async () => {
    const res = await request(app).get('/api/info');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('message');
  });
});

describe('GET /health', () => {
  it('returns 200 with db reported as not_configured when no DB env vars are set', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('ok');
    expect(res.body.db.status).toBe('not_configured');
  });
});

describe('GET /api/tasks', () => {
  it('returns a list of tasks', async () => {
    const res = await request(app).get('/api/tasks');
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body.tasks)).toBe(true);
  });
});

describe('unknown route', () => {
  it('returns 404', async () => {
    const res = await request(app).get('/nope');
    expect(res.statusCode).toBe(404);
  });
});
