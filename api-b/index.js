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

app.get("/health", (_req, res) => res.json({ service: "api-b", status: "ok" }));

app.get("/", (_req, res) => {
  res.send("Hello from Backend B (Node.js) running on AKS!");
});

app.get("/db-test", async (_req, res) => {
  try {
    const r = await pool.query("SELECT NOW()");
    res.json({ service: "api-b", message: "Database Connected!", time: r.rows[0].now });
  } catch (err) {
    res.status(500).json({ service: "api-b", error: err.message });
  }
});

// Assignment-friendly endpoint
app.get("/scores", (_req, res) => {
  res.json({
    service: "api-b",
    week: 15,
    games: [
      { matchup: "Chiefs vs Bills", score: "24-21", status: "Final", winner: "Chiefs" },
      { matchup: "Eagles vs Cowboys", score: "14-10", status: "Q3 - 12:45", possession: "Eagles" },
      { matchup: "49ers vs Rams", score: "0-0", status: "Kickoff 4:25 PM ET" },
      { matchup: "Packers vs Bears", score: "28-14", status: "Final", winner: "Packers" }
    ]
  });
});

app.listen(port, () => console.log(`api-b listening on port ${port}`));
