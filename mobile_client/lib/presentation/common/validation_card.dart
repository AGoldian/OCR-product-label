import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proriv_case/domain/product.dart';
import 'package:proriv_case/presentation/common/styles.dart';

class ValidationCard extends StatelessWidget {
  final Product product;

  const ValidationCard({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Card(
      color: bgMain,
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 120,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: textTheme.titleMedium!.copyWith(color: textMain),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Divider(),
                  ),
                  ...product.validateResults.values.map((value) {
                    final Color iconColor;
                    final IconData iconData;
                    if (!value.isOk) {
                      iconData = Icons.block;
                      iconColor = Colors.red;
                    } else {
                      iconData = Icons.check;
                      iconColor = Colors.green;
                    }
                    return Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Icon(
                            iconData,
                            color: iconColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          value.validationTitle,
                          style: textTheme.bodyMedium!.copyWith(
                            color: textMain,
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
            Image.file(
              File(
                product.imagePath,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
