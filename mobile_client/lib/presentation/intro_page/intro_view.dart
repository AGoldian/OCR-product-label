import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proriv_case/domain/product.dart';
import 'package:proriv_case/presentation/common/hint_card.dart';
import 'package:proriv_case/presentation/common/styles.dart';
import 'package:proriv_case/presentation/common/validation_card.dart';
import 'package:proriv_case/presentation/intro_page/intro_view_model.dart';
import 'package:proriv_case/presentation/search_page/search_view.dart';

class IntroView extends StatefulWidget {
  final IntroViewModel viewModel;

  const IntroView({
    required this.viewModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _IntroView();
}

class _IntroView extends State<IntroView> {
  @override
  Widget build(BuildContext context) => FutureBuilder<List<Product>>(
        future: widget.viewModel.select(),
        builder: (_, asyncResult) {
          if (asyncResult.hasError) {
            log(asyncResult.error.toString());
            return Center(
              child: Text('Error: ${asyncResult.error}'),
            );
          }
          final viewState = asyncResult.data;
          if (viewState == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final isEmpty = viewState.isEmpty;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: bgMain,
              foregroundColor: textMain,
              title: Text(
                'Проверенные продукты',
                style: context.theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textMain,
                ),
              ),
              elevation: 8,
              actions: isEmpty
                  ? []
                  : [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SearchView(
                                itemsList: viewState,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.search,
                        ),
                      ),
                    ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                await widget.viewModel.onPhotoTaped(context);
                setState(() {});
              },
              backgroundColor: pinkMain,
              foregroundColor: textMain,
              icon: const Icon(
                Icons.photo_camera,
              ),
              label: Text(
                isEmpty ? 'Проверьте свой первый продукт' : 'Проверить',
                style: context.theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textMain,
                ),
              ),
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: bgGradient,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                children: [
                  if (isEmpty)
                    const HintCard(
                      title: 'У вас еще нет проверенных продуктов',
                      text:
                          'Проверьте продукт, сфотографировав его с помощью кнопки ниже, '
                          'и узнайте подходит ли он под определенные нормы',
                    ),
                  ...viewState
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
        },
      );
}
