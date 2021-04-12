final String columnName = 'name';
final String columnPrice = 'price';
final String columnAmount = 'amount';
final String columncode = 'code';

class Product {
  String name;
  num price;
  num amount;
  int code;

  Map<String, Object> toMap() {
    var map = <String, Object>{
      columnName: name,
      columnPrice: price,
      columnAmount: amount,
      columncode: code
    };

    return map;
  }

  Product(this.name, this.price, this.amount, this.code);

  Product.fromMap(Map<String, Object> map) {
    name = map[columnName];
    price = map[columnPrice];
    amount = map[columnAmount];
    code = map[columncode];
  }
}
