const path = require('path');
const express = require('express');
const { checkDbConnection } = require('./db');

function createApp() {
  const app = express();
  app.use(express.json());

  // Visual landing page at "/" - reads live status from /health and
  // /api/info via fetch(), so it's a real demo of the running service
  // rather than a static screenshot. JSON endpoints stay separate so the
  // deploy pipeline's health check and any API consumers are unaffected.
  app.use(express.static(path.join(__dirname, '..', 'public')));

  app.get('/api/info', (req, res) => {
    res.status(200).json({
      message: 'DevOps CI/CD demo app',
      version: process.env.APP_VERSION || 'dev',
    });
  });

  // Deployment/orchestration systems (readiness probes, load balancer
  // health checks, our own deploy script) hit this to confirm the new
  // container actually came up and can reach the database.
  app.get('/health', async (req, res) => {
    const db = await checkDbConnection();
    const healthy = db.status !== 'error';
    res.status(healthy ? 200 : 503).json({
      status: healthy ? 'ok' : 'degraded',
      db,
      uptime_seconds: process.uptime(),
    });
  });

  app.get('/api/tasks', (req, res) => {
    // Placeholder "business logic" endpoint so the pipeline has more than
    // one route to lint/test/build — stand-in for real app functionality.
    res.status(200).json({ tasks: ['set up CI', 'set up CD', 'provision infra'] });
  });

  app.use((req, res) => {
    res.status(404).json({ error: 'not_found' });
  });

  return app;
}

module.exports = createApp;
