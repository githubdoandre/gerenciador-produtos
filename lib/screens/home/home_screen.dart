import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:produtosapp/model/product.dart';
import 'package:produtosapp/screens/product/product_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bloc = BlocProvider.getBloc<ProductBloc>();
  final _numberFormat = NumberFormat.decimalPattern('pt_BR');
  final _currencyFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');
  List<Product> _productList;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    _bloc.resetPage();
    _bloc.fecthList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      endDrawer: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder<String>(
            initialData: 'name',
            stream: _bloc.orderByStream,
            builder: (context, snapshot) {
              return Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Ordenar por'),
                    ),
                    RadioListTile(
                      title: Text("Preço"),
                      groupValue: snapshot.data,
                      value: 'price',
                      onChanged: (val) {
                        _bloc.changeOrderByFilter('price');
                      },
                    ),
                    RadioListTile(
                      title: Text("Quantidade"),
                      groupValue: snapshot.data,
                      value: 'amount',
                      onChanged: (val) {
                        _bloc.changeOrderByFilter('amount');
                      },
                    ),
                    RadioListTile(
                      title: Text("Código"),
                      groupValue: snapshot.data,
                      value: 'code',
                      onChanged: (val) {
                        _bloc.changeOrderByFilter('code');
                      },
                    ),
                    RadioListTile(
                      title: Text("Nome"),
                      groupValue: snapshot.data,
                      value: 'name',
                      onChanged: (val) {
                        _bloc.changeOrderByFilter('name');
                      },
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: MaterialButton(
                            color: Colors.teal,
                            minWidth: MediaQuery.of(context).size.width / 3,
                            onPressed: () async {
                              _bloc.resetPage();
                              _bloc.fecthList();

                              Navigator.pop(context);
                            },
                            child: Text(
                              "Ok",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                Icons.filter_list,
              ),
              onPressed: () => _drawerKey.currentState.openEndDrawer()),
        ],
        title: Text('Home'),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder<ResultState>(
              stream: _bloc.productListStream,
              builder: (context, snapshot) {
                _productList = _bloc.results;

                switch (snapshot.data) {
                  case ResultState.PAGING:
                    continue loaded;
                    break;
                  loaded:
                  case ResultState.LOADED:
                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollState) {
                        if (scrollState is ScrollEndNotification) {
                          if ((scrollState.metrics.pixels ==
                                  scrollState.metrics.maxScrollExtent) &&
                              _bloc.hasNextPage) {
                            _bloc.loadNextPage();
                          }
                        }

                        return true;
                      },
                      child: RefreshIndicator(
                        onRefresh: () {
                          return _bloc.fecthList();
                        },
                        child:
                            getListWidget(snapshot.data == ResultState.PAGING),
                      ),
                    );
                    break;
                  case ResultState.EMPTY:
                    return Center(
                        key: Key('zero-data'),
                        child: Text('Nenhum registro encontrado'));
                    break;
                  default:
                    return Center(child: CircularProgressIndicator());
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pushNamed(
            context,
            '/productDetail',
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getListWidget(showLoading) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12.0),
                        onTap: () => Navigator.pushNamed(
                            context, '/productDetail',
                            arguments: _productList[index]),
                        title: Text(_productList[index].name),
                        leading: Text(_productList[index].code.toString()),
                        trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await _bloc.delete(_productList[index].code);
                              _bloc.resetPage();
                              _bloc.fecthList();
                            }),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_currencyFormat
                                .format(_productList[index].price)),
                            Text(
                                "${_numberFormat.format(_productList[index].amount)} UN"),
                          ],
                        ),
                      ),
                    ),
                  ),
              itemCount: _productList.length),
        ),
        Visibility(
          visible: showLoading,
          child: SizedBox.fromSize(
            size: Size(MediaQuery.of(context).size.width, 50),
            child: Center(child: CircularProgressIndicator()),
          ),
        )
      ],
    );
  }
}
