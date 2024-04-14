import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:proriv_case/domain/product.dart';

class WebApi {
  static const _base =
      'http://10.0.2.2:8000'; // TODO: change to public ip, localhost right now
  final _dio = Dio();

  Future<Product> checkImage(String path) async {
    final data = base64Encode(
      File(path).readAsBytesSync(),
    );

    final response = await _dio.post(
      '$_base/analyze-image',
      data: {
        "file": data,
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    log('response: $response');

    final decoded = response.data as Map<String, dynamic>;

    log(decoded.toString());

    decoded['imagePath'] = path;

    return Product.fromJson(
      decoded,
    );
  }
}
