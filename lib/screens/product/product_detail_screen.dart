import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:produtosapp/model/product.dart';
import 'package:produtosapp/screens/product/product_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen({Key key, this.product}) : super(key: key);

  final Product product;

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _bloc = BlocProvider.getBloc<ProductBloc>();

  final _amountController = TextEditingController();
  final _priceController = TextEditingController();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final numberFormat = NumberFormat.decimalPattern('pt_BR');

  @override
  Widget build(BuildContext context) {
    if (widget.product != null) {
      _nameController.text = widget.product.name;
      _codeController.text = widget.product.code.toString();
      _priceController.text = numberFormat.format(widget.product.price);
      _amountController.text = numberFormat.format(widget.product.amount);
    }

    _bloc.changeValidator(widget.product != null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Produto'),
        actions: [
          Visibility(
            visible: widget.product != null,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _bloc.delete(widget.product.code);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', ModalRoute.withName('/'));
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    enabled: widget.product == null,
                    validator: (text) {
                      if (text == null || text.isEmpty || text == '0') {
                        return 'Informe o código';
                      }
                      return null;
                    },
                    controller: _codeController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Código",
                      suffix: SizedBox(
                        width: 64,
                      ),
                      hintText: "Informe o código",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Color.fromRGBO(25, 48, 70, 1),
                    ),
                    onChanged: (v) => _bloc.changeValidator(
                        _nameController.text.trimLeft().isNotEmpty &&
                            _codeController.text.trimLeft().isNotEmpty),
                  ),
                  TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Informe o nome';
                      }
                      return null;
                    },
                    controller: _nameController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Nome",
                      suffix: SizedBox(
                        width: 64,
                      ),
                      hintText: "Informe o nome",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Color.fromRGBO(25, 48, 70, 1),
                    ),
                    onChanged: (v) => _bloc.changeValidator(
                        _nameController.text.trimLeft().isNotEmpty &&
                            _codeController.text.trimLeft().isNotEmpty),
                  ),
                  TextFormField(
                    inputFormatters: [
                      TextInputMask(
                          mask: '9+.999,99',
                          placeholder: '0',
                          maxPlaceHolders: 3,
                          reverse: true)
                    ],
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Preço",
                      suffix: SizedBox(
                        width: 64,
                      ),
                      hintText: "Informe o preço",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Color.fromRGBO(25, 48, 70, 1),
                    ),
                    onChanged: (v) {},
                  ),
                  TextFormField(
                    inputFormatters: [
                      TextInputMask(
                          mask: '9+.999,99',
                          placeholder: '0',
                          maxPlaceHolders: 3,
                          reverse: true)
                    ],
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Quantidade",
                      suffix: SizedBox(
                        width: 64,
                      ),
                      hintText: "Informe a quantidade em estoque",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Color.fromRGBO(25, 48, 70, 1),
                    ),
                    onChanged: (v) {},
                  ),
                  StreamBuilder<bool>(
                    stream: _bloc.validatorStream,
                    initialData: widget.product != null ? true : false,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: MaterialButton(
                          disabledColor: Colors.teal[100],
                          color: Colors.teal,
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: (snapshot.data == true)
                              ? () async {
                                  if (_formKey.currentState.validate()) {
                                    if (widget.product != null) {
                                      widget.product.name =
                                          _nameController.text;

                                      await _bloc.update(
                                          widget.product,
                                          _nameController.text.trimLeft(),
                                          _amountController.text,
                                          _priceController.text);
                                    } else {
                                      await _bloc.insert(
                                          int.parse(_codeController.text),
                                          _nameController.text.trimLeft(),
                                          _amountController.text,
                                          _priceController.text);
                                    }

                                    Navigator.pushNamedAndRemoveUntil(context,
                                        '/home', ModalRoute.withName('/'));
                                  }
                                }
                              : null,
                          child: Text("Salvar",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
