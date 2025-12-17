const express = require("express");
const { Pool } = require("pg");

const app = express();
const port = 80;

const pool = new Pool({
  user: process.env.DB_USER || "gopaladmin",
  host: process.env.DB_HOST,
  database: process.env.DB_NAME || "appdb",
  password: process.env.DB_PASSWORD,
  port: 5432,
  ssl: { rejectUnauthorized: false }
});

app.get("/health", (_req, res) => res.json({ service: "api-a", status: "ok" }));

app.get("/", (_req, res) => {
  res.send("Hello from Backend A (Node.js) running on AKS + PostgreSQL!");
});

app.get("/db-test", async (_req, res) => {
  try {
    const r = await pool.query("SELECT NOW()");
    res.json({ service: "api-a", message: "Database Connected!", time: r.rows[0].now });
  } catch (err) {
    res.status(500).json({ service: "api-a", error: err.message });
  }
});

app.listen(port, () => console.log(`api-a listening on port ${port}`));
