import express from 'express';
import { testConnection } from '../db.js';

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const dbStatus = await testConnection();
    res.json({
      status: 'ok',
      timestamp: new Date().toISOString(),
      db: dbStatus?.value === 1 ? 'connected' : 'unknown'
    });
  } catch (error) {
    console.error('Health check failed', error);
    res.status(500).json({ status: 'error', message: 'Database unavailable' });
  }
});

export default router;
