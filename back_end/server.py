import re
import json
import requests
from bs4 import BeautifulSoup
from operator import itemgetter
from flask import Flask, render_template, jsonify, request 
app = Flask(__name__)
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0

@app.route("/post_score", methods=['POST'])
def post_score():
    with open("score.json", "r+") as file:
        add_data = request.get_json(force=True)
        data = json.load(file)
        data.append(add_data)
        data = sorted(data, key=itemgetter('score', 'time'))
        file.seek(0)
        file.truncate()
        json.dump(data, file)
        return "success"

    

@app.route("/get_score", methods=['GET'])
def get_score():
    name = request.args.get("name")
    score = request.args.get("score", type=int)
    time = request.args.get("time")
    cost_time = request.args.get("costTime")
    tar = {
        "name": name,
        "score": score,
        "time": time,
        "costTime": cost_time 
    }
    with open("score.json", "r+") as file:
        data = json.load(file)
        cur = -1
        for idx, dic in enumerate(data):
            print(dic)
            if dic == tar:
                cur = idx
                break
        result = data[0:]
        result.append({
            "name": "query",
            "score": cur,
            "time": "query",
            "costTime": "query"
        })
        return jsonify(result)

if __name__ == "__main__":
    app.run('0.0.0.0', 6771, debug=True)
