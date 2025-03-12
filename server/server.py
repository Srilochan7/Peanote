from flask import Flask, request, jsonify
import fitz  # PyMuPDF for PDF text extraction
from dotenv import load_dotenv
import os
import requests

load_dotenv()

app = Flask(__name__)
UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# List of Gemini API keys for each prompt (replace with your actual keys)




GEMINI_API_URL = "https://api.gemini.com/v1/process"  # Example URL

def extract_text(pdf_path):
    """Extracts text from a PDF file."""
    doc = fitz.open(pdf_path)
    text = ""
    for page in doc:
        text += page.get_text("text") + "\n"
    return text.strip()

def call_gemini_api(text, prompt, api_keys):
    """Call the Gemini API with the extracted text, a prompt, and a list of API keys."""
    headers = {
        "Authorization": "",  # Will be set dynamically
        "Content-Type": "application/json"
    }
    data = {
        "text": text,
        "prompt": prompt
    }

    # Try each API key until one succeeds
    for api_key in api_keys:
        headers["Authorization"] = f"Bearer {api_key}"
        response = requests.post(GEMINI_API_URL, headers=headers, json=data)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"API key failed: {api_key}. Error: {response.status_code} - {response.text}")

    # If all keys fail, raise an exception
    raise Exception("All Gemini API keys failed for this prompt. Please check your keys or credits.")

@app.route("/upload", methods=["POST"])
def upload_file():
    if "file" not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files["file"]
    if file.filename == "":
        return jsonify({"error": "No selected file"}), 400

    file_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(file_path)

    text = extract_text(file_path)

    try:
        # Step 1: Call Gemini API for summarization
        summary_prompt = "Summarize this legal document in simple terms."
        summary_response = call_gemini_api(text, summary_prompt, GEMINI_API_KEYS_SUMMARY)

        # Step 2: Call Gemini API for legal term explanation
        terms_prompt = "Explain the legal terms present in this document."
        terms_response = call_gemini_api(text, terms_prompt, GEMINI_API_KEYS_TERMS)

        # Step 3: Call Gemini API for risk and clause rating
        risk_prompt = "Identify risks and rate the clauses in this document."
        risk_response = call_gemini_api(text, risk_prompt, GEMINI_API_KEYS_RISK)

        # Step 4: Call Gemini API for suggestions
        suggestion_prompt = "Provide suggestions for improving this legal document."
        suggestion_response = call_gemini_api(text, suggestion_prompt, GEMINI_API_KEYS_SUGGESTIONS)

        # Return the results
        return jsonify({
            "summary": summary_response.get("result", ""),
            "terms_explanation": terms_response.get("result", ""),
            "risk_and_clause_rating": risk_response.get("result", ""),
            "suggestions": suggestion_response.get("result", "")
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, port=5000)