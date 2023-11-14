import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_combined.dart';
import 'package:finance_app/widgets/icon_text_row.dart';
import 'package:finance_app/widgets/text_button_model.dart';
import 'package:finance_app/widgets/transactions_selection.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/widgets/screen_scaffold.dart';
import 'package:finance_app/widgets/numerical_text_field.dart';
import 'package:finance_app/utilities/categories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CategoryState {}

class InitialCategoryState extends CategoryState {}

class CategorySelected extends CategoryState {
  final Map<String, dynamic> category;
  CategorySelected(this.category);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(InitialCategoryState());

  Future<Map<String, dynamic>?> showOptions(context) async {
    return await showModalBottomSheet(
      elevation: 0,
      backgroundColor: kColorWhite,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 600,
          child: ListView(
            children: categories.map((category) {
              return ListTile(
                splashColor: kColorLightBlueSecondary,
                onTap: () {
                  Navigator.of(context).pop(category);
                },
                title: IconTextCombined(
                  iconData: category['iconData'],
                  iconColor: category['iconColor'],
                  inputText: category['inputText'],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void selectCategory(Map<String, dynamic> category) {
    try {

      emit(CategorySelected(category));
    } catch (e) {
      emit(CategoryError('Error selecting category: $e'));
    }
  }

  void clearCategory() {
    emit(InitialCategoryState());
  }
}

class AddTransaction extends StatelessWidget {
  const AddTransaction({super.key});

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: kColorBlue,
              onPrimary: kColorBlack,
              onSurface: kColorGrey3,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kColorBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != DateTime.now()) {
      /// Handle the selected date
    }
  }

  void _selectCategory(BuildContext context) async {
    final selectedCategory =
        await context.read<CategoryCubit>().showOptions(context);
    if (selectedCategory != null) {
      context.read<CategoryCubit>().selectCategory(selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit(),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ScreenScaffold(
          appBarTitle: 'Add Transaction',
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.clear_outlined,
              color: kColorGrey2,
            ),
          ),
          scaffoldBody: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TransactionSelection(),
                  NumericalTextField(),
                  const Divider(
                    color: kColorGrey1,
                    thickness: 1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconTextAndRow(
                          selectionText: 'Selected',
                          iconData: Icons.person_outlined,
                          iconColor: kColorGrey1,
                          inputText: 'Anna'),
                      IconTextAndRow(
                          selectionText: 'Not Selected',
                          onTap: () {
                            _selectDate(context);
                          },
                          iconData: Icons.calendar_month_outlined,
                          iconColor: kColorGrey1,
                          inputText: 'Date'),
                      BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, state) {
                          return IconTextAndRow(
                              selectionText: state is CategorySelected
                                  ? 'Selected'
                                  : 'Not Selected',
                              onTap: () {
                                _selectCategory(context);
                              },
                              iconData: state is CategorySelected
                                  ? state.category['iconData']
                                  : Icons.folder_copy_outlined,
                              iconColor: kColorGrey1,
                              inputText: state is CategorySelected
                                  ? state.category['inputText']
                                  : 'Category');
                        },
                      ),
                      IconTextAndRow(
                          selectionText: 'Selected',
                          iconData: Icons.credit_card_outlined,
                          iconColor: kColorGrey1,
                          inputText: 'Card'),
                      IconTextAndRow(
                          iconData: Icons.photo_camera_outlined,
                          iconColor: kColorGrey1,
                          inputText: 'Photo'),
                      IconTextAndRow(
                          iconData: Icons.note_outlined,
                          iconColor: kColorGrey1,
                          inputText: 'Note'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButtonModel(
                onPressed: () {
                  // context
                  //     .read<CategoryBloc>()
                  //     .add(CategoryEvent.ClearCategory); // clear category event
                  Navigator.of(context).pop();
                },
                backgroundColor: kColorBlue,
                overlayColor: kColorLightBlue,
                buttonText: 'Save',
                buttonTextColor: kColorWhite),
          ),
        ),
      ),
    );
  }
}
