const mysql = require("mysql2");
const bcrypt = require("bcrypt");

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "Kkeeiirraa#06",
  database: "ecommerce"
});

db.connect(async err => {
  if (err) throw err;
  console.log("Database connected!");

  try {
    const hashedPassword = await bcrypt.hash("admin123", 10);
    const checkSql = "SELECT * FROM users WHERE email = ?";
    db.query(checkSql, ["admin@honkai.com"], (err, results) => {
      if (err) {
        console.error("Error checking admin user:", err);
        return;
      }
      if (results.length === 0) {
        const insertSql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
        db.query(insertSql, ["Admin", "admin@honkai.com", hashedPassword, "admin"], (err, res) => {
          if (err) console.error("Error creating admin user:", err);
          else console.log("Admin user admin@honkai.com created successfully.");
        });
      } else {
        const updateSql = "UPDATE users SET password = ?, role = 'admin' WHERE email = ?";
        db.query(updateSql, [hashedPassword, "admin@honkai.com"], (err, res) => {
          if (err) console.error("Error updating admin password:", err);
          else console.log("Admin user admin@honkai.com password updated/verified.");
        });
      }
    });
  } catch (hashErr) {
    console.error("Error hashing admin password:", hashErr);
  }
});

module.exports = db;