import React from 'react';

function App() {
  return (
    <div style={{ textAlign: 'center', marginTop: '50px', fontFamily: 'Arial' }}>
      <h1>Gopal's Cloud Project</h1>
      <h2>Environment: {process.env.NODE_ENV}</h2>
      <p>Status: UI is running on AKS!</p>
      <div style={{ padding: '20px', backgroundColor: '#f0f0f0', display: 'inline-block', borderRadius: '8px' }}>
        <h3>System Status</h3>
        <ul style={{ listStyleType: 'none', padding: 0 }}>
          <li>✅ Infrastructure: Active</li>
          <li>✅ Database: Connected</li>
          <li>✅ UI: Deployed</li>
        </ul>
      </div>
    </div>
  );
}

export default App;