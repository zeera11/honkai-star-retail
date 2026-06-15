const Cart = require("../models/cartModel");

exports.getCart = (req, res) => {
  const userId = req.user.id;

  Cart.getCartByUser(userId, (err, cart) => {
    if (err) return res.status(500).json(err);

    if (cart.length === 0) {
      return res.json({ message: "Cart empty", items: [] });
    }

    const cartId = cart[0].id;

    Cart.getItems(cartId, (err, items) => {
      if (err) return res.status(500).json(err);

      res.json({ cartId, items });
    });
  });
};

exports.addToCart = (req, res) => {
  const userId = req.user.id;
  const { item_id, quantity } = req.body;

  Cart.getCartByUser(userId, (err, cart) => {
    if (err) return res.status(500).json(err);

    let cartId;

    if (cart.length === 0) {
      Cart.createCart(userId, (err, result) => {
        if (err) return res.status(500).json(err);

        cartId = result.insertId;

        Cart.addItem(cartId, item_id, quantity, (err) => {
          if (err) return res.status(500).json(err);

          res.json({ message: "Item added to cart" });
        });
      });
    } else {
      cartId = cart[0].id;

      Cart.addItem(cartId, item_id, quantity, (err) => {
        if (err) return res.status(500).json(err);

        res.json({ message: "Item added to cart" });
      });
    }
  });
};

exports.removeFromCart = (req, res) => {
  const { id } = req.params;

  Cart.removeItem(id, (err) => {
    if (err) return res.status(500).json(err);

    res.json({ message: "Item removed from cart" });
  });
};