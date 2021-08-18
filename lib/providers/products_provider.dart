import 'package:al_asr_admin/screens/search_bar.dart';
import 'package:flutter/material.dart';

List<dynamic> productsGetList;
List<Note> productList = List<Note>();


class ProductProvider with ChangeNotifier{
  List<String> selectedColors = [];

  addColors(String color){
    selectedColors.add(color);
    print(selectedColors.length.toString());
    notifyListeners();
  }

  removeColor(String color){
    selectedColors.remove(color);
    print(selectedColors.length.toString());
    notifyListeners();
  }

}