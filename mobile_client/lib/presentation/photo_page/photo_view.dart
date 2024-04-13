import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proriv_case/di/singletones.dart';
import 'package:proriv_case/presentation/common/hint_card.dart';
import 'package:proriv_case/presentation/common/styles.dart';

class PhotoView extends StatelessWidget {
  final picker = ImagePicker();

  PhotoView({
    super.key,
  });

  Future<void> loadPhoto(BuildContext context, ImageSource source) async {
    final image = await picker.pickImage(source: source);
    if (image != null) {
      try {
        final res = await webApi.checkImage(image.path);
        log('checked image: $res');
        Navigator.of(context).pop(res);
      } catch (e) {
        log('Error on checking image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgMain,
        foregroundColor: textMain,
        title: Text(
          'Сфотографируйте товар',
          style: textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w500,
            color: textMain,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: bgGradient,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            Text(
              'Вот несколько полезных советов, чтобы проверка сработала быстрее:',
              style: textTheme.bodyLarge!
                  .copyWith(color: textMain, fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 12,
            ),
            const HintCard(
              title: 'Товар должен находиться напротив камеры и не бличить',
            ),
            const HintCard(
              title: 'На фотографию должна попасть этикетка полностью',
            ),
            const HintCard(
              title: 'Продукт должен занимать не меньше 80% изображения',
            ),
            const Expanded(child: SizedBox()),
            MaterialButton(
              onPressed: () => loadPhoto(context, ImageSource.camera),
              color: pinkMain,
              minWidth: double.infinity,
              height: 56,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.camera_alt,
                    color: textMain,
                  ),
                  Expanded(
                    child: Text(
                      'Сфотографировать',
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: textMain,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Opacity(
                    opacity: 0,
                    child: Icon(
                      Icons.camera_alt,
                      color: textMain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            MaterialButton(
              onPressed: () => loadPhoto(context, ImageSource.gallery),
              color: greenMain,
              minWidth: double.infinity,
              height: 56,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.collections,
                    color: textInverted,
                  ),
                  Expanded(
                    child: Text(
                      'Выбрать из галлереи',
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: textInverted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Opacity(
                    opacity: 0,
                    child: Icon(
                      Icons.camera_alt,
                      color: textInverted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
