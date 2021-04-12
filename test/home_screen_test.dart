import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:produtosapp/model/product.dart';
import 'package:produtosapp/repository/product_repository.dart';
import 'package:produtosapp/screens/home/home_screen.dart';
import 'package:produtosapp/screens/product/product_bloc.dart';

class ProductRepositoryMock extends Mock implements ProductRepository {}

void main() {
  testWidgets(
    'Deveria mostrar a lista de produtos cadastrados',
    (WidgetTester tester) async {
      final mockRepository = ProductRepositoryMock();

      when(mockRepository.getList(any, any)).thenAnswer((_) async {
        return [
          Product('produto1', 5, 10, 1234),
          Product('produto2', 5, 10, 1234),
        ];
      });
      when(mockRepository.getCount()).thenAnswer((_) async {
        return 2;
      });

      await tester.pumpWidget(
        BlocProvider(
          blocs: [
            Bloc((i) => ProductBloc(mockRepository)),
          ],
          child: MaterialApp(
            home: Material(
              child: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(ListTile), findsNWidgets(2));
    },
  );
  testWidgets(
    'Deveria mostrar uma mensagem caso não tenha nenhum produto cadastrado',
    (WidgetTester tester) async {
      final mockRepository = ProductRepositoryMock();

      when(mockRepository.getList(any, any)).thenAnswer((_) async {
        return [ 
        ];
      });
      when(mockRepository.getCount()).thenAnswer((_) async {
        return 0;
      });

      await tester.pumpWidget(
        BlocProvider(
          blocs: [
            Bloc((i) => ProductBloc(mockRepository)),
          ],
          child: MaterialApp(
            home: Material(
              child: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byKey(Key('zero-data')), findsOneWidget);
    },
  );
}
