from flask import Flask, request, jsonify
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

# Step 1: Initialize Flask app
app = Flask(__name__)

# Step 2: Load the Pegasus model and tokenizer
model_name = "facebook/bart-large-cnn"
print("Loading model and tokenizer...")
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSeq2SeqLM.from_pretrained(model_name)

# Step 3: Define the summarization function
def summarize_text(text, max_length=50, min_length=10, length_penalty=2.0, num_beams=4):
    """
    Summarizes the input text using the Pegasus model.

    Args:
        text (str): The input text to summarize.
        max_length (int): Maximum length of the summary.
        min_length (int): Minimum length of the summary.
        length_penalty (float): Penalty for the length of the summary.
        num_beams (int): Number of beams for beam search.

    Returns:
        str: The generated summary.
    """
    inputs = tokenizer(text, return_tensors="pt", max_length=512, truncation=True)
    summary_ids = model.generate(
        inputs["input_ids"],
        max_length=max_length,
        min_length=min_length,
        length_penalty=length_penalty,
        num_beams=num_beams,
        early_stopping=True,
    )
    return tokenizer.decode(summary_ids[0], skip_special_tokens=True)

# Step 4: Define the API endpoint
@app.route('/summarize', methods=['POST'])
def summarize():
    """
    API endpoint to summarize text.

    Request:
        JSON: { "text": "Your input text here" }

    Response:
        JSON: { "summary": "Summarized text here" }
    """
    # Get the input JSON
    data = request.get_json()
    print(data)

    # Extract text from JSON
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "No text provided"}), 400

    # Summarize the text
    try:
        summary = summarize_text(text)
        return jsonify({"summary": summary})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Step 5: Run the Flask app
if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True, port=5000)
