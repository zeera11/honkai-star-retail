class CurrencyFormatter {
  static String format(int price) {
    return 'Rp ${price ~/ 1000}K';
  }
}
