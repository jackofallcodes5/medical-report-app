const { GoogleGenerativeAI } = require("@google/generative-ai");

// ── Initialize Gemini ────────────────────────────────────────
const apiKey = process.env.GEMINI_API_KEY;
if (!apiKey) {
  console.error("❌ GEMINI_API_KEY is not set in environment variables.");
  process.exit(1);
}

const genAI = new GoogleGenerativeAI(apiKey);
const model = genAI.getGenerativeModel({ model: "gemini-flash-latest" });

// ── System Prompt ────────────────────────────────────────────
const SYSTEM_PROMPT = `You are a helpful medical report assistant. A user will provide their medical report or lab results. You must respond with EXACTLY ONE paragraph of approximately 100 words. Your response must:

1. Explain the medical report in simple, everyday English that anyone can understand.
2. Identify the possible deficiency, condition, or health issue indicated by the report.
3. Suggest possible remedies or lifestyle changes that may help.
4. Clearly mention whether the issue can likely be managed at home with diet/lifestyle changes or if it needs professional medical attention.
5. Use simple language — avoid heavy medical jargon.
6. End with a brief safety disclaimer stating: "Note: This is for informational purposes only and is not a medical diagnosis. Please consult a qualified healthcare professional for proper evaluation."

Do NOT use bullet points, headings, or lists. Write everything as a single flowing paragraph.`;

/**
 * Sends the medical report to Gemini and returns the AI analysis.
 * @param {string} reportText - The medical report text from the user.
 * @param {Object} file - Optional uploaded file from multer.
 * @returns {Promise<string>} The AI-generated analysis paragraph.
 */
async function analyzeReport(reportText, file) {
  const parts = [
    { text: `${SYSTEM_PROMPT}\n\nHere is the medical report text (if any):\n\n${reportText || "None provided."}` }
  ];

  if (file) {
    let mimeType = file.mimetype;
    // Flutter's http package defaults to application/octet-stream if not specified
    if (mimeType === "application/octet-stream" && file.originalname) {
      const ext = file.originalname.split(".").pop().toLowerCase();
      if (ext === "pdf") mimeType = "application/pdf";
      else if (ext === "png") mimeType = "image/png";
      else if (ext === "jpg" || ext === "jpeg") mimeType = "image/jpeg";
    }

    parts.push({
      inlineData: {
        data: file.buffer.toString("base64"),
        mimeType: mimeType
      }
    });
  }

  const result = await model.generateContent(parts);
  const response = result.response;
  const text = response.text();

  if (!text || text.trim().length === 0) {
    throw new Error("Gemini returned an empty response.");
  }

  return text.trim();
}

module.exports = { analyzeReport };
