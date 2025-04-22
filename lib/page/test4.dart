// import 'package:flutter/material.dart';
// import 'package:todolist_app/model/category.dart';
// import 'package:todolist_app/model/taskmodddel.dart';
// import 'package:todolist_app/service/categoryservice.dart';
// import 'package:todolist_app/service/tasksservice.dart';
// import 'package:todolist_app/widget/HomePage/HomeAppBar.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// class HomePage extends StatefulWidget {
//   HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final CategoryService _categoryService = CategoryService();
//   final TaskService _taskService = TaskService();
//   List<Category> categories = [];
//   List<Task> tasks = [];
//   bool isLoadingCategories = true;
//   bool isLoadingTasks = true;
  
//   // Nilai default untuk kategori baru
//   IconData selectedIcon = Icons.label;
//   Color selectedColor = Colors.blue;
//   final TextEditingController categoryNameController = TextEditingController();

//   // Map icon untuk pilihan icon di dialog
//   final Map<String, IconData> iconOptions = {
//     'work': Icons.work,
//     'Pribadi': Icons.person,
//     'Perjalanan': Icons.flight,
//     'Teknologi': Icons.computer,
//     'Rumah': Icons.home,
//     'Belanja': Icons.shopping_cart,
//     'Kesehatan': Icons.health_and_safety,
//     'Pendidikan': Icons.school,
//     'Keuangan': Icons.attach_money,
//     'Sosial': Icons.people,
//     'Hiburan': Icons.movie,
//     'Makanan': Icons.restaurant,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//     _loadTasks();
//   }

//   @override
//   void dispose() {
//     categoryNameController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadCategories() async {
//     try {
//       setState(() {
//         isLoadingCategories = true;
//       });
//       final fetchedCategories = await _categoryService.getCategories();
//       setState(() {
//         categories = fetchedCategories;
//         isLoadingCategories = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoadingCategories = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal memuat kategori: $e'))
//       );
//     }
//   }

//   // Method baru untuk memuat tasks
//   Future<void> _loadTasks() async {
//     try {
//       setState(() {
//         isLoadingTasks = true;
//       });
//       final fetchedTasks = await _taskService.getTasks();
      
//       // For each task, try to find its category from our loaded categories
//  for (var task in fetchedTasks) {
//   if (task.categoryId != null) {
//     // Find the matching category if it exists
//     final matchingCategories = categories.where((cat) => cat.id == task.categoryId);
//     if (matchingCategories.isNotEmpty) {
//       task.category = matchingCategories.first;
//     }
//   }
// }
      
//       setState(() {
//         tasks = fetchedTasks;
//         isLoadingTasks = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoadingTasks = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal memuat tugas: $e'))
//       );
//     }
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
//       // Konversi warna ke format string hex
//       String colorHex = '#${selectedColor.value.toRadixString(16).substring(2)}';
      
//       // Konversi icon ke nama string
//       String iconName = iconOptions.entries
//           .firstWhere((entry) => entry.value == selectedIcon, 
//                      orElse: () => MapEntry('label', Icons.label))
//           .key.toLowerCase();
      
//       // Gunakan ID user dari user yang sedang login
//       int userId = 1; // Ganti dengan ID user yang sebenarnya
      
//       await _categoryService.createCategory(
//         categoryNameController.text, 
//         userId, 
//         iconName, 
//         colorHex
//       );
      
//       // Refresh daftar kategori
//       await _loadCategories();
      
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
  
//   // Widget untuk menampilkan task card
//   Widget _buildTaskCard(Task task) {
//     return Material(
//       elevation: 6,
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         height: 140, // Reduced height since we removed one row
//         width: 370,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             // Task name and category
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Task name
//                 Container(
//                   margin: EdgeInsets.only(left: 15, top: 10),
//                   child: Text(
//                     task.nama, 
//                     style: TextStyle(color: Colors.black, fontFamily: "Mont-SemiBold", fontSize: 17)
//                   ),
//                 ),
//                 // Category
//                 Container(
//                   margin: EdgeInsets.only(right: 15, top: 10),
//                   child: Row(
//                     children: [
//                       Icon(
//                         task.category?.getIconData() ?? Icons.label, 
//                         color: task.category?.getColor() ?? Colors.blue
//                       ),
//                       SizedBox(width: 5),
//                       Text(
//                         task.category?.name ?? "No Category", 
//                         style: TextStyle(
//                           color: task.category?.getColor() ?? Colors.blue, 
//                           fontFamily: "Mont-SemiBold", 
//                           fontSize: 13
//                         )
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
            
