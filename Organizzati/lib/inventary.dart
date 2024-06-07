/// FILEPATH: /Users/titan5g/Downloads/Organizzati!/lib/inventary.dart
/// 
/// This file contains the implementation of the `RectangleData` class and the `InventoryProvider` class.
/// 
/// The `RectangleData` class represents a rectangle object with properties such as name, itemCount, totalValue, isExpanded, and id.
/// It also provides methods to convert the object to a map and create an object from a map.
/// 
/// The `InventoryProvider` class is a provider class that manages a list of `RectangleData` objects.
/// It provides methods to add, remove, and modify rectangles in the list.
/// It also handles the persistence of the list using shared preferences.
/// 
/// The `InventoryScreen` class is a stateless widget that displays the inventory screen.
/// It uses the `Consumer` widget from the `provider` package to listen to changes in the `InventoryProvider` and rebuild the UI accordingly.
/// The screen displays a list of rectangles, and each rectangle can be expanded or collapsed by tapping on it.
/// The screen also provides buttons to add new rectangles and increment/decrement the total value of a rectangle.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class RectangleData {
 String name;
 int itemCount;
 int totalValue;
 bool isExpanded;
 int id;

 RectangleData({
   required this.name,
   this.itemCount = 0,
   this.totalValue = 20,
   this.isExpanded = false,
   required this.id,
 });

 Map<String, dynamic> toMap() {
   return {
     'name': name,
     'itemCount': itemCount,
     'totalValue': totalValue,
     'isExpanded': isExpanded,
     'id': id,
   };
 }


 factory RectangleData.fromMap(Map<String, dynamic> map) {
   return RectangleData(
     name: map['name'],
     itemCount: map['itemCount'],
     totalValue: map['totalValue'],
     isExpanded: map['isExpanded'],
     id: map['id'],
   );
 }
}

class InventoryProvider with ChangeNotifier {
 List<RectangleData> _rectangles = [];
 Map<int, TextEditingController> _controllers = {};
 int _currentId = 0;

 InventoryProvider() {
   loadRectangles();
 }

 List<RectangleData> get rectangles => _rectangles;

 Future<void> saveRectangles() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   List<String> rectanglesStringList = _rectangles.map((rect) => json.encode(rect.toMap())).toList();
   prefs.setStringList('rectangles', rectanglesStringList);
   prefs.setInt('currentId', _currentId);
 }

 Future<void> loadRectangles() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   List<String>? rectanglesStringList = prefs.getStringList('rectangles');
   if (rectanglesStringList != null) {
     _rectangles = rectanglesStringList.map((str) => RectangleData.fromMap(json.decode(str))).toList();
     for (var rect in _rectangles) {
       _controllers[rect.id] = TextEditingController(text: rect.name);
     }
   }
   _currentId = prefs.getInt('currentId') ?? 0;
   notifyListeners();
 }

 void incrementItem() {
   var newRectangle = RectangleData(name: 'Object ${_currentId + 1}', id: _currentId);
   _rectangles.add(newRectangle);
   _controllers[newRectangle.id] = TextEditingController(text: newRectangle.name);
   _currentId++;
   saveRectangles();
   notifyListeners();
 }

 void incrementCounter(int index) {
   if (_rectangles[index].totalValue - _rectangles[index].itemCount > 0) {
     _rectangles[index].itemCount++;
     saveRectangles();
     notifyListeners();
   }
 }

 void decrementCounter(int index) {
   if (_rectangles[index].itemCount > 0) {
     _rectangles[index].itemCount--;
     saveRectangles();
     notifyListeners();
   }
 }

 void removeItem(int index) {
   _controllers[_rectangles[index].id]?.dispose();
   _controllers.remove(_rectangles[index].id);
   _rectangles.removeAt(index);
   saveRectangles();
   notifyListeners();
 }

 void incrementTotalValue(int index) {
   _rectangles[index].totalValue++;
   saveRectangles();
   notifyListeners();
 }

 void decrementTotalValue(int index) {
   if (_rectangles[index].totalValue > 0) {
     _rectangles[index].totalValue--;
     saveRectangles();
     notifyListeners();
   }
 }

 void toggleExpand(int index) {
   _rectangles[index].isExpanded = !_rectangles[index].isExpanded;
   saveRectangles();
   notifyListeners();
 }
}
















