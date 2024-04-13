import 'package:flutter/material.dart';
import 'package:proriv_case/domain/product.dart';
import 'package:proriv_case/presentation/common/styles.dart';
import 'package:proriv_case/presentation/common/validation_card.dart';

class SearchView extends StatefulWidget {
  final List<Product> itemsList;

  const SearchView({
    required this.itemsList,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SearchView();
}

class _SearchView extends State<SearchView> {
  List<Product> _selected = [];

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: textMain,
        backgroundColor: bgMain,
        title: TextField(
          style: textTheme.bodyLarge!.copyWith(
            color: textMain,
          ),
          decoration: InputDecoration(
            hintText: 'Введите название продукта',
            hintStyle: textTheme.bodyLarge!.copyWith(
              color: textMain,
            ),
          ),
          onChanged: (input) {
            if (input.length >= 3) {
              _selected = widget.itemsList
                  .where(
                    (element) => element.productName.toLowerCase().contains(
                          input.toLowerCase(),
                        ),
                  )
                  .toList();
            } else {
              _selected = [];
            }
            setState(() {});
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: bgGradient),
        child: ListView(
          children: [
            ..._selected
                .map(
                  (el) => [
                    ValidationCard(
                      product: el,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
                .expand((el) => el),
          ],
        ),
      ),
    );
  }
}
