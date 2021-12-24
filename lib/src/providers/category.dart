import 'package:flutter/material.dart';
import 'package:food_order_app/src/helpers/category.dart';
import 'package:food_order_app/src/models/category.dart';


class CategoryProvider with ChangeNotifier{
  CategoryServices _categoryServices = CategoryServices();
  List<CategoryModel> categories = [];

  CategoryProvider.initialize(){
    loadCategories();
  }

  loadCategories()async{
    categories = await _categoryServices.getCategories();
    notifyListeners();
  }
}