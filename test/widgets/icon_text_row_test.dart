import 'package:bloc_test/bloc_test.dart';
import 'package:finance_app/utilities/CubitsBlocs/settingsCubits/currency_cubit.dart';
import 'package:finance_app/widgets/icon_text_row.dart';
import 'package:finance_app/widgets/transaction_amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyCubit extends MockCubit<CurrencyState>
    implements CurrencyCubit {}

class MockCurrencyState extends Fake implements CurrencyState {}

class MockVoidCallback extends Mock {
  void call();
}

void main() {
  group('IconTextAndRow', () {
    late final CurrencyCubit mockCurrencyCubit;

    setUpAll(() {
      registerFallbackValue(MockCurrencyState());
      mockCurrencyCubit = MockCurrencyCubit();
    });
    testWidgets('renders correctly with amount', (WidgetTester tester) async {
      when(() => mockCurrencyCubit.state)
          .thenReturn(CurrencySelected({'USD': '\$'}));
      await tester.pumpWidget(
        BlocProvider<CurrencyCubit>.value(
          value: mockCurrencyCubit,
          child: MaterialApp(
            home: IconTextAndRow(
              iconData: Icons.shopping_cart,
              iconColor: Colors.blue,
              inputText: 'Shopping',
              amount: 50.0,
              transactionType: 'Expenses',
            ),
          ),
        ),
      );

      expect(find.text('Shopping'), findsOneWidget);
      expect(find.byType(TransactionAmount), findsOneWidget);
    });

    testWidgets('renders correctly with selectionText',
        (WidgetTester tester) async {
      when(() => mockCurrencyCubit.state)
          .thenReturn(CurrencySelected({'USD': '\$'}));
      await tester.pumpWidget(
        BlocProvider<CurrencyCubit>.value(
          value: mockCurrencyCubit,
          child: MaterialApp(
            home: IconTextAndRow(
              iconData: Icons.category,
              iconColor: Colors.green,
              inputText: 'Category',
              selectionText: 'Select',
            ),
          ),
        ),
      );

      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Select'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_outlined), findsOneWidget);
    });

    testWidgets('renders trailingIcon if provided',
        (WidgetTester tester) async {
      when(() => mockCurrencyCubit.state)
          .thenReturn(CurrencySelected({'USD': '\$'}));
      await tester.pumpWidget(
        MaterialApp(
          home: IconTextAndRow(
            iconData: Icons.label,
            iconColor: Colors.red,
            inputText: 'Label',
            trailingIcon: Icons.arrow_forward,
          ),
        ),
      );

      expect(find.text('Label'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });
  });
}
