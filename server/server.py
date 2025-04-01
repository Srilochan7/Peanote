from flask import Flask, request, jsonify
import fitz  # PyMuPDF for PDF text extraction
import os
import requests
from dotenv import load_dotenv
import json

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)
UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# Add CORS support
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    return response

# Load Gemini API keys from environment variables
GEMINI_API_KEYS = os.getenv("GEMINI_API_KEYS", "").split(",")
# Updated API URL with the correct model and proper format
GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent"

# Root route for testing
@app.route("/", methods=["GET"])
def home():
    return "Flask server is running!", 200

def list_available_models(api_key):
    """List available models to find the correct one."""
    url = f"https://generativelanguage.googleapis.com/v1/models?key={api_key}"
    headers = {"Content-Type": "application/json"}
    
    try:
        response = requests.get(url, headers=headers)
        print(f"Models response status: {response.status_code}")
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Error listing models: {response.text}")
            return None
    except Exception as e:
        print(f"Exception listing models: {str(e)}")
        return None

def extract_text(pdf_path):
    """Extracts text from a PDF file."""
    doc = fitz.open(pdf_path)
    text = ""
    for page in doc:
        text += page.get_text("text") + "\n"
    return text.strip()

def call_gemini_api(text):
    """Call the Gemini API with extracted text and a predefined prompt."""
    
    # Predefined prompt for legal document analysis
    prompt = (
    "Analyze the given content and provide structured outputs:\n\n"

    "1. **Separate Summaries** for each distinct question or point:\n"
    "- Write one paragraph per question (5-10 sentences, max 100 words).\n"
    "- Begin each summary with:\n"
    "  - **Summary #1:**\n"
    "  - **Summary #2:**\n"
    "- Leave a **blank line** between each summary for clarity.\n"
    "- If a question is unclear, state: **'Unclear Question #X'**.\n\n"

    "2. **Key Terms & Definitions**:\n"
    "- List key terms with simple one-sentence definitions.\n"
    "- Format each term like this:\n"
    "  - **Term:** Definition.\n"
    "- Leave a **blank line** between each definition.\n\n"

    "**Rules:**\n"
    "- **Do not combine multiple questions into one summary.**\n"
    "- **No introductions or conclusions.**\n"
    "- **Ensure there is always a blank line between summaries and definitions.**"
)






    # API request body (Correct Format)
    data = {
        "contents": [
            {
                "parts": [{"text": f"{prompt}\n\n{text}"}]
            }
        ]
    }

    for i, api_key in enumerate(GEMINI_API_KEYS):
        if not api_key.strip():
            continue  # Skip empty API keys
            
        # Correctly format the URL with the API key as a parameter
        url = f"{GEMINI_API_URL}?key={api_key}"
        headers = {"Content-Type": "application/json"}

        print(f"🔹 Testing API key {i+1} of {len(GEMINI_API_KEYS)}")
        
        try:
            response = requests.post(url, headers=headers, json=data)
            print(f"🔹 Response Status: {response.status_code}")
            
            # Print full error message for debugging
            if response.status_code != 200:
                print(f"🔸 Full error response: {response.text}")
            else:
                # Print limited response text to avoid flooding logs
                resp_preview = response.text[:200] + "..." if len(response.text) > 200 else response.text
                print(f"🔹 Response Preview: {resp_preview}")
            
            if response.status_code == 200:
                return response.json()
            elif response.status_code == 400:
                print(f"🔸 API Error: Bad Request - Check payload format")
            elif response.status_code == 401:
                print(f"🔸 API Error: Unauthorized - API key may be invalid or expired")
            elif response.status_code == 403:
                print(f"🔸 API Error: Forbidden - API key may not have required permissions")
            elif response.status_code == 404:
                print(f"🔸 API Error: Not Found - Model or endpoint may not exist")
            elif response.status_code == 429:
                print(f"🔸 API Error: Rate Limit Exceeded - Quota may be exhausted")
            else:
                print(f"🔸 API Error: Unexpected status code {response.status_code}")
                
        except Exception as e:
            print(f"🔸 Request Error: {str(e)}")
    
    return {"error": "All Gemini API keys failed. Check your API status and quota."}

@app.route("/upload", methods=["POST"])
def upload_file():
    if "file" not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files["file"]
    if file.filename == "":
        return jsonify({"error": "No selected file"}), 400
    
    # Check file type
    allowed_extensions = ['.pdf', '.txt', '.doc', '.docx']
    file_ext = os.path.splitext(file.filename)[1].lower()
    if file_ext not in allowed_extensions:
        return jsonify({"error": f"Unsupported file type. Please upload {', '.join(allowed_extensions)} files"}), 400

    file_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(file_path)

    try:
        text = extract_text(file_path)
        print(f"📄 Successfully extracted text from {file.filename} ({len(text)} characters)")
        
        # Call Gemini API with the extracted text
        gemini_response = call_gemini_api(text)
        
        # Clean up the uploaded file
        os.remove(file_path)
        
        # If there's an error in the response
        if "error" in gemini_response:
            print(f"❌ Error from Gemini API: {gemini_response['error']}")
            # Create a simplified error response for the client
            return jsonify({
                "candidates": [{
                    "content": {
                        "parts": [{
                            "text": f"Error processing document: {gemini_response['error']}"
                        }]
                    }
                }]
            }), 200
        
        # Return the Gemini API response
        print("✅ Successfully generated response from Gemini API")
        return jsonify(gemini_response), 200

    except Exception as e:
        # Clean up the uploaded file in case of error
        if os.path.exists(file_path):
            os.remove(file_path)
        print(f"❌ Error processing file: {str(e)}")
        # Create a simplified error response for the client
        return jsonify({
            "candidates": [{
                "content": {
                    "parts": [{
                        "text": f"Error processing document: {str(e)}"
                    }]
                }
            }]
        }), 200


# Check available models at startup
if __name__ == "__main__":
    # List available models if at least one API key is available
    if GEMINI_API_KEYS and GEMINI_API_KEYS[0].strip():
        print("🔍 Checking available Gemini models...")
        models_info = list_available_models(GEMINI_API_KEYS[0])
        if models_info:
            print("✅ Available models:")
            for model in models_info.get("models", []):
                print(f"- {model.get('name')}: {model.get('supportedGenerationMethods', [])}")
        else:
            print("❌ Could not retrieve model information. Check your API key.")
    else:
        print("⚠️ No API keys found. Please check your .env file.")
    
    port = int(os.getenv("PORT", 5000))
    print(f"🚀 Starting Flask server on port {port}")
    app.run(debug=True, host="0.0.0.0", port=port)