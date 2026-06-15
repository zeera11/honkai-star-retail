const db = require("../config/db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const register = async (req, res) => {
  const { name, email, password, role } = req.body;

  const hashedPassword = await bcrypt.hash(password, 10);

  const sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";

  db.query(sql, [name, email, hashedPassword, role], (err, result) => {
    if (err) return res.status(500).json(err);

    res.json({ message: "User registered" });
  });
};

const login = (req, res) => {
  const { email, password } = req.body;

  // Support login using either email or username (name)
  const sql = "SELECT * FROM users WHERE email = ? OR name = ?";

  db.query(sql, [email, email], async (err, results) => {
    if (err) return res.status(500).json(err);

    if (results.length === 0) {
      return res.status(400).json({ message: "User not found" });
    }

    const user = results[0];

    const match = await bcrypt.compare(password, user.password);

    if (!match) {
      return res.status(400).json({ message: "Wrong password" });
    }

    const token = jwt.sign(
      { id: user.id, role: user.role },
      "secretkey",
      { expiresIn: "1h" }
    );

    // Return message, token, and user details
    res.json({
      message: "Login success",
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role
      }
    });
  });
};

const googleLogin = (req, res) => {
  const { email, name } = req.body;
  const sqlSelect = "SELECT * FROM users WHERE email = ?";

  db.query(sqlSelect, [email], async (err, results) => {
    if (err) return res.status(500).json(err);

    if (results.length === 0) {
      // User doesn't exist, create a new one with a random password
      const randomPassword = Math.random().toString(36).substring(2, 15);
      const hashedPassword = await bcrypt.hash(randomPassword, 10);
      const sqlInsert = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'user')";

      db.query(sqlInsert, [name, email, hashedPassword], (err, result) => {
        if (err) return res.status(500).json(err);

        // Fetch the newly created user
        db.query(sqlSelect, [email], (err, newResults) => {
          if (err) return res.status(500).json(err);
          const user = newResults[0];
          const token = jwt.sign(
            { id: user.id, role: user.role },
            "secretkey",
            { expiresIn: "1h" }
          );
          res.json({
            message: "Login success",
            token,
            user: {
              id: user.id,
              name: user.name,
              email: user.email,
              role: user.role
            }
          });
        });
      });
    } else {
      // User exists, log them in
      const user = results[0];
      const token = jwt.sign(
        { id: user.id, role: user.role },
        "secretkey",
        { expiresIn: "1h" }
      );
      res.json({
        message: "Login success",
        token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role
        }
      });
    }
  });
};

module.exports = { register, login, googleLogin };