const db = require("../config/db");

const getAllItems = (callback) => {
  db.query("SELECT * FROM items", callback);
};

const getItemById = (id, callback) => {
  db.query("SELECT * FROM items WHERE id = ?", [id], callback);
};

const createItem = (data, callback) => {
  const { name, type, description, stock, price, image } = data;
  db.query(
    "INSERT INTO items (name, type, description, stock, price, image) VALUES (?, ?, ?, ?, ?, ?)",
    [name, type, description, stock, price, image],
    callback
  );
};

const updateItem = (id, data, callback) => {
  const { name, type, description, stock, price, image } = data;
  db.query(
    "UPDATE items SET name=?, type=?, description=?, stock=?, price=?, image=? WHERE id=?",
    [name, type, description, stock, price, image, id],
    callback
  );
};

const deleteItem = (id, callback) => {
  db.query("DELETE FROM items WHERE id = ?", [id], callback);
};

module.exports = {
  getAllItems,
  getItemById,
  createItem,
  updateItem,
  deleteItem
};