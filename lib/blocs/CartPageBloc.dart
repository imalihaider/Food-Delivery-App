
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/resourese/databaseSQL.dart';
import 'package:food_delivery_app/resourese/firebase_helper.dart';
import 'package:food_delivery_app/screens/homepage.dart';

class CartPageBloc with ChangeNotifier {
  
  List<Food> foodList=[];
  int totalPrice = 0;

  FirebaseHelper mFirebaseHelper = FirebaseHelper();
  DatabaseSql databaseSql;

  BuildContext context;

  getDatabaseValue() async{
    databaseSql = DatabaseSql();
    await databaseSql.openDatabaseSql();
    foodList= await databaseSql.getData();
    //calculating total price
    foodList.forEach((food) {
      int foodItemPrice = int.parse(food.price);
      totalPrice += foodItemPrice;
    });
    notifyListeners();
  }

   // ignore: non_constant_identifier_names
  orderPlaceToFirebase(String name, String address) async {
    mFirebaseHelper.addOrder(totalPrice.toString(), foodList, name, address).then((isAdded) {  
        notifyListeners();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomePage())); 
    });
  }
}