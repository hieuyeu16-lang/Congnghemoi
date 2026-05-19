import express from 'express';
import cors from 'cors';
import healthRouter from './routes/health.js';
import tasksRouter from './routes/tasks.js';
import bookingsRouter from './routes/bookings.js';

const app = express();
// Allow common dev frontend origins so the browser can call the API when
// frontend is served from different dev servers or containers.
const allowedOrigins = [
  'http://localhost:5173',
  'http://127.0.0.1:5173',
  'http://localhost:3000',
  'http://127.0.0.1:3000',
  'http://host.docker.internal:3000'
];
app.use(cors({ origin: allowedOrigins }));
app.use(express.json());
app.use('/api/health', healthRouter);
app.use('/api/tasks', tasksRouter);
app.use('/api/bookings', bookingsRouter);

app.get('/api/test', async (req, res) => {
  try {
    const mockResponse = { now: new Date().toISOString(), demo: true };
    res.json(mockResponse);
  } catch (error) {
    console.error('API /api/test failed', error);
    res.status(500).json({ message: 'Demo mode: database not available' });
  }
});

app.use((err, req, res, next) => {
  console.error('Unhandled error', err);
  res.status(500).json({ error: 'Internal server error' });
});

export default app;
