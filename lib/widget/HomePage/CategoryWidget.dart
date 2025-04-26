// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todolist_app/model/category.dart';
import 'package:todolist_app/page/CategoryPage.dart';
import 'package:todolist_app/service/categoryservice.dart';
import 'dart:convert';

class CategoryWidget extends StatefulWidget {
  final String token;
  final List<Category> categories;
  final Function refreshCategories;
  final bool isLoading;

  const CategoryWidget({
    Key? key,
    required this.token,
    required this.categories,
    required this.refreshCategories,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late String _token;

  final CategoryService _categoryService = CategoryService();

  // Nilai default untuk kategori baru

  final TextEditingController categoryNameController = TextEditingController();

  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _token = widget.token;
  }

  // Method untuk menampilkan dialog pembuatan kategori
// Method untuk menampilkan dialog pembuatan kategori
  void showAddCategoryDialog() {
    TextEditingController categoryNameController = TextEditingController();
    String selectedIcon = 'label';
    Color selectedColor = Colors.blue;

    final iconChoices = {
      'work': Icons.work,
      'person': Icons.person,
      'flight': Icons.flight,
      'computer': Icons.computer,
      'home': Icons.home,
      'shopping_cart': Icons.shopping_cart,
      'health_and_safety': Icons.health_and_safety,
      'school': Icons.school,
      'attach_money': Icons.attach_money,
      'people': Icons.people,
      'movie': Icons.movie,
      'restaurant': Icons.restaurant,
      'label': Icons.label,
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Tambah Kategori'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: categoryNameController,
                      decoration: InputDecoration(labelText: 'Nama Kategori'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedIcon,
                      decoration: InputDecoration(labelText: 'Pilih Icon'),
                      items: iconChoices.keys.map((iconName) {
                        return DropdownMenuItem<String>(
                          value: iconName,
                          child: Row(
                            children: [
                              Icon(iconChoices[iconName]),
                              SizedBox(width: 10),
                              Text(iconName),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedIcon = value!;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Text('Pilih Warna'),
                    BlockPicker(
                      pickerColor: selectedColor,
                      onColorChanged: (color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Batal')),
                ElevatedButton(
                  onPressed: () async {
                    final name = categoryNameController.text.trim();
                    final icon = selectedIcon;
                    final color =
                        '#${selectedColor.value.toRadixString(16).substring(2)}'; // hex color

                    try {
                      // Menyimpan kategori
                      await _categoryService.createCategory(
                          name, widget.token, icon, color);

                      // Menutup dialog setelah data berhasil ditambahkan
                      Navigator.pop(context);

                      // Memperbarui kategori setelah kategori baru berhasil dibuat
                      widget.refreshCategories();
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        widget.isLoading
            ?Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 45,
                runSpacing: 10,
                children: List.generate(8, (index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                }),
              ),
            )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Wrap(spacing: 45, runSpacing: 10, children: [
                      ...widget.categories
                          .take(widget.categories.length > 8
                              ? 8
                              : widget.categories.length)
                          .map((cat) => Tooltip(
                                message: cat.name,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CategoryPage(
                                          token: widget.token,
                                          initialCategoryId: cat.id, 
                                        ),
                                      ),
                                    ).then((value) {
                                     
                                      if (value == true) {
                                        widget.refreshCategories();
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: cat.getColor(),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(cat.getIconData(),
                                                color: Colors.white),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),

                      if (widget.categories.length < 8)
                        Tooltip(
                          message: "Tambah Kategori",
                          child: InkWell(
                            onTap: showAddCategoryDialog,
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, color: Colors.black54),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ])
                  ],
                ),
              ),
      ],
    );
  }
}