class InventoryScreen extends StatelessWidget {
 const InventoryScreen({Key? key}) : super(key: key);
















 @override
 Widget build(BuildContext context) {
   return Consumer<InventoryProvider>(
     builder: (context, inventoryProvider, child) {
       return Scaffold(
         appBar: AppBar(
           title: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               const Text(
                 'Storage',
                 style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
               ),
               ElevatedButton(
                 onPressed: inventoryProvider.incrementItem,
                 child: const Text(
                   '+',
                   style: TextStyle(
                    color: const Color.fromARGB(255, 35, 158, 219),
                    fontSize: 20, fontWeight: FontWeight.bold),
                 ),
                 style: ElevatedButton.styleFrom(
                   shape: const CircleBorder(),
                 ),
               ),
             ],
           ),
         ),
         body: SingleChildScrollView(
           child: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: inventoryProvider.rectangles.map((rectangle) {
                 int index = inventoryProvider.rectangles.indexOf(rectangle);
                 return GestureDetector(
                   onTap: () => inventoryProvider.toggleExpand(index),
                   child: AnimatedContainer(
                     duration: const Duration(milliseconds: 300),
                     width: 340,
                     height: rectangle.isExpanded ? 150 : 70,
                     margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color.fromARGB(255, 77, 244, 166),
                            const Color.fromARGB(124, 152, 248, 248),
                            // Colore iniziale
                              // Colore finale
                            ],
                          ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 125, 123, 123).withOpacity(0.5), // Colore dell'ombra
                            spreadRadius: 2, // Diffusione dell'ombra
                            blurRadius: 7, // Sfocatura dell'ombra
                            offset: Offset(0, 5), // Posizione dell'ombra
                          ),
                        ],
                      ),
                     child: Stack(
                       children: [
                         Positioned(
                           top: 9,
                           left: 16,
                           child: SizedBox(
                             width: 150,
                             child: TextFormField(
                               controller: inventoryProvider._controllers[rectangle.id],
                               onChanged: (value) {
                                 rectangle.name = value;
                                 inventoryProvider.saveRectangles();
                               },
                               style: const TextStyle(
                                 fontSize: 20,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black,
                               ),
                               decoration: const InputDecoration(
                                 border: InputBorder.none,
                               ),
                             ),
                           ),
                         ),
                         if (rectangle.isExpanded)
                           Positioned(
                             top: 50,
                             left: 16,
                             child: Text(
                               'Used: ${rectangle.itemCount}',
                               style: const TextStyle(
                                 fontSize: 16,
                               ),
                             ),
                           ),
                         if (rectangle.isExpanded)
                           Positioned(
                             top: 70,
                             left: 16,
                             child: Text(
                               'Unused: ${rectangle.totalValue - rectangle.itemCount}',
                               style: const TextStyle(
                                 fontSize: 16,
                               ),
                             ),
                           ),
                         if (rectangle.isExpanded)
                           Positioned(
                             top: 90,
                             left: 16,
                             child: Text(
                               'Total: ${rectangle.totalValue}',
                               style: const TextStyle(
                                 fontSize: 16,
                               ),
                             ),
                           ),
                         if (rectangle.isExpanded)
                           Positioned(
                             top: 9,
                             right: 38,
                             child: IconButton(
                               onPressed: () => inventoryProvider.incrementTotalValue(index),
                               icon: const Icon(Icons.arrow_forward_ios_rounded),
                             ),
                           ),
                         if (rectangle.isExpanded)
                           Positioned(
                             top: 9,
                             right: 78,
                             child: IconButton(
                               onPressed: () => inventoryProvider.decrementTotalValue(index),
                               icon: const Icon(Icons.arrow_back_ios_new_rounded),
                             ),
                           ),
                         Positioned(
                           top: rectangle.isExpanded ? 9 : 9,
                           right: 8,
                           child: IconButton(
                             onPressed: () => inventoryProvider.removeItem(index),
                             icon: const Icon(Icons.delete),
                             color: Colors.black,
                           ),
                         ),
                       ],
                     ),
                   ),
                 );
               }).toList(),
             ),
           ),
         ),
       );
     },
   );
 }
}
