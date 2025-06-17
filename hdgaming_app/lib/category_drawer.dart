import 'package:flutter/material.dart';

class CategoryDrawer extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<int>? onCategorySelected;

  const CategoryDrawer({Key? key, required this.categories, this.onCategorySelected}) : super(key: key);

  @override
  State<CategoryDrawer> createState() => _CategoryDrawerState();
}

class _CategoryDrawerState extends State<CategoryDrawer> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final selected = index == _selectedIndex;
          return InkWell(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onCategorySelected?.call(index);
            },
            child: Container(
              color: selected ? Colors.grey.shade200 : Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 48,
                    color: selected ? Colors.red : Colors.transparent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(widget.categories[index]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
