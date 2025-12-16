const express = require('express');
const { Client } = require('pg');
const app = express();
const port = 80;

// Database Connection Config
// These variables will come from Kubernetes (defined in deployment.yaml)
const client = new Client({
  user: process.env.DB_USER || 'adminuser',
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: 5432,
  ssl: { rejectUnauthorized: false } // Required for Azure PostgreSQL Flexible Server
});

// Connect to DB
client.connect()
  .then(() => console.log('Connected to PostgreSQL successfully!'))
  .catch(err => console.error('Connection error', err.stack));

// Basic Route
app.get('/', (req, res) => {
  res.send('Hello from the Node.js API (Running on AKS + PostgreSQL)!');
});

// Test DB Route
app.get('/db-test', async (req, res) => {
  try {
    const result = await client.query('SELECT NOW()');
    res.json({ message: 'Database Connected!', time: result.rows[0].now });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});