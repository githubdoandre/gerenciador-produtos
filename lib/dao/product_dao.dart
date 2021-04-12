import 'package:produtosapp/database/database.dart';
import 'package:produtosapp/model/product.dart';

class ProductDao {
  final dbProvider = DatabaseProvider.dbProvider;
  static const PRODUCT_TABLE = "product";

  Future<void> create({
    int code,
    num amount,
    num price,
    String name,
  }) async {
    final db = await dbProvider.database;

    Map<String, dynamic> params = Map<String, dynamic>();
    params['code'] = code;
    params['amount'] = amount;
    params['price'] = price;
    params['name'] = name;

    db.insert(PRODUCT_TABLE, params);
  }

  Future<void> update(Product product) async {
    final db = await dbProvider.database;

    return await db.update(PRODUCT_TABLE, product.toMap(),
        where: 'code = ?', whereArgs: [product.code]);
  }

  Future<void> remove(int code) async {
    final db = await dbProvider.database;
    await db.delete(PRODUCT_TABLE, where: 'code = ?', whereArgs: [code]);
  }

  Future<List<Product>> getList(String orderBy, int page) async {
    final db = await dbProvider.database;

    List<Map> result = await db.query(PRODUCT_TABLE,
        orderBy: orderBy, limit: 10, offset: (page - 1) * 10);

    List<Product> list = result.map((e) => Product.fromMap(e)).toList();

    return list;
  }

  Future<int> getCount() async {
    final db = await dbProvider.database;
    List<Map> result = await db.query(
      PRODUCT_TABLE,
    );
    return result.length;
  }
}
