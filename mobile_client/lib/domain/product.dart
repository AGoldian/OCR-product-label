import 'dart:convert';

import 'package:proriv_case/domain/validation_result.dart';

class Product {
  final String productName;
  final String imagePath;
  final Map<Validation, ValidationResult> validateResults;

  const Product({
    required this.productName,
    required this.validateResults,
    required this.imagePath,
  });

  factory Product.fromJson(Map<String, dynamic> jsonData) => Product(
        productName: jsonData['productName'],
        validateResults: ((jsonData['validateResults'] is String
                ? jsonDecode(jsonData['validateResults'])
                : jsonData['validateResults']) as Map<String, dynamic>)
            .map(
          (String key, value) => MapEntry(
            key.asValidation,
            ValidationResult.fromJson(value),
          ),
        ),
        imagePath: jsonData['imagePath'],
      );

  Map<String, dynamic> toMap() => {
        'productName': productName,
        'validateResults': jsonEncode(
          validateResults.map(
            (key, value) => MapEntry(
              key.toString(),
              value.toMap(),
            ),
          ),
        ),
        'imagePath': imagePath,
      };
}
