const userModel = require("../models/userModels");
console.log("USER CONTROLLER LOADED");

const getUsers = (req, res) => {
  console.log("GET USERS KEPAKE");

  userModel.getAllUsers((err, results) => {
    if (err) {
      console.log("ERROR DB:", err);
      return res.status(500).json({ error: err });
    }
    res.json(results);
  });
};

module.exports = {
  getUsers
};