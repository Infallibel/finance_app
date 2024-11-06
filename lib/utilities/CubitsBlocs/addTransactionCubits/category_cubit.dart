import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_combined.dart';
import 'package:flutter/material.dart';
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

  Future<void> showOptions(BuildContext context) async {
    final selectedCategory = await showModalBottomSheet<Map<String, dynamic>>(
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

    if (selectedCategory != null) {
      selectCategory(selectedCategory);
    }
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
