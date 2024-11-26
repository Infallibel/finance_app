import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utilities/CubitsBlocs/addTransactioncubits/category_cubit.dart';
import '../../utilities/CubitsBlocs/addTransactioncubits/transaction_data_cubit.dart';
import '../../utilities/constants.dart';
import '../../utilities/icons.dart';
import '../../widgets/screen_scaffold.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoryEditor extends StatelessWidget {
  const CategoryEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryCubit = context.watch<CategoryCubit>();
    final transactionDataCubit = context.watch<TransactionDataCubit>();

    return ScreenScaffold(
      appBarTitle: 'Edit Categories',
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.clear_outlined,
          color: kColorGrey2,
        ),
      ),
      scaffoldBody: ListView.builder(
        itemCount: categoryCubit.categories.length,
        itemBuilder: (context, index) {
          final category = categoryCubit.categories[index];
          return ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(
                category['iconData'],
                color: category['iconColor'],
                size: 30,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      category['inputText'],
                      style: kFontStyleLato.copyWith(
                        fontSize: 16,
                        color: kColorGrey3,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: kColorGrey2,
                      ),
                      onPressed: () => _editCategory(context, index, category),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: kColorGrey2,
                      ),
                      onPressed: () {
                        _confirmAndDeleteCategory(
                          context,
                          categoryCubit,
                          transactionDataCubit,
                          index,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kColorBlue,
        focusColor: kColorLightBlue,
        elevation: 0,
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          size: 35,
          color: kColorWhite,
        ),
        onPressed: () => _addCategory(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _confirmAndDeleteCategory(
      BuildContext context,
      CategoryCubit categoryCubit,
      TransactionDataCubit transactionDataCubit,
      int index) {
    final category = categoryCubit.categories[index];
    final categoryId = category['id'];

    final isCategoryAssigned = transactionDataCubit.state.any((transaction) {
      return transaction.categoryId == categoryId;
    });

    if (isCategoryAssigned) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This category cannot be deleted as it is assigned to one or more transactions.',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Are you sure you want to delete this category?',
            style: kFontStyleLato.copyWith(fontSize: 20, color: kColorGrey3),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(kColorBlue),
                overlayColor: WidgetStateProperty.all(kColorLightBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: kFontStyleLato.copyWith(color: kColorWhite),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(kColorWarning),
                overlayColor: WidgetStateProperty.all(kColorLightWarning),
              ),
              onPressed: () {
                categoryCubit.removeCategory(index);
                Navigator.of(context).pop();
              },
              child: Text(
                'Yes',
                style: kFontStyleLato.copyWith(color: kColorWhite),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addCategory(BuildContext context) async {
    final newCategory = await _showCategoryDialog(context);
    if (newCategory != null && context.mounted) {
      context.read<CategoryCubit>().addCategory(newCategory);
    }
  }

  void _editCategory(BuildContext context, int index,
      Map<String, dynamic> currentCategory) async {
    final updatedCategory = await _showCategoryDialog(context, currentCategory);
    if (updatedCategory != null && context.mounted) {
      context.read<CategoryCubit>().updateCategory(index, updatedCategory);
    }
  }

  Future<void> _showIconPicker(
      BuildContext context, void Function(IconData) onIconSelected) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: availableIcons.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onIconSelected(availableIcons[index]);
                Navigator.pop(context);
              },
              child: Icon(
                availableIcons[index],
                size: 30,
                color: kColorGrey3,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showColorPicker(BuildContext context, Color initialColor,
      void Function(Color) onColorSelected) async {
    Color pickerColor = initialColor;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: kFontStyleLato.copyWith(color: kColorBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Select',
                style: kFontStyleLato.copyWith(color: kColorBlue),
              ),
              onPressed: () {
                onColorSelected(pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _showCategoryDialog(BuildContext context,
      [Map<String, dynamic>? category]) async {
    final textController = TextEditingController(
      text: category != null ? category['inputText'] : '',
    );
    IconData selectedIcon = category?['iconData'] ?? Icons.category;
    Color selectedColor = category?['iconColor'] ?? kColorGreen;

    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                  child: Text(
                      category != null ? 'Edit Category' : 'Add Category')),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    textAlign: TextAlign.center,
                    controller: textController,
                    decoration: const InputDecoration(
                      focusColor: kColorBlue,
                      hintText: 'Category Name',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: kColorBlue)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kColorBlue)),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _showIconPicker(context, (selected) {
                        setState(() {
                          selectedIcon = selected;
                        });
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          selectedIcon,
                          color: kColorGrey3,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          category != null ? 'Change Icon' : 'Pick Icon',
                          style: kFontStyleLato
                              .copyWith(color: kColorGrey3)
                              .copyWith(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _showColorPicker(context, selectedColor, (color) {
                        setState(() {
                          selectedColor = color;
                        });
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          selectedIcon,
                          color: selectedColor,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          category != null ? 'Change Color' : 'Pick Color',
                          style: kFontStyleLato
                              .copyWith(color: selectedColor)
                              .copyWith(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: kFontStyleLato.copyWith(color: kColorBlue),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text(
                    'Save',
                    style: kFontStyleLato.copyWith(color: kColorBlue),
                  ),
                  onPressed: () {
                    final newCategory = {
                      'iconData': selectedIcon,
                      'iconColor': selectedColor,
                      'inputText': textController.text,
                    };
                    if (newCategory.containsValue('')) {
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please fill all the details',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    } else {
                      Navigator.pop(context, newCategory);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
