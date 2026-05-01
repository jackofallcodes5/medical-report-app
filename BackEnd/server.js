const express = require("express");
const cors = require("cors");
require("dotenv").config();

const analyzeRoute = require("./routes/analyze");

const app = express();
const PORT = process.env.PORT || 3000;

// ── Middleware ───────────────────────────────────────────────
app.use(cors());
app.use(express.json({ limit: "1mb" }));

// ── Routes ──────────────────────────────────────────────────
app.use("/api", analyzeRoute);

// Health check
app.get("/", (_req, res) => {
  res.json({ status: "ok", message: "Medical Report Analysis API is running." });
});

// ── Global Error Handler ────────────────────────────────────
app.use((err, _req, res, _next) => {
  console.error("Unhandled error:", err.message);
  res.status(500).json({ error: "Internal server error. Please try again later." });
});

// ── Start Server ────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`✅ Server running on http://localhost:${PORT}`);
});
