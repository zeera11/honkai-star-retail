const express = require("express");
const router = express.Router();

const itemController = require("../controllers/itemController");
const verifyToken = require("../middleware/authMiddleware");
const checkAdmin = require("../middleware/adminMiddleware");
const upload = require("../utils/upload");

//GET ITEMS
router.get("/", itemController.getItems);
router.get("/:id", itemController.getItem);


//CREATE ITEM (WITH IMAGE)
router.post(
  "/",
  verifyToken,
  checkAdmin,
  upload.single("image"),
  itemController.createItem
);


//UPDATE ITEM
router.put(
  "/:id",
  verifyToken,
  checkAdmin,
  itemController.updateItem
);


//DELETE ITEM
router.delete(
  "/:id",
  verifyToken,
  checkAdmin,
  itemController.deleteItem
);


//BUY ITEM
router.post("/buy/:id", verifyToken, itemController.buyItem);


//UPLOAD IMAGE ONLY
router.post(
  "/upload",
  verifyToken,
  checkAdmin,
  upload.single("image"),
  itemController.uploadItemImage
);

module.exports = router;