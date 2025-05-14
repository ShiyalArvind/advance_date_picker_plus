import 'package:flutter/material.dart';

import 'picker_plus_leading_date.dart';

class PickerPlusHeader extends StatelessWidget {
  const PickerPlusHeader({
    super.key,
    required this.displayedDate,
    required this.onDateTap,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.slidersColor,
    required this.slidersSize,
    required this.leadingDateTextStyle,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel,
    this.nextPageSemanticLabel,
  });

  final String displayedDate;
  final TextStyle leadingDateTextStyle;
  final VoidCallback onDateTap;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final Color slidersColor;
  final double slidersSize;
  final bool centerLeadingDate;
  final String? previousPageSemanticLabel;
  final String? nextPageSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final forwardButton = GestureDetector(
      onTap: onNextPage,
      child: SizedBox(
        width: 36,
        height: 36,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: slidersSize,
            color: slidersColor,
          ),
        ),
      ),
    );

    final backButton = GestureDetector(
      onTap: onPreviousPage,
      child: SizedBox(
        width: 36,
        height: 36,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: slidersSize,
            color: slidersColor,
          ),
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (centerLeadingDate) backButton,
        PickerPlusFusionLeadingDate(
          onTap: onDateTap,
          displayedText: displayedDate,
          displayedTextStyle: leadingDateTextStyle,
        ),
        if (centerLeadingDate)
          forwardButton
        else
          Row(
            children: [
              backButton,
              const SizedBox(width: 10),
              forwardButton,
            ],
          ),
      ],
    );
  }
}
