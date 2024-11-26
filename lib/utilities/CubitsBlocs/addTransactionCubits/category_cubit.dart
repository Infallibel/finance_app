import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_combined.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

abstract class CategoryState {
  final List<Map<String, dynamic>> categories;
  const CategoryState(this.categories);

  /// Abstract getter for selected category ID
  String? get selectedCategoryId => null;
}

class InitialCategoryState extends CategoryState {
  InitialCategoryState(super.categories);
}

class CategorySelected extends CategoryState {
  final String categoryId;

  CategorySelected(this.categoryId, List<Map<String, dynamic>> categories)
      : super(categories);

  /// Override getter to return the selected category ID
  @override
  String? get selectedCategoryId => categoryId;
}

class CategoryAdded extends CategoryState {
  final Map<String, dynamic> newCategory;

  CategoryAdded(this.newCategory, List<Map<String, dynamic>> categories)
      : super(categories);
}

class CategoryUpdated extends CategoryState {
  final Map<String, dynamic> updatedCategory;
  final int index;

  CategoryUpdated(
      this.updatedCategory, this.index, List<Map<String, dynamic>> categories)
      : super(categories);
}

class CategoryDeleted extends CategoryState {
  final int index;

  CategoryDeleted(this.index, List<Map<String, dynamic>> categories)
      : super(categories);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message, List<Map<String, dynamic>> categories)
      : super(categories);
}

class CategoryCubit extends Cubit<CategoryState> {
  List<Map<String, dynamic>> _categories;

  CategoryCubit(this._categories) : super(InitialCategoryState(_categories));

  List<Map<String, dynamic>> get categories => _categories;

  static String _generateId() {
    return Uuid().v4();
  }

  void showOptions(BuildContext context) async {
    final selectedCategory = await showModalBottomSheet<String>(
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
                  Navigator.of(context).pop(category['id']);
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
      selectCategoryById(selectedCategory);
    }
  }

  void addCategory(Map<String, dynamic> newCategory) {
    newCategory['id'] = _generateId();
    final updatedCategories = List<Map<String, dynamic>>.from(_categories)
      ..add(newCategory);
    _categories = updatedCategories;
    emit(CategoryAdded(newCategory, updatedCategories));
  }

  void updateCategory(int index, Map<String, dynamic> updatedCategory) {
    updatedCategory['id'] = _categories[index]['id']; // Retain the ID
    final updatedCategories = List<Map<String, dynamic>>.from(_categories)
      ..[index] = updatedCategory;
    _categories = updatedCategories;
    emit(CategoryUpdated(updatedCategory, index, updatedCategories));
  }

  void removeCategory(int index) {
    final updatedCategories = List<Map<String, dynamic>>.from(_categories)
      ..removeAt(index);
    _categories = updatedCategories;
    emit(CategoryDeleted(index, updatedCategories));
  }

  void selectCategoryById(String categoryId) {
    emit(CategorySelected(categoryId, _categories));
  }

  void clearCategory() {
    emit(InitialCategoryState(_categories));
  }

  Map<String, dynamic>? findCategoryById(String? categoryId) {
    try {
      return _categories.firstWhere(
        (category) => category['id'] == categoryId,
      );
    } catch (e) {
      return null;
    }
  }
}
