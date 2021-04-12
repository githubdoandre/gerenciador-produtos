import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:produtosapp/repository/product_repository.dart';
import 'package:produtosapp/screens/home/home_screen.dart';
import 'package:produtosapp/screens/product/product_bloc.dart';
import 'package:produtosapp/screens/product/product_detail_screen.dart';

import 'package:produtosapp/screens/splash/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => ProductBloc(ProductRepository())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: Splash(),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (_) => Splash(),
      );
    case '/home':
      return MaterialPageRoute(
        builder: (_) => HomeScreen(),
      );
    case '/productDetail':
      return MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: settings.arguments,
        ),
      );
  }
}
