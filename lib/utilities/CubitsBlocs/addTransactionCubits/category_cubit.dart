import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_combined.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final int index;
  CategoryUpdated(this.category, this.index);
}

class CategoryDeleted extends CategoryState {
  final int index;
  CategoryDeleted(this.index);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(InitialCategoryState());

  List<Map<String, dynamic>> categories = [
    {
      'iconData': Icons.money_outlined,
      'iconColor': kColorGreen,
      'inputText': 'Salary',
    },
    {
      'iconData': Icons.house_outlined,
      'iconColor': kColorOlive,
      'inputText': 'Household',
    },
    {
      'iconData': Icons.shopping_cart_outlined,
      'iconColor': kColorOrange,
      'inputText': 'Grocery',
    },
    {
      'iconData': Icons.health_and_safety_outlined,
      'iconColor': kColorTurquoise,
      'inputText': 'Health',
    },
    {
      'iconData': Icons.extension_outlined,
      'iconColor': kColorCoral,
      'inputText': 'Entertainment',
    },
    {
      'iconData': Icons.coffee_outlined,
      'iconColor': kColorBrown,
      'inputText': 'Coffee',
    },
    {
      'iconData': Icons.restaurant_outlined,
      'iconColor': kColorSoftRed,
      'inputText': 'Restaurant',
    },
    {
      'iconData': Icons.local_taxi_outlined,
      'iconColor': kColorYellow,
      'inputText': 'Taxi',
    },
    {
      'iconData': Icons.bed_outlined,
      'iconColor': kColorOliveGreen,
      'inputText': 'Hotel',
    },
    {
      'iconData': Icons.shopping_bag_outlined,
      'iconColor': kColorPurple,
      'inputText': 'Shopping',
    },
    {
      'iconData': Icons.language_outlined,
      'iconColor': kColorPink,
      'inputText': 'Internet',
    },
    {
      'iconData': Icons.redeem_outlined,
      'iconColor': kColorLavender,
      'inputText': 'Gift',
    },
    {
      'iconData': Icons.airplanemode_active_outlined,
      'iconColor': kColorDeepSkyBlue,
      'inputText': 'Flights',
    },
    {
      'iconData': Icons.local_gas_station_outlined,
      'iconColor': kColorRust,
      'inputText': 'Petrol',
    },
    {
      'iconData': Icons.local_atm_outlined,
      'iconColor': kColorAmber,
      'inputText': 'Cash Deposit',
    },
    {
      'iconData': Icons.local_atm,
      'iconColor': kColorTeal,
      'inputText': 'Cash Withdrawal',
    },
  ];

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
    categories.add(newCategory);
    emit(CategoryAdded(newCategory));
  }

  void updateCategory(int index, Map<String, dynamic> updatedCategory) {
    categories[index] = updatedCategory;
    emit(CategoryUpdated(updatedCategory, index));
  }

  void removeCategory(int index) {
    categories.removeAt(index);
    emit(CategoryDeleted(index));
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
