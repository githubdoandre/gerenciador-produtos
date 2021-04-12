import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:produtosapp/model/product.dart';
import 'package:produtosapp/repository/product_repository.dart';
import 'package:rxdart/rxdart.dart';

enum ResultState {
  LOADING,
  LOADED,
  EMPTY,
  PAGING,
}

class ProductBloc extends BlocBase {
  final ProductRepository repository;

  List<Product> _productList = [];
  List<Product> get results => _productList;

  final _listController = BehaviorSubject<ResultState>();
  Stream get productListStream => _listController.stream;

  final _validatorController = BehaviorSubject<bool>();
  Stream get validatorStream => _validatorController.stream;

  final _orderByController = BehaviorSubject<String>();
  Stream get orderByStream => _orderByController.stream;

  int _page = 1;
  int _totalResults = 0;
  int _totalPages = 0;
  int _perPage = 10;
  bool hasNextPage = false;

  ProductBloc(this.repository);

  void changeValidator(bool value) async => _validatorController.add(value);
  void changeOrderByFilter(String value) async => _orderByController.add(value);
  void resetPage() => _page = 1;

  Future<void> fecthList(
      {ResultState initialState = ResultState.LOADING}) async {
    _listController.sink.add(initialState);

    //await Future.delayed(Duration(seconds: 1));

    if (_page == 1) {
      _productList.clear();
    }

    _productList
        .addAll(await repository.getList(_orderByController.value, _page));

    _totalResults = await repository.getCount();
    _totalPages = (_totalResults / _perPage).ceil();

    if (_page == 1 && _totalResults == 0) {
      _listController.sink.add(ResultState.EMPTY);
    } else {
      _listController.sink.add(ResultState.LOADED);
      hasNextPage = _page < _totalPages;
    }
  }

  void loadNextPage() {
    _page++;

    fecthList(initialState: ResultState.PAGING);
  }

  Future<void> insert(
      int code, String name, String amount, String price) async {
    Product product = new Product(
        name, convertoToFloat(price), convertoToFloat(amount), code);

    await repository.insert(product);
  }

  Future<void> delete(int code) async {
    await repository.delete(code);
  }

  Future<void> update(
      Product product, String name, String amount, String price) async {
    product.name = name;
    product.amount = convertoToFloat(amount);
    product.price = convertoToFloat(price);

    await repository.update(product);
  }

  num convertoToFloat(String value) {
    return double.parse(
        value.isEmpty ? '0' : value.replaceAll('.', '').replaceAll(',', '.'));
  }

  @override
  void dispose() {
    _listController.close();
    _validatorController.close();
    _orderByController.close();
    super.dispose();
  }
}
