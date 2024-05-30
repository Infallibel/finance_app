import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/category_cubit.dart';
import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/date_cubit.dart';
import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/payment_type_cubit.dart';
import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/transaction_data_cubit.dart';
import 'package:finance_app/utilities/CubitsBlocs/addTransactioncubits/transaction_type_cubit.dart';
import 'package:finance_app/utilities/CubitsBlocs/month_year_cubit.dart';
import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CategoryCubit(),
          ),
          BlocProvider(
            create: (context) => DateCubit(),
          ),
          BlocProvider(
            create: (context) => PaymentTypeCubit(),
          ),
          BlocProvider(
            create: (context) => TransactionTypeCubit(),
          ),
          BlocProvider(
            create: (context) => TransactionDataCubit(),
          ),
          BlocProvider(
            create: (context) => MonthYearCubit(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textSelectionTheme: const TextSelectionThemeData(
                selectionColor: kColorLightBlue,
                cursorColor: kColorLightBlue,
                selectionHandleColor: kColorLightBlue),
            colorScheme: const ColorScheme.light(),
            useMaterial3: true,
          ),
          home: const BottomBar(),
        ));
  }
}
