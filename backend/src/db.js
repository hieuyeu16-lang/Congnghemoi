import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const { Pool } = pg;
const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  console.warn('DATABASE_URL not set - running in demo mode without database');
}

// Mock pool for demo mode
const mockPool = {
  query: async () => ({ rows: [] }),
  on: () => {}
};

const pool = connectionString ? new Pool({ connectionString }) : mockPool;

pool.on('error', (err) => {
  console.error('Postgres idle client error', err);
});

export async function query(text, params) {
  return pool.query(text, params);
}

export async function testConnection() {
  const result = await query('SELECT 1 AS value');
  return result.rows[0];
}
