from flask import Flask, request, jsonify
import logging
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__) 
COMMENTS_FILE = "comments.txt"
logging.basicConfig(level=logging.DEBUG)
metrics = PrometheusMetrics(app)

def save_comment(comment):
	with open(COMMENTS_FILE, "a") as file:
		file.write(f"{comment.get('email')}|{comment.get('comment')}|{comment.get('content_id')}\n")

def load_comments(content_id):
	comments = []

	with open(COMMENTS_FILE, "r") as file:
		for line in file:
			email, comment_text, cid = line.strip().split("|")
			if int(cid) == content_id:
				comments.append({"email": email, "comment": comment_text, "content_id": cid})

	if len(comments) > 0:
		return comments, 200
	return comments, 404

@app.route("/api/comment/new", methods=["POST"])
def new(): 
	logging.debug(request)
	data = request.get_json()
	logging.debug(data)

	if not data.get("email") or not data.get("comment") or not data.get("content_id"):
		return jsonify(data), 400
	
	save_comment(data)

	return jsonify(data), 201
	
@app.route("/api/comment/list/<int:content_id>", methods=["GET"]) 
def list(content_id): 
	comments, status = load_comments(content_id)
	return jsonify(comments), status

@app.route("/test", methods=["GET"])
def test():
    return "OK", 200


if __name__ == "__main__": 
	app.run(host='localhost', port=5000, debug=True) 