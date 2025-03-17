from flask import Flask, request, jsonify
import fitz  # PyMuPDF for PDF text extraction
import os
import requests
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)
UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# Load Gemini API keys from environment variables
GEMINI_API_KEYS = os.getenv("GEMINI_API_KEYS", "").split(",")
GEMINI_API_URL = os.getenv("GEMINI_API_URL", "https://api.gemini.com/v1/process")

# Root route for testing
@app.route("/", methods=["GET"])
def home():
    return "Flask server is running!", 200

def extract_text(pdf_path):
    """Extracts text from a PDF file."""
    doc = fitz.open(pdf_path)
    text = ""
    for page in doc:
        text += page.get_text("text") + "\n"
    return text.strip()

def call_gemini_api(text, doc_name):
    """Call the Gemini API with the extracted text and a predefined prompt."""
    headers = {
        "Authorization": "",  # Will be set dynamically
        "Content-Type": "application/json"
    }
    
    # Predefined prompt for legal document analysis
    prompt = (
        f"You are a legal assistant. Analyze the provided document {doc_name} and provide the following based on its content and size:\n\n"
        "1. Concise Summary: Provide a clear and brief summary of the document's content. If the document is lengthy, focus on the key points and purpose. If it is short, summarize it entirely.\n\n"
        "2. Legal Terms Explanation: Identify and explain all legal terms or jargon present in the document in simple, easy-to-understand language. If the document is large, prioritize the most critical terms.\n\n"
        "3. Potential Risks: Highlight any potential legal, financial, or operational risks that may arise from the document. Be specific and practical in your assessment, considering the scope and size of the document.\n\n"
        "4. Suggestions: Offer actionable suggestions to address or mitigate the identified risks. Avoid using legal jargon; keep the advice straightforward and relevant to the document's size and content.\n\n"
        "If the document is not a legal document or does not contain legal content, respond with:\n"
        "\"THIS IS NOT A LEGAL DOCUMENT, SO I CANNOT PROVIDE A RELEVANT REPLY.\""
    )
    
    data = {
        "text": text,
        "prompt": prompt
    }

    # Try each API key until one succeeds
    for api_key in GEMINI_API_KEYS:
        headers["Authorization"] = f"Bearer {api_key}"
        response = requests.post(GEMINI_API_URL, headers=headers, json=data)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"API key failed: {api_key}. Error: {response.status_code} - {response.text}")

    # If all keys fail, raise an exception
    raise Exception("All Gemini API keys failed. Please check your keys or credits.")

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
        # Call Gemini API with the extracted text
        gemini_response = call_gemini_api(text, file.filename)
        
        # Clean up the uploaded file
        os.remove(file_path)
        
        # Return the Gemini API response
        return jsonify(gemini_response), 200

    except Exception as e:
        # Clean up the uploaded file in case of error
        if os.path.exists(file_path):
            os.remove(file_path)
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    app.run(debug=True, port=port)