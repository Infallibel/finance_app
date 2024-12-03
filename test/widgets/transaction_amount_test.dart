import 'package:bloc_test/bloc_test.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_app/widgets/transaction_amount.dart';
import 'package:finance_app/utilities/CubitsBlocs/settingsCubits/currency_cubit.dart';

class MockCurrencyCubit extends MockCubit<CurrencyState>
    implements CurrencyCubit {}

class MockCurrencyState extends Fake implements CurrencyState {}

void main() {
  group('TransactionAmount Widget Tests', () {
    late MockCurrencyCubit mockCurrencyCubit;

    setUp(() {
      mockCurrencyCubit = MockCurrencyCubit();
    });

    testWidgets('displays the correct amount with correct color for Income',
        (WidgetTester tester) async {
      when(() => mockCurrencyCubit.state)
          .thenReturn(CurrencySelected({'USD': '\$'}));

      await tester.pumpWidget(
        BlocProvider<CurrencyCubit>.value(
          value: mockCurrencyCubit,
          child: MaterialApp(
            home: Scaffold(
              body: TransactionAmount(
                amount: 100.50,
                transactionType: 'Income',
              ),
            ),
          ),
        ),
      );

      // Verify that the amount is displayed correctly
      expect(find.text('100'), findsOneWidget); // Whole part
      expect(find.text('.50'), findsOneWidget); // Fraction part

      // Verify that the text color is correct for 'Income'
      final wholePartText = tester.widget<Text>(find.text('100'));
      final fractionPartText = tester.widget<Text>(find.text('.50'));
      expect(
          wholePartText.style?.color, kColorSuccess); // Check for Income color
      expect(fractionPartText.style?.color,
          kColorSuccess); // Check for Income color
    });

    testWidgets('displays the correct amount with correct color for Expenses',
        (WidgetTester tester) async {
      when(() => mockCurrencyCubit.state)
          .thenReturn(CurrencySelected({'USD': '\$'}));

      await tester.pumpWidget(
        BlocProvider<CurrencyCubit>.value(
          value: mockCurrencyCubit,
          child: MaterialApp(
            home: Scaffold(
              body: TransactionAmount(
                amount: 50.25,
                transactionType: 'Expenses',
              ),
            ),
          ),
        ),
      );

      // Verify that the amount is displayed correctly
      expect(find.text('50'), findsOneWidget); // Whole part
      expect(find.text('.25'), findsOneWidget); // Fraction part

      // Verify that the text color is correct for 'Expenses'
      final wholePartText = tester.widget<Text>(find.text('50'));
      final fractionPartText = tester.widget<Text>(find.text('.25'));
      expect(
          wholePartText.style?.color, kColorBlack); // Check for Expenses color
      expect(fractionPartText.style?.color,
          kColorGrey2); // Check for Expenses color
    });

    testWidgets('displays the correct amount with correct color for Transfer',
        (WidgetTester tester) async {
      when(() => mockCurrencyCubit.state)
          .thenReturn(CurrencySelected({'USD': '\$'}));

      await tester.pumpWidget(
        BlocProvider<CurrencyCubit>.value(
          value: mockCurrencyCubit,
          child: MaterialApp(
            home: Scaffold(
              body: TransactionAmount(
                amount: 75.00,
                transactionType: 'Transfer',
              ),
            ),
          ),
        ),
      );

      // Verify that the amount is displayed correctly
      expect(find.text('75'), findsOneWidget); // Whole part
      expect(find.text('.00'), findsOneWidget); // Fraction part

      // Verify that the text color is correct for 'Transfer'
      final wholePartText = tester.widget<Text>(find.text('75'));
      final fractionPartText = tester.widget<Text>(find.text('.00'));
      expect(
          wholePartText.style?.color, kColorBlue); // Check for Transfer color
      expect(fractionPartText.style?.color,
          kColorBlue); // Check for Transfer color
    });

    testWidgets('displays the correct currency symbol based on CurrencyCubit',
        (WidgetTester tester) async {
      when(() => mockCurrencyCubit.state)
          .thenReturn(CurrencySelected({'USD': '\$'}));

      await tester.pumpWidget(
        BlocProvider<CurrencyCubit>.value(
          value: mockCurrencyCubit,
          child: MaterialApp(
            home: Scaffold(
              body: TransactionAmount(
                amount: 50.50,
                transactionType: 'Expenses',
              ),
            ),
          ),
        ),
      );

      // Verify that the symbol is correctly displayed (before amount or after it)
      expect(find.text('\$'),
          findsOneWidget); // Currency symbol should be displayed

      // Check if the currency symbol is before or after the amount based on the logic
      final symbolText = tester.widget<Text>(find.text('\$'));
      expect(symbolText.style?.color,
          kColorBlack); // Symbol color should match the whole part color
    });

    testWidgets(
        'displays correct currency symbol for non-symbol-before currencies',
        (WidgetTester tester) async {
      when(() => mockCurrencyCubit.state).thenReturn(
          CurrencySelected({'Euro': '€'})); // Testing Euro as an example

      await tester.pumpWidget(
        BlocProvider<CurrencyCubit>.value(
          value: mockCurrencyCubit,
          child: MaterialApp(
            home: Scaffold(
              body: TransactionAmount(
                amount: 50.50,
                transactionType: 'Expenses',
              ),
            ),
          ),
        ),
      );

      // Verify that the symbol is displayed correctly after the amount
      expect(find.text(' €'), findsOneWidget);
    });
  });
}
