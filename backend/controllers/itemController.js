const itemModel = require("../models/itemModel");
const db = require("../config/db");


//GET ALL ITEMS
const getItems = (req, res) => {
  itemModel.getAllItems((err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
};


//GET ITEM BY ID
const getItem = (req, res) => {
  const id = req.params.id;

  itemModel.getItemById(id, (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results[0]);
  });
};


//CREATE ITEM (WITH IMAGE)
const createItem = (req, res) => {
  const { name, type, description, stock, price } = req.body;

  const image = req.file
    ? `uploads/${req.file.filename}`
    : null;

  const query = `
    INSERT INTO items (name, type, description, stock, price, image)
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  db.query(
    query,
    [name, type, description, stock, price, image],
    (err, result) => {
      if (err) return res.status(500).json(err);

      res.json({
        message: "Item created",
        id: result.insertId,
        image,
      });
    }
  );
};


//UPDATE ITEM
const updateItem = (req, res) => {
  const id = req.params.id;

  itemModel.updateItem(id, req.body, (err) => {
    if (err) return res.status(500).json(err);
    res.json({ message: "Item updated" });
  });
};


//DELETE ITEM
const deleteItem = (req, res) => {
  const id = req.params.id;

  itemModel.deleteItem(id, (err) => {
    if (err) return res.status(500).json(err);
    res.json({ message: "Item deleted" });
  });
};


//BUY ITEM
const buyItem = (req, res) => {
  const userId = req.user.id;
  const itemId = req.params.id;
  const quantity = req.body.quantity;

  const getItemSql = "SELECT * FROM items WHERE id = ?";

  db.query(getItemSql, [itemId], (err, results) => {
    if (err) return res.status(500).json(err);

    const item = results[0];

    if (!item) {
      return res.status(404).json({ message: "Item not found" });
    }

    const totalPrice = item.price * quantity;

    const orderSql = `
      INSERT INTO orders
      (user_id, item_id, quantity, total_price, status)
      VALUES (?, ?, ?, ?, ?)
    `;

    db.query(
      orderSql,
      [userId, itemId, quantity, totalPrice, "pending"],
      (err, result) => {
        if (err) return res.status(500).json(err);

        res.json({
          message: "Order created",
          orderId: result.insertId,
          totalPrice,
        });
      }
    );
  });
};


//UPLOAD IMAGE ONLY
const uploadItemImage = (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: "No file uploaded" });
  }

  const imagePath = `uploads/${req.file.filename}`;

  res.json({
    message: "Image uploaded successfully",
    image: imagePath,
  });
};


//EXPORTS
module.exports = {
  getItems,
  getItem,
  createItem,
  updateItem,
  deleteItem,
  buyItem,
  uploadItemImage,
};