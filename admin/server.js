const express = require("express");
const path = require("path");
const port = process.env.ADMIN_PORT || 3000;

const app = express();
app.use(express.json());

app.get("/api/server/status", (req, res) => {
  res.json({
    status: "online",
  });
});

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "frontend", "index.html"));
});
app.use(express.static("frontend"));

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
