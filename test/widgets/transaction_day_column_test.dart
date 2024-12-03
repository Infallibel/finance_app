import 'package:bloc_test/bloc_test.dart';
import 'package:finance_app/services/transaction_data.dart';
import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/category_cubit.dart';
import 'package:finance_app/utilities/CubitsBlocs/settingsCubits/currency_cubit.dart';
import 'package:finance_app/widgets/icon_text_row.dart';
import 'package:finance_app/widgets/transactions_day_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryCubit extends MockCubit<CategoryState>
    implements CategoryCubit {}

class MockCategoryState extends Fake implements CategoryState {}

class MockCurrencyCubit extends MockCubit<CurrencyState>
    implements CurrencyCubit {}

class MockCurrencyState extends Fake implements CurrencyState {}

void main() {
  group('TransactionDayColumn', () {
    late final CategoryCubit mockCategoryCubit;
    late final CurrencyCubit mockCurrencyCubit;
    late final List<Map<String, dynamic>> mockCategories;

    setUpAll(() {
      registerFallbackValue(MockCategoryState());
      registerFallbackValue(MockCurrencyState());
      mockCategoryCubit = MockCategoryCubit();
      mockCurrencyCubit = MockCurrencyCubit();

      mockCategories = [
        {
          'id': 'cat1',
          'iconData': Icons.shopping_cart,
          'iconColor': Colors.blue,
          'inputText': 'Groceries',
        },
        {
          'id': 'cat2',
          'iconData': Icons.local_gas_station,
          'iconColor': Colors.green,
          'inputText': 'Fuel',
        },
      ];
    });

    testWidgets('renders day and transactions correctly',
        (WidgetTester tester) async {
      // Stub the cubit's state to return mock categories
      when(() => mockCategoryCubit.categories).thenReturn(mockCategories);
      when(() => mockCurrencyCubit.state).thenReturn(InitialCurrencyState());

      final mockTransactions = [
        TransactionData(
          id: 'tx1',
          categoryId: 'cat1',
          transactionType: 'Expenses',
          amount: 50.0,
          user: 'User A',
          date: DateTime.now(),
          paymentType: {'type': 'Credit Card'},
          photo: null,
          note: 'Bought groceries',
        ),
        TransactionData(
          id: 'tx2',
          categoryId: 'cat2',
          transactionType: 'Income',
          amount: 100.69,
          user: 'User B',
          date: DateTime.now(),
          paymentType: {'type': 'Bank Transfer'},
          photo: null,
          note: null,
        ),
        TransactionData(
          id: 'tx3',
          categoryId: 'cat3', // Non-existent category
          transactionType: 'Expenses',
          amount: 20.0,
          user: 'User C',
          date: DateTime.now(),
          paymentType: {'type': 'Cash'},
          photo: null,
          note: 'Miscellaneous expense',
        ),
      ];

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CategoryCubit>.value(value: mockCategoryCubit),
            BlocProvider<CurrencyCubit>.value(value: mockCurrencyCubit),
          ],
          child: MaterialApp(
            home: TransactionDayColumn(
              day: 'Monday',
              transactions: mockTransactions,
            ),
          ),
        ),
      );

      // Verify the day is displayed
      expect(find.text('Monday'), findsOneWidget);

      // Verify the transactions are displayed with the correct details
      expect(find.byType(IconTextAndRow), findsNWidgets(3));
      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Fuel'), findsOneWidget);
      expect(find.text('Unknown'),
          findsOneWidget); // For the non-existent category
      expect(find.text('-50'), findsOneWidget);
      expect(find.text('.69'), findsOneWidget); // Expense, shown as negative
      expect(find.text('100'), findsOneWidget); // Income, positive
    });
  });
}
