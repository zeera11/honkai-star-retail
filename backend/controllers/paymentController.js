const db = require("../config/db");

const createPayment = (req, res) => {
    const { orderId, paymentMethod } = req.body;
    let transactionCode = "";
    if (paymentMethod === "QRIS") {
        transactionCode =
            "QR-" + Math.floor(Math.random() * 1000000);
    } else {
        transactionCode =
            "VA-" + Math.floor(Math.random() * 1000000);
    }
    const sql = `
        INSERT INTO payments
        (order_id, payment_method, payment_status, transaction_code)
        VALUES (?, ?, ?, ?)
    `;
    db.query(
        sql,
        [orderId, paymentMethod, "pending", transactionCode],
        (err, result) => {

            if (err) {
                return res.status(500).json(err);
            }

            res.json({
                message: "Payment created",
                paymentMethod,
                transactionCode
            });
        }
    );
};

const confirmPayment = (req, res) => {

    const orderId = req.params.orderId;

    // update payment
    const paymentSql = `
        UPDATE payments
        SET payment_status = 'paid'
        WHERE order_id = ?
    `;

    db.query(paymentSql, [orderId], (err, result) => {

        if (err) {
            return res.status(500).json(err);
        }

        // update order
        const orderSql = `
            UPDATE orders
            SET status = 'paid'
            WHERE id = ?
        `;

        db.query(orderSql, [orderId], (err, result) => {

            if (err) {
                return res.status(500).json(err);
            }

            res.json({
                message: "Payment success"
            });
        });
    });
};

module.exports = {
    createPayment,
    confirmPayment
};