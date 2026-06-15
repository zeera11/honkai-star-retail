const express = require("express");
const router = express.Router();

const paymentController = require("../controllers/paymentController");

const verifyToken = require("../middleware/authMiddleware");

router.post(
    "/create",
    verifyToken,
    paymentController.createPayment
);

router.post(
    "/confirm/:orderId",
    verifyToken,
    paymentController.confirmPayment
);

module.exports = router;