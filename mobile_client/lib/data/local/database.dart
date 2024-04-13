import 'dart:convert';
import 'dart:developer';

import 'package:proriv_case/domain/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsSource {
  bool isInitialized = false;

  late final SharedPreferences prefs;

  Future<void> initialize() async {
    if (isInitialized) {
      return;
    }

    prefs = await SharedPreferences.getInstance();

    isInitialized = true;
  }

  Future<bool> saveProduct(Product product) async {
    await initialize();
    return prefs.setString(
        product.hashCode.toString(), json.encode(product.toMap()));
  }

  Future<List<Product>> getProducts() async {
    await initialize();
    final keys = prefs.getKeys();
    log('keys from SP: $keys');

    final products = keys.map((key) {
      log('decoding ${json.decode(
        prefs.getString(key)!,
      )}');
      return Product.fromJson(
        json.decode(
          prefs.getString(key)!,
        ),
      );
    }).toList();
    log('products from SP: $products');

    return products;
  }
}
