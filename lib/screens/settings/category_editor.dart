import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utilities/CubitsBlocs/addTransactioncubits/category_cubit.dart';
import '../../utilities/constants.dart';
import '../../utilities/icons.dart';
import '../../widgets/screen_scaffold.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoryEditor extends StatelessWidget {
  const CategoryEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryCubit = context.read<CategoryCubit>();

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
                      onPressed: () => categoryCubit.removeCategory(index),
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
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Select'),
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
        return AlertDialog(
          title: Center(
              child: Text(category != null ? 'Edit Category' : 'Add Category')),
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
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () async {
                  _showIconPicker(context, (selected) {
                    selectedIcon = selected;
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
                    SizedBox(
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
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () async {
                  _showColorPicker(context, selectedColor, (color) {
                    selectedColor = color;
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
                    SizedBox(
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
                Navigator.pop(context, newCategory);
              },
            ),
          ],
        );
      },
    );
  }
}
