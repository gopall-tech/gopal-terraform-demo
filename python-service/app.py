from flask import Flask, jsonify
import random

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "service": "NFL Score Ticker (Backend B)",
        "status": "Live",
        "season": "2025-2026"
    })

@app.route('/scores')
def get_scores():
    # Mock data - In a real app, this would scrape ESPN or use an API
    return jsonify({
        "week": 15,
        "games": [
            {"matchup": "Chiefs vs Bills", "score": "24-21", "status": "Final", "winner": "Chiefs"},
            {"matchup": "Eagles vs Cowboys", "score": "14-10", "status": "Q3 - 12:45", "possession": "Eagles"},
            {"matchup": "49ers vs Rams", "score": "0-0", "status": "Kickoff 4:25 PM ET"},
            {"matchup": "Packers vs Bears", "score": "28-14", "status": "Final", "winner": "Packers"}
        ]
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)