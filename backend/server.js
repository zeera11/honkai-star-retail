const express = require("express");
const cors = require("cors");
const app = express();

// CONFIG & DATABASE
require("./config/db");

// MIDDLEWARE
app.use(cors());
app.use(express.json());
app.use("/uploads", express.static("uploads"));

// ROUTES IMPORT
const authRoutes = require("./routes/authRoutes");
const userRoutes = require("./routes/userRoutes");
const itemRoutes = require("./routes/itemRoutes");
const cartRoutes = require("./routes/cartRoutes");
const paymentRoutes = require("./routes/paymentRoutes");

// ROUTES USAGE
app.use("/auth", authRoutes);
app.use("/users", userRoutes);
app.use("/items", itemRoutes);
app.use("/cart", cartRoutes);
app.use("/payments", paymentRoutes);

// BASE ROUTE
app.get("/", (req, res) => {
  res.send("Backend jalan 🚀");
});

// START SERVER
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});