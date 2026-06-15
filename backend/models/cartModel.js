const db = require("../config/db");

const Cart = {
  createCart: (userId, callback) => {
    db.query(
      "INSERT INTO carts (user_id) VALUES (?)",
      [userId],
      callback
    );
  },

  getCartByUser: (userId, callback) => {
    db.query(
      "SELECT * FROM carts WHERE user_id = ?",
      [userId],
      callback
    );
  },

  addItem: (cartId, itemId, quantity, callback) => {
    db.query(
      "INSERT INTO cart_items (cart_id, item_id, quantity) VALUES (?, ?, ?)",
      [cartId, itemId, quantity],
      callback
    );
  },

  getItems: (cartId, callback) => {
    db.query(
      `SELECT ci.id, ci.quantity, i.name, i.price, i.image
       FROM cart_items ci
       JOIN items i ON ci.item_id = i.id
       WHERE ci.cart_id = ?`,
      [cartId],
      callback
    );
  },

  removeItem: (cartItemId, callback) => {
    db.query(
      "DELETE FROM cart_items WHERE id = ?",
      [cartItemId],
      callback
    );
  }
};

module.exports = Cart;