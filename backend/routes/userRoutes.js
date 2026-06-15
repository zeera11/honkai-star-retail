const express = require("express");
const router = express.Router();

const userController = require("../controllers/userController");

console.log("USER CONTROLLER:", userController);

router.get("/", userController.getUsers);

module.exports = router;