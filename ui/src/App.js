import React, { useEffect, useState } from "react";

function safeJoin(base, path) {
  if (!base) return path;
  return base.replace(/\/+$/, "") + "/" + path.replace(/^\/+/, "");
}

function App() {
  const baseUrl = process.env.REACT_APP_API_BASE_URL || "";
  const [a, setA] = useState(null);
  const [b, setB] = useState(null);
  const [err, setErr] = useState("");

  useEffect(() => {
    async function run() {
      setErr("");
      try {
        const ra = await fetch(safeJoin(baseUrl, "/api-a/db-test"));
        const ja = await ra.json();
        setA(ja);
      } catch (e) {
        setErr((p) => p + `API A failed: ${e.message}\n`);
      }

      try {
        const rb = await fetch(safeJoin(baseUrl, "/api-b/scores"));
        const jb = await rb.json();
        setB(jb);
      } catch (e) {
        setErr((p) => p + `API B failed: ${e.message}\n`);
      }
    }

    if (baseUrl) run();
  }, [baseUrl]);

  return (
    <div style={{ fontFamily: "Arial", padding: 24 }}>
      <h1>Gopal’s Capstone UI (App Service)</h1>

      <p>
        <strong>APIM Base URL:</strong>{" "}
        {baseUrl ? <code>{baseUrl}</code> : <span style={{ color: "crimson" }}>NOT SET</span>}
      </p>

      {err ? (
        <pre style={{ background: "#fff3f3", padding: 12, borderRadius: 8 }}>{err}</pre>
      ) : null}

      <div style={{ display: "grid", gap: 16, gridTemplateColumns: "1fr 1fr" }}>
        <div style={{ border: "1px solid #ddd", borderRadius: 10, padding: 16 }}>
          <h3>Backend A (API A)</h3>
          <p>Calls: <code>/api-a/db-test</code></p>
          <pre style={{ background: "#f6f6f6", padding: 12, borderRadius: 8 }}>
            {a ? JSON.stringify(a, null, 2) : "Loading..."}
          </pre>
        </div>

        <div style={{ border: "1px solid #ddd", borderRadius: 10, padding: 16 }}>
          <h3>Backend B (API B)</h3>
          <p>Calls: <code>/api-b/scores</code></p>
          <pre style={{ background: "#f6f6f6", padding: 12, borderRadius: 8 }}>
            {b ? JSON.stringify(b, null, 2) : "Loading..."}
          </pre>
        </div>
      </div>
    </div>
  );
}

export default App;