//             // Priority
//             Row(
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(left: 15, top: 15),
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: task.getPriorityColor().withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: task.getPriorityColor())
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(task.getPriorityIcon(), color: task.getPriorityColor(), size: 16),
//                       SizedBox(width: 5),
//                       Text(
//                         task.priority.toUpperCase(), 
//                         style: TextStyle(
//                           color: task.getPriorityColor(), 
//                           fontFamily: "Mont-SemiBold", 
//                           fontSize: 12
//                         )
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
            
//             // Created date
//             Container(
//               margin: EdgeInsets.only(left: 15, top: 20),
//               child: Row(
//                 children: [
//                   Icon(Icons.calendar_month_outlined, color: Color.fromRGBO(56, 48, 48, 1), size: 30),
//                   SizedBox(width: 5),
//                   Text(
//                     task.getFormattedCreatedDate(), 
//                     style: TextStyle(color: Color.fromRGBO(56, 48, 48, 1), fontFamily: "Mont-SemiBold")
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(235, 235, 235, 1),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             HomeAppbar(),
//             SizedBox(height: 20),
            
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(left: 20),
//                   child: Text('Category', style: TextStyle(fontFamily: "Mont-SemiBold", color: Colors.black, fontSize: 17)),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(right: 33),
//                   child: Text('See All', style: TextStyle(fontFamily: "Mont-SemiBold", color: Color.fromRGBO(97, 119, 140, 1), fontSize: 17)),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
            
//             // Tampilkan loading atau list kategori
//             isLoadingCategories 
//               ? Center(child: CircularProgressIndicator())
//               : Container(
//                   child: Column(
//                     children: [
//                       Wrap(
//                         spacing: 45,
//                         runSpacing: 10,
//                         children: [
//                           // Tampilkan kategori yang ada
//                           ...categories.take(categories.length > 8 ? 8 : categories.length).map((cat) => Tooltip(
//                             message: cat.name,
//                             child: Container(
//                               width: 55,
//                               height: 55,
//                               decoration: BoxDecoration(
//                                 color: cat.getColor(),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(cat.getIconData(), color: Colors.white),
//                                     ],
//                                   ),   
//                                 ],
//                               ),
//                             ),
//                           )),
                          
//                           // Tampilkan tombol tambah jika kategori kurang dari 8
//                           if (categories.length < 8)
//                             Tooltip(
//                               message: "Tambah Kategori",
//                               child: InkWell(
//                                 onTap: _showAddCategoryDialog,
//                                 child: Container(
//                                   width: 55,
//                                   height: 55,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[300],
//                                     borderRadius: BorderRadius.circular(16),
//                                     border: Border.all(color: Colors.grey, width: 1),
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Icon(Icons.add, color: Colors.black54),
//                                         ],
//                                       ),   
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ]
//                       )
//                     ],
//                   ),
//                 ),
                
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 SizedBox(width: 20),
//                 Text("Task", style: TextStyle(color: Colors.black, fontFamily: "Mont-SemiBold", fontSize: 17))
//               ],
//             ),
//             SizedBox(height: 10),
            
//             // Task cards
//             isLoadingTasks
//               ? Center(child: CircularProgressIndicator())
//               : tasks.isEmpty
//                 ? Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Text("Tidak ada tugas", style: TextStyle(fontFamily: "Mont-SemiBold")),
//                     )
//                   )
//                 : ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: tasks.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 15.0),
//                         child: _buildTaskCard(tasks[index]),
//                       );
//                     },
//                   )
//           ],
//         ),
//       ),
//     );
//   }
// }