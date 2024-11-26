// import 'package:finance_app/services/transaction_data.dart';
// import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/category_cubit.dart';
// import 'package:finance_app/utilities/CubitsBlocs/settingsCubits/currency_cubit.dart';
// import 'package:finance_app/utilities/constants.dart';
// import 'package:finance_app/widgets/transactions_day_column.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mocktail/mocktail.dart';
//
// class MockCategoryCubit extends Mock implements CategoryCubit {}
//
// class MockCurrencyCubit extends Mock implements CurrencyCubit {}
//
// void main() {
//   group('TransactionDayColumn Widget Tests', () {
//     late MockCategoryCubit mockCategoryCubit;
//     late MockCurrencyCubit mockCurrencyCubit; // Add the CurrencyCubit mock
//     late List<TransactionData> sampleTransactions;
//
//     setUpAll(() {
//       registerFallbackValue(InitialCategoryState());
//       registerFallbackValue(
//           InitialCurrencyState()); // Register fallback if needed
//     });
//
//     setUp(() {
//       mockCategoryCubit = MockCategoryCubit();
//       mockCurrencyCubit = MockCurrencyCubit();
//
//       // Initialize categories list in the mock CategoryCubit
//       when(() => mockCategoryCubit.categoriesList).thenReturn([
//         {
//           'id': '1',
//           'iconData': Icons.shopping_bag,
//           'iconColor': Colors.red,
//           'inputText': 'Shopping',
//         },
//         {
//           'id': '2',
//           'iconData': Icons.local_dining,
//           'iconColor': Colors.green,
//           'inputText': 'Food',
//         },
//         {
//           'id': '3',
//           'iconData': Icons.local_airport,
//           'iconColor': Colors.blue,
//           'inputText': 'Flight',
//         },
//         {
//           'id': '4',
//           'iconData': Icons.safety_check,
//           'iconColor': Colors.yellow,
//           'inputText': 'Health',
//         }
//       ]);
//
//       // Stub the streams for the mocks
//       when(() => mockCategoryCubit.stream).thenAnswer((_) =>
//           Stream.value(CategoryAdded(mockCategoryCubit.getCategories[0])));
//       when(() => mockCategoryCubit.state)
//           .thenReturn(CategoryAdded(mockCategoryCubit.getCategories[0]));
//
//       when(() => mockCurrencyCubit.stream)
//           .thenAnswer((_) => const Stream<CurrencyState>.empty());
//       when(() => mockCurrencyCubit.state).thenReturn(InitialCurrencyState());
//
//       sampleTransactions = [
//         TransactionData(
//           user: 'Anna',
//           paymentType: {
//             'iconData': Icons.currency_exchange_outlined,
//             'iconColor': kColorGrey1,
//             'inputText': 'Transfer',
//           },
//           date: DateTime.now(),
//           id: '1',
//           amount: 100,
//           category: {
//             'id': '1',
//             'iconData': Icons.shopping_bag,
//             'iconColor': Colors.red,
//             'inputText': 'Shopping',
//           },
//           transactionType: 'Expenses',
//         ),
//         TransactionData(
//           user: 'Anna',
//           paymentType: {
//             'iconData': Icons.money_outlined,
//             'iconColor': kColorGrey1,
//             'inputText': 'Cash',
//           },
//           date: DateTime(2000, 12, 25),
//           id: '2',
//           amount: 200,
//           category: {
//             'id': '2',
//             'iconData': Icons.local_dining,
//             'iconColor': Colors.green,
//             'inputText': 'Food',
//           },
//           transactionType: 'Income',
//         ),
//       ];
//     });
//
//     testWidgets('displays day and transactions correctly',
//         (WidgetTester tester) async {
//       const testDay = '25/12/2000';
//
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<CategoryCubit>.value(value: mockCategoryCubit),
//             BlocProvider<CurrencyCubit>.value(
//                 value: mockCurrencyCubit), // Provide the CurrencyCubit
//           ],
//           child: MaterialApp(
//             home: TransactionDayColumn(
//                 day: testDay, transactions: sampleTransactions),
//           ),
//         ),
//       );
//
//       // Verify the UI contains the expected elements
//       expect(find.text(testDay), findsOneWidget);
//       expect(find.text('Shopping'), findsOneWidget);
//       expect(find.text('Food'), findsOneWidget);
//     });
//
//     // Repeat the other tests, wrapping them in the same MultiBlocProvider
//     testWidgets('updates transactions on CategoryUpdated',
//         (WidgetTester tester) async {
//       const testDay = '25/12/2000';
//
//       final updatedCategory = {
//         'id': '1', // Match with sampleTransactions category
//         'iconData': Icons.shopping_bag,
//         'iconColor': Colors.blue,
//         'inputText': 'Updated Shopping',
//       };
//
//       // Stub the mock stream to emit CategoryUpdated state
//       when(() => mockCategoryCubit.stream)
//           .thenAnswer((_) => Stream.value(CategoryUpdated(updatedCategory, 0)));
//       when(() => mockCategoryCubit.state)
//           .thenReturn(CategoryUpdated(updatedCategory, 0));
//
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<CategoryCubit>.value(value: mockCategoryCubit),
//             BlocProvider<CurrencyCubit>.value(value: mockCurrencyCubit),
//           ],
//           child: MaterialApp(
//             home: TransactionDayColumn(
//                 day: testDay, transactions: sampleTransactions),
//           ),
//         ),
//       );
//
//       // Ensure widget rebuilds after state update
//       await tester.pumpAndSettle();
//
//       // Verify the updated category appears in the widget
//       expect(find.text('Updated Shopping'), findsOneWidget);
//     });
//
//     testWidgets('removes category on CategoryDeleted',
//         (WidgetTester tester) async {
//       const testDay = '25/12/2000';
//
//       // Stub the mock stream to emit CategoryDeleted state
//       when(() => mockCategoryCubit.stream)
//           .thenAnswer((_) => Stream.value(CategoryDeleted(2)));
//       when(() => mockCategoryCubit.state).thenReturn(CategoryDeleted(2));
//
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<CategoryCubit>.value(value: mockCategoryCubit),
//             BlocProvider<CurrencyCubit>.value(value: mockCurrencyCubit),
//           ],
//           child: MaterialApp(
//             home: TransactionDayColumn(
//                 day: testDay, transactions: sampleTransactions),
//           ),
//         ),
//       );
//
//       // Ensure widget rebuilds after state update
//       await tester.pumpAndSettle();
//
//       // Verify the category has been removed
//       expect(find.text('Flight'), findsNothing);
//     });
//   });
// }
