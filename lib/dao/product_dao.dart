import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:products/database/db_firestore.dart';
import 'package:products/utils/replace_accents.dart';

final dataBase = DBFirestore.get();
final CollectionReference _productss = dataBase.collection('products');

class ProductDao {
  // Deleteing a product by id
  Future<void> deleteProduct(BuildContext context, String productId) async {
    try {
      await _productss.doc(productId).delete();
    } catch (error) {
      throw Exception();
    }
  }

  // Persist a new product to Firestore
  Future<void> insertProduct(String name, String? detailedName, double balance,
      bool active, String? user) async {
    String lowerCaseName = name.toLowerCase();
    lowerCaseName = replaceAccents(lowerCaseName);
    Timestamp dataTimestamp = Timestamp.fromDate(DateTime.now());

    try {
      await _productss.add({
        "name": name,
        "lowercasename": lowerCaseName,
        "balance": balance,
        "active": active,
        "user": user,
        "last_update_date": dataTimestamp,
        "detailed_name": detailedName
      });
    } catch (error) {
      throw Exception();
    }
  }

  // Update the product
  Future<void> updateProduct(String name, String? detailedName, double balance,
      bool active, String? user, DocumentSnapshot? documentSnapshot) async {
    String lowerCaseName = name.toLowerCase();
    lowerCaseName = replaceAccents(lowerCaseName);
    Timestamp dataTimestamp = Timestamp.fromDate(DateTime.now());

    try {
      await _productss.doc(documentSnapshot!.id).update({
        "name": name,
        "lowercasename": lowerCaseName,
        "balance": balance,
        "active": active,
        "user": user,
        "last_update_date": dataTimestamp,
        "detailed_name": detailedName
      });
    } catch (error) {
      throw Exception();
    }
  }

  // Future<CollectionReference> selectProducts(String filter) {
  //   if (filter != '') {
  //     return _productss
  //         .orderBy('lowercasename')
  //         .where('lowercasename', isGreaterThanOrEqualTo: filter.toLowerCase())
  //         .snapshots();
  //   } else {
  //     return productss.orderBy('lowercasename').snapshots();
  //   }
  // }
}
