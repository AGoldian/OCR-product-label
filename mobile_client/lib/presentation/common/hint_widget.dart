import 'package:flutter/material.dart';
import 'package:proriv_case/presentation/common/styles.dart';

class HintWidget extends StatelessWidget {
  final String title;
  final String? text;

  const HintWidget({
    required this.title,
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline,
          color: textMain,
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textMain,
                ),
              ),
              if (text != null)
                Text(
                  text!,
                  style: textTheme.bodyMedium!.copyWith(
                    color: textMinor,
                  ),
                  textAlign: TextAlign.start,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
