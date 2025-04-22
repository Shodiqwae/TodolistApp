// // TODO Implement this library.import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:todolist_app/model/category.dart';
// import 'package:todolist_app/service/categoryservice.dart';

// class CategoryWidget extends StatefulWidget {
//   final String token;
//   final List<Category> categories;
//   final Function refreshCategories;
//   final bool isLoading;

//   const CategoryWidget({
//     Key? key,
//     required this.token,
//     required this.categories,
//     required this.refreshCategories,
//     required this.isLoading,
//   }) : super(key: key);

//   @override
//   State<CategoryWidget> createState() => _CategoryWidgetState();
// }

// class _CategoryWidgetState extends State<CategoryWidget> {
//   final CategoryService _categoryService = CategoryService();
  
//   // Nilai default untuk kategori baru
//   IconData selectedIcon = Icons.label;
//   Color selectedColor = Colors.blue;
//   final TextEditingController categoryNameController = TextEditingController();

//   // Map icon untuk pilihan icon di dialog
//   final Map<String, IconData> iconOptions = {
//     'work': Icons.work,
//     'person': Icons.person,
//     'flight': Icons.flight,
//     'computer': Icons.computer,
//     'home': Icons.home,
//     'shopping_cart': Icons.shopping_cart,
//     'health_and_safety': Icons.health_and_safety,
//     'school': Icons.school,
//     'attach_money': Icons.attach_money,
//     'people': Icons.people,
//     'movie': Icons.movie,
//     'restaurant': Icons.restaurant,
//     'label': Icons.label, 
//   };

//   @override
//   void dispose() {
//     categoryNameController.dispose();
//     super.dispose();
//   }

//   // Method untuk membuat kategori baru
//   Future<void> _createCategory() async {
//     if (categoryNameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Nama kategori tidak boleh kosong'))
//       );
//       return;
//     }

//     try {
//       // Make sure token is valid
//       if (widget.token.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Token tidak valid, silakan login ulang'))
//         );
//         return;
//       }
      
//       // Debug token before calling API
//       print('Using token for creation: ${widget.token}');
      
//       // Konversi warna ke format string hex
//       String colorHex = '#${selectedColor.value.toRadixString(16).substring(2)}';
      
//       // Konversi icon ke nama string
//       String iconName = iconOptions.entries
//         .firstWhere((entry) => entry.value == selectedIcon, 
//                   orElse: () => MapEntry('label', Icons.label))
//         .key.toLowerCase();
      
//       // Call API to create category
//       await _categoryService.createCategory(
//         categoryNameController.text, 
//         widget.token,
//         iconName, 
//         colorHex
//       );
      
//       // Refresh daftar kategori
//       await widget.refreshCategories();
      
//       // Reset nilai input
//       categoryNameController.clear();
//       selectedIcon = Icons.label;
//       selectedColor = Colors.blue;
      
//       // Tutup dialog
//       Navigator.of(context).pop();
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Kategori berhasil dibuat'))
//       );
//     } catch (e) {
//       print('Error creating category: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal membuat kategori: $e'))
//       );
//     }
//   }

//   // Method untuk menampilkan dialog pembuatan kategori
//   void _showAddCategoryDialog() {
//     // Reset nilai input setiap kali dialog dibuka
//     setState(() {
//       selectedIcon = Icons.label;
//       selectedColor = Colors.blue;
//       categoryNameController.clear();
//     });
    
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               title: Text('Tambah Kategori'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: categoryNameController,
//                       decoration: InputDecoration(
//                         labelText: 'Nama Kategori',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Icon:'),
//                         InkWell(
//                           onTap: () {
//                             // Pilih icon dalam dialog yang sama tanpa menutup dialog utama
//                             _selectIcon(context, setDialogState);
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Icon(selectedIcon, size: 30),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Warna:'),
//                         InkWell(
//                           onTap: () {
//                             // Pilih warna dalam dialog yang sama tanpa menutup dialog utama
//                             _selectColor(context, setDialogState);
//                           },
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: selectedColor,
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('Batal'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 TextButton(
//                   child: Text('Simpan'),
//                   onPressed: () {
//                     _createCategory();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   // Method untuk memilih icon dengan pendekatan yang lebih baik
//   void _selectIcon(BuildContext context, StateSetter setDialogState) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Pilih Icon'),
//           content: Container(
//             width: double.maxFinite,
//             child: GridView.builder(
//               shrinkWrap: true,
//               itemCount: iconOptions.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 mainAxisSpacing: 10,
//                 crossAxisSpacing: 10,
//               ),
//               itemBuilder: (context, index) {
//                 String key = iconOptions.keys.elementAt(index);
//                 IconData iconData = iconOptions[key]!;
//                 return InkWell(
//                   onTap: () {
//                     // Update icon yang dipilih menggunakan StateSetter
//                     setDialogState(() {
//                       selectedIcon = iconData;
//                     });
//                     // Update juga state utama
//                     setState(() {
//                       selectedIcon = iconData;
//                     });
//                     Navigator.of(context).pop();
//                   },
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(iconData, size: 30),
//                       SizedBox(height: 5),
//                       Text(key, style: TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Method untuk memilih warna dengan pendekatan yang lebih baik
//   void _selectColor(BuildContext context, StateSetter setDialogState) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         Color pickerColor = selectedColor;
//         return AlertDialog(
//           title: Text('Pilih Warna'),
//           content: SingleChildScrollView(
//             child: ColorPicker(
//               pickerColor: pickerColor,
//               onColorChanged: (Color color) {
//                 pickerColor = color;
//               },
//               pickerAreaHeightPercent: 0.8,
//               displayThumbColor: true,
//               enableAlpha: false,
//               paletteType: PaletteType.hsv,
//               pickerAreaBorderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(2),
//                 topRight: Radius.circular(2),
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Batal'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Pilih'),
//               onPressed: () {
//                 // Update warna yang dipilih menggunakan StateSetter
//                 setDialogState(() {
//                   selectedColor = pickerColor;
//                 });
//                 // Update juga state utama
//                 setState(() {
//                   selectedColor = pickerColor;
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               margin: EdgeInsets.only(left: 20),
//               child: Text(
//                 'Category', 
//                 style: TextStyle(fontFamily: "Mont-SemiBold", color: Colors.black, fontSize: 17)
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
        
//         // Tampilkan loading atau list kategori
//         widget.isLoading 
//           ? Center(child: CircularProgressIndicator())
//           : Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   Wrap(
//                     spacing: 45,
//                     runSpacing: 10,
//                     children: [
//                       // Tampilkan kategori yang ada
//                       ...widget.categories.take(widget.categories.length > 8 ? 8 : widget.categories.length).map((cat) => Tooltip(
//                         message: cat.name,
//                         child: Container(
//                           width: 55,
//                           height: 55,
//                           decoration: BoxDecoration(
//                             color: cat.getColor(),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(cat.getIconData(), color: Colors.white),
//                                 ],
//                               ),   
//                             ],
//                           ),
//                         ),
//                       )),
                      
//                       // Tampilkan tombol tambah jika kategori kurang dari 8
//                       if (widget.categories.length < 8)
//                         Tooltip(
//                           message: "Tambah Kategori",
//                           child: InkWell(
//                             onTap: _showAddCategoryDialog,
//                             child: Container(
//                               width: 55,
//                               height: 55,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(16),
//                                 border: Border.all(color: Colors.grey, width: 1),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(Icons.add, color: Colors.black54),
//                                     ],
//                                   ),   
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                     ]
//                   )
//                 ],
//               ),
//             ),
//       ],
//     );
//   }
// }