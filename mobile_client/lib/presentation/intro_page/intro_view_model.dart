import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proriv_case/data/api/web_api.dart';
import 'package:proriv_case/data/local/database.dart';
import 'package:proriv_case/domain/product.dart';
import 'package:proriv_case/presentation/photo_page/photo_view.dart';

class IntroViewModel {
  final SharedPrefsSource sharedPrefsSource;
  final WebApi webApi;

  bool isValidated = true;

  IntroViewModel({
    required this.webApi,
    required this.sharedPrefsSource,
  });

  Future<List<Product>> select() async {
    try {
      final local = await sharedPrefsSource.getProducts();
      return local;
    } catch (e) {
      log('Error while selecting from SP: $e');
    }
    return const [];
  }

  Future<void> onPhotoTaped(BuildContext context) async {
    final res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotoView(),
      ),
    );
    log('Popped PhotoView with $res');
    if (res == null || res is! Product) {
      return;
    } else {
      sharedPrefsSource.saveProduct(res);
    }

    return;
  }
}
