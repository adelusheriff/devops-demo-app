const { Pool } = require('pg');

// Pool reads connection info from env vars so we never hardcode credentials.
// DB_HOST / DB_PORT / DB_NAME / DB_USER / DB_PASSWORD are injected at
// container runtime (see .github/workflows/ci-cd.yml deploy step).
let pool;

function getPool() {
  if (!pool) {
    pool = new Pool({
      host: process.env.DB_HOST,
      port: process.env.DB_PORT || 5432,
      database: process.env.DB_NAME,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      max: 5,
      connectionTimeoutMillis: 3000,
    });
  }
  return pool;
}

// Used by /health. If DB env vars aren't set (e.g. running app tests
// without a real database), we report db as "not_configured" instead of
// failing outright — this keeps unit tests independent of infrastructure.
async function checkDbConnection() {
  if (!process.env.DB_HOST) {
    return { status: 'not_configured' };
  }
  try {
    const client = await getPool().connect();
    await client.query('SELECT 1');
    client.release();
    return { status: 'connected' };
  } catch (err) {
    return { status: 'error', message: err.message };
  }
}

module.exports = { getPool, checkDbConnection };
