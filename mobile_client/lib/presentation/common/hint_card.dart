import 'package:flutter/material.dart';
import 'package:proriv_case/presentation/common/hint_widget.dart';
import 'package:proriv_case/presentation/common/styles.dart';

class HintCard extends StatelessWidget {
  final Color color;
  final String title;
  final String? text;
  final void Function()? onClose;

  const HintCard({
    required this.title,
    this.text,
    this.color = bgMain,
    this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 8,
      child: Stack(
        children: [
          if (onClose != null)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: onClose,
              ),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            child: HintWidget(
              title: title,
              text: text,
            ),
          ),
        ],
      ),
    );
  }
}
