const express = require("express");
const router = express.Router();
const multer = require("multer");
const { analyzeReport } = require("../services/gemini");

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB limit
});

/**
 * POST /api/analyze
 * Body: multipart/form-data with optional 'file' and 'report' text
 * Returns: { "result": "<AI analysis paragraph>" }
 */
router.post("/analyze", upload.single("file"), async (req, res) => {
  try {
    const reportText = req.body.report || "";
    const file = req.file;

    // ── Validation ────────────────────────────────────────
    if (!file && (!reportText || reportText.trim().length === 0)) {
      return res.status(400).json({
        error: "Please provide a valid medical report text or upload a file.",
      });
    }

    if (reportText.length > 5000) {
      return res.status(400).json({
        error: "Report text is too long. Please limit to 5000 characters.",
      });
    }

    // ── Call Gemini AI ────────────────────────────────────
    const result = await analyzeReport(reportText.trim(), file);
    return res.json({ result });
  } catch (err) {
    console.error("Analysis error:", err);
    return res.status(500).json({
      error: err.message || "Failed to analyze the report. Please try again later.",
    });
  }
});

module.exports = router;
