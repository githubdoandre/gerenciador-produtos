import 'package:produtosapp/dao/product_dao.dart';
import 'package:produtosapp/model/product.dart';

class ProductRepository {
  final productDao = ProductDao();

  Future<void> insert(Product product) async {
    productDao.create(
      code: product.code,
      amount: product.amount,
      price: product.price,
      name: product.name,
    );
  }

  Future<List<Product>> getList(String orderBy, int page) async {
    return await productDao.getList(orderBy, page);
  }

  Future<void> delete(int code) async {
    return await productDao.remove(code);
  }

  Future<void> update(Product product) async {
    return await productDao.update(product);
  }

  Future<int> getCount() async {
    return await productDao.getCount();
  }
}
