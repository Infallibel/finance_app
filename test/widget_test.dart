import 'package:finance_app/services/transaction_data.dart';
import 'package:finance_app/utilities/cubitsBlocs/addTransactionCubits/category_cubit.dart';
import 'package:finance_app/widgets/transactions_day_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryCubit extends Mock implements CategoryCubit {}

void main() {
  late MockCategoryCubit mockCategoryCubit;

  setUpAll(() {
    registerFallbackValue(InitialCategoryState([])); // Default state fallback
  });

  setUp(() {
    mockCategoryCubit = MockCategoryCubit();
  });

  group('TransactionDayColumn Widget Tests', () {
    testWidgets('displays transactions correctly when categories exist',
        (WidgetTester tester) async {
      const testDay = '25/12/2022';

      // Mock transactions
      final transactions = [
        TransactionData(
          user: 'User 1',
          paymentType: {
            'iconData': Icons.payment,
            'iconColor': Colors.blue,
            'inputText': 'Card',
          },
          date: DateTime(2022, 12, 25),
          id: '1',
          amount: 100,
          categoryId: '1',
          transactionType: 'Expenses',
        ),
        TransactionData(
          user: 'User 2',
          paymentType: {
            'iconData': Icons.money,
            'iconColor': Colors.green,
            'inputText': 'Cash',
          },
          date: DateTime(2022, 12, 25),
          id: '2',
          amount: 200,
          categoryId: '2',
          transactionType: 'Income',
        ),
      ];

      // Mock categories
      when(() => mockCategoryCubit.categories).thenReturn([
        {
          'id': '1',
          'iconData': Icons.shopping_bag,
          'iconColor': Colors.red,
          'inputText': 'Shopping',
        },
        {
          'id': '2',
          'iconData': Icons.local_dining,
          'iconColor': Colors.green,
          'inputText': 'Food',
        },
      ]);

      when(() => mockCategoryCubit.state)
          .thenReturn(InitialCategoryState(mockCategoryCubit.categories));

      // Pump widget
      await tester.pumpWidget(
        BlocProvider<CategoryCubit>.value(
          value: mockCategoryCubit,
          child: MaterialApp(
            home: TransactionDayColumn(
              day: testDay,
              transactions: transactions,
            ),
          ),
        ),
      );

      // Verify the UI
      expect(find.text(testDay), findsOneWidget);
      expect(find.text('Shopping'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
    });

    testWidgets('displays fallback for unknown category',
        (WidgetTester tester) async {
      const testDay = '25/12/2022';

      // Mock transaction with an unknown category ID
      final transactionsWithUnknownCategory = [
        TransactionData(
          user: 'User 1',
          paymentType: {
            'iconData': Icons.payment,
            'iconColor': Colors.blue,
            'inputText': 'Card',
          },
          date: DateTime(2022, 12, 25),
          id: '1',
          amount: 100,
          categoryId: 'unknown', // Nonexistent category ID
          transactionType: 'Expenses',
        ),
      ];

      // Mock categories
      final mockCategories = [
        {
          'id': '1',
          'iconData': Icons.shopping_bag,
          'iconColor': Colors.red,
          'inputText': 'Shopping',
        },
      ];

      // Set up the mock cubit
      when(() => mockCategoryCubit.categories).thenReturn(mockCategories);
      when(() => mockCategoryCubit.state)
          .thenReturn(InitialCategoryState(mockCategories));
      when(() => mockCategoryCubit.stream).thenAnswer((_) => Stream.empty());

      // Pump the widget with a BlocProvider
      await tester.pumpWidget(
        BlocProvider<CategoryCubit>.value(
          value: mockCategoryCubit,
          child: MaterialApp(
            home: Scaffold(
              body: TransactionDayColumn(
                day: testDay,
                transactions: transactionsWithUnknownCategory,
              ),
            ),
          ),
        ),
      );

      // Verify fallback UI elements
      expect(find.text('Unknown'),
          findsOneWidget); // Ensure fallback text is shown
      expect(find.byIcon(Icons.error),
          findsOneWidget); // Ensure fallback icon is shown
    });

    testWidgets('updates transactions on CategoryUpdated',
        (WidgetTester tester) async {
      const testDay = '25/12/2022';

      // Mock transactions
      final transactions = [
        TransactionData(
          user: 'User 1',
          paymentType: {
            'iconData': Icons.payment,
            'iconColor': Colors.blue,
            'inputText': 'Card',
          },
          date: DateTime(2022, 12, 25),
          id: '1',
          amount: 100,
          categoryId: '1',
          transactionType: 'Expenses',
        ),
      ];

      // Mock initial categories
      when(() => mockCategoryCubit.categories).thenReturn([
        {
          'id': '1',
          'iconData': Icons.shopping_bag,
          'iconColor': Colors.red,
          'inputText': 'Shopping',
        },
      ]);

      // Stub initial state
      when(() => mockCategoryCubit.state)
          .thenReturn(InitialCategoryState(mockCategoryCubit.categories));

      // Stub category update
      final updatedCategory = {
        'id': '1',
        'iconData': Icons.shopping_cart,
        'iconColor': Colors.blue,
        'inputText': 'Updated Shopping',
      };
      when(() => mockCategoryCubit.stream).thenAnswer(
        (_) => Stream.value(CategoryUpdated(updatedCategory, 0, [
          updatedCategory,
        ])),
      );

      await tester.pumpWidget(
        BlocProvider<CategoryCubit>.value(
          value: mockCategoryCubit,
          child: MaterialApp(
            home: TransactionDayColumn(
              day: testDay,
              transactions: transactions,
            ),
          ),
        ),
      );

      // Trigger rebuild
      await tester.pumpAndSettle();

      // Verify updated UI
      expect(find.text('Updated Shopping'), findsOneWidget);
    });

    testWidgets('removes category on CategoryDeleted',
        (WidgetTester tester) async {
      const testDay = '25/12/2022';

      // Mock transactions
      final transactions = [
        TransactionData(
          user: 'User 1',
          paymentType: {
            'iconData': Icons.payment,
            'iconColor': Colors.blue,
            'inputText': 'Card',
          },
          date: DateTime(2022, 12, 25),
          id: '1',
          amount: 100,
          categoryId: '1',
          transactionType: 'Expenses',
        ),
      ];

      // Mock initial categories
      when(() => mockCategoryCubit.categories).thenReturn([
        {
          'id': '1',
          'iconData': Icons.shopping_bag,
          'iconColor': Colors.red,
          'inputText': 'Shopping',
        },
      ]);

      // Stub initial state
      when(() => mockCategoryCubit.state)
          .thenReturn(InitialCategoryState(mockCategoryCubit.categories));

      // Stub category delete
      when(() => mockCategoryCubit.stream).thenAnswer(
        (_) => Stream.value(CategoryDeleted(0, [])),
      );

      await tester.pumpWidget(
        BlocProvider<CategoryCubit>.value(
          value: mockCategoryCubit,
          child: MaterialApp(
            home: TransactionDayColumn(
              day: testDay,
              transactions: transactions,
            ),
          ),
        ),
      );

      // Trigger rebuild
      await tester.pumpAndSettle();

      // Verify fallback UI
      expect(find.text('Unknown'), findsOneWidget);
    });
  });
}
