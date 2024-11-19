import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_combined.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

abstract class CategoryState {}

class InitialCategoryState extends CategoryState {}

class CategorySelected extends CategoryState {
  final Map<String, dynamic> category;
  CategorySelected(this.category);
}

class CategoryAdded extends CategoryState {
  final Map<String, dynamic> category;
  CategoryAdded(this.category);
}

class CategoryUpdated extends CategoryState {
  final Map<String, dynamic> category;
  CategoryUpdated(
    this.category,
  );
}

class CategoryDeleted extends CategoryState {
  final String categoryId;
  CategoryDeleted(this.categoryId);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(InitialCategoryState());

  List<Map<String, dynamic>> categories = [
    {
      'id': _generateId(),
      'iconData': Icons.money_outlined,
      'iconColor': kColorGreen,
      'inputText': 'Salary',
    },
    {
      'id': _generateId(),
      'iconData': Icons.house_outlined,
      'iconColor': kColorOlive,
      'inputText': 'Household',
    },
    {
      'id': _generateId(),
      'iconData': Icons.shopping_cart_outlined,
      'iconColor': kColorOrange,
      'inputText': 'Grocery',
    },
    {
      'id': _generateId(),
      'iconData': Icons.health_and_safety_outlined,
      'iconColor': kColorTurquoise,
      'inputText': 'Health',
    },
    {
      'id': _generateId(),
      'iconData': Icons.extension_outlined,
      'iconColor': kColorCoral,
      'inputText': 'Entertainment',
    },
    {
      'id': _generateId(),
      'iconData': Icons.coffee_outlined,
      'iconColor': kColorBrown,
      'inputText': 'Coffee',
    },
    {
      'id': _generateId(),
      'iconData': Icons.restaurant_outlined,
      'iconColor': kColorSoftRed,
      'inputText': 'Restaurant',
    },
    {
      'id': _generateId(),
      'iconData': Icons.local_taxi_outlined,
      'iconColor': kColorYellow,
      'inputText': 'Taxi',
    },
    {
      'id': _generateId(),
      'iconData': Icons.bed_outlined,
      'iconColor': kColorOliveGreen,
      'inputText': 'Hotel',
    },
    {
      'id': _generateId(),
      'iconData': Icons.shopping_bag_outlined,
      'iconColor': kColorPurple,
      'inputText': 'Shopping',
    },
    {
      'id': _generateId(),
      'iconData': Icons.language_outlined,
      'iconColor': kColorPink,
      'inputText': 'Internet',
    },
    {
      'id': _generateId(),
      'iconData': Icons.redeem_outlined,
      'iconColor': kColorLavender,
      'inputText': 'Gift',
    },
    {
      'id': _generateId(),
      'iconData': Icons.airplanemode_active_outlined,
      'iconColor': kColorDeepSkyBlue,
      'inputText': 'Flights',
    },
    {
      'id': _generateId(),
      'iconData': Icons.local_gas_station_outlined,
      'iconColor': kColorRust,
      'inputText': 'Petrol',
    },
    {
      'id': _generateId(),
      'iconData': Icons.local_atm_outlined,
      'iconColor': kColorAmber,
      'inputText': 'Cash Deposit',
    },
    {
      'id': _generateId(),
      'iconData': Icons.local_atm,
      'iconColor': kColorTeal,
      'inputText': 'Cash Withdrawal',
    },
  ];

  static String _generateId() {
    return Uuid().v4();
  }

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

  void addCategory(Map<String, dynamic> newCategory) {
    newCategory['id'] = _generateId();
    categories.add(newCategory);
    emit(CategoryAdded(newCategory));
  }

  void updateCategory(String categoryId, Map<String, dynamic> updatedCategory) {
    final index =
        categories.indexWhere((category) => category['id'] == categoryId);
    if (index != -1) {
      updatedCategory['id'] = categories[index]['id'];
      categories[index] = updatedCategory;
      print('Emitting CategoryUpdated with category: $updatedCategory');
      emit(CategoryUpdated(updatedCategory));
    }
  }

  void removeCategory(String categoryId) {
    final index =
        categories.indexWhere((category) => category['id'] == categoryId);
    final deletedCategory = categories[index];
    categories = categories
        .where((category) => category['id'] != deletedCategory['id'])
        .toList();
    emit(CategoryDeleted(deletedCategory['id']));
    print('Deleted category with ID: ${deletedCategory['id']}');
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
