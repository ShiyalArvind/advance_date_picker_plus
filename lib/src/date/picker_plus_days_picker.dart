import 'package:flutter/material.dart';
import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';

import 'picker_plus_days_view.dart';

class PickerPlusDaysPicker extends StatefulWidget {
  const PickerPlusDaysPicker({
    super.key,
    required this.minDate,
    required this.maxDate,
    this.initialDate,
    this.currentDate,
    this.selectedDate,
    this.onDateSelected,
    this.onDoubleTap,
    this.showOkCancel = true,
    this.onOk,
    this.onLeadingDateTap,
    this.daysOfTheWeekTextStyle,
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration = const BoxDecoration(),
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration = const BoxDecoration(),
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellTextStyle,
    this.selectedCellDecoration,
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel = 'Previous Day',
    this.nextPageSemanticLabel = 'Next Day',
    this.disabledDayPredicate,
  });

  final DateTime minDate;
  final DateTime maxDate;
  final DateTime? initialDate;
  final DateTime? currentDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTime>? onDoubleTap;
  final VoidCallback? onOk;
  final VoidCallback? onLeadingDateTap;
  final TextStyle? daysOfTheWeekTextStyle;
  final TextStyle? enabledCellsTextStyle;
  final BoxDecoration enabledCellsDecoration;
  final TextStyle? disabledCellsTextStyle;
  final BoxDecoration disabledCellsDecoration;
  final TextStyle? currentDateTextStyle;
  final BoxDecoration? currentDateDecoration;
  final TextStyle? selectedCellTextStyle;
  final BoxDecoration? selectedCellDecoration;
  final TextStyle? leadingDateTextStyle;
  final Color? slidersColor;
  final double? slidersSize;
  final Color? splashColor;
  final Color? highlightColor;
  final double? splashRadius;
  final bool centerLeadingDate;
  final String? previousPageSemanticLabel;
  final String? nextPageSemanticLabel;
  final bool showOkCancel;
  final DatePredicate? disabledDayPredicate;

  @override
  State<PickerPlusDaysPicker> createState() => _PickerPlusDaysPickerState();
}

class _PickerPlusDaysPickerState extends State<PickerPlusDaysPicker> {
  late DateTime displayedMonth;
  DateTime? selectedDay;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    final clampedInitialDate = PickerPlusDateUtilsX.clampDateToRange(
      date: widget.initialDate ?? DateTime.now(),
      min: widget.minDate,
      max: widget.maxDate,
    );
    displayedMonth = DateUtils.dateOnly(clampedInitialDate);
    selectedDay = widget.selectedDate != null ? DateUtils.dateOnly(widget.selectedDate!) : null;
    pageController = PageController(
      initialPage: DateUtils.monthDelta(widget.minDate, displayedMonth),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int monthPage) {
    setState(() {
      displayedMonth = DateUtils.addMonthsToMonthDate(widget.minDate, monthPage);
    });
  }

  void onUserSelectedDay(DateTime value) {
    setState(() => selectedDay = value);
    widget.onDateSelected?.call(value);
    if (!widget.showOkCancel) {
      widget.onOk?.call();
    }
  }

  void onUserDoubleTapDay(DateTime value) {
    setState(() => selectedDay = value);
    widget.onDateSelected?.call(value);
    widget.onDoubleTap?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final TextStyle daysOfTheWeekTextStyle = widget.daysOfTheWeekTextStyle ??
        textTheme.titleSmall!.copyWith(
          color: colorScheme.onSurface.withOpacity(0.3),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );

    final TextStyle enabledCellsTextStyle = widget.enabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        );

    final TextStyle disabledCellsTextStyle = widget.disabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface.withOpacity(0.3),
        );

    final TextStyle currentDateTextStyle = widget.currentDateTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.primary,
        );

    final BoxDecoration currentDateDecoration = widget.currentDateDecoration ??
        BoxDecoration(
          border: Border.all(color: colorScheme.primary),
          shape: BoxShape.circle,
        );

    final TextStyle selectedCellTextStyle = widget.selectedCellTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onPrimary,
        );

    final BoxDecoration selectedCellDecoration = widget.selectedCellDecoration ??
        BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        );

    final leadingDateTextStyle = widget.leadingDateTextStyle ??
        TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.primary);

    final slidersColor = widget.slidersColor ?? colorScheme.primary;
    final slidersSize = widget.slidersSize ?? 20.0;

    final splashColor = widget.splashColor ??
        selectedCellDecoration.color?.withOpacity(0.3) ??
        colorScheme.primary.withOpacity(0.3);

    final highlightColor = widget.highlightColor ??
        selectedCellDecoration.color?.withOpacity(0.3) ??
        colorScheme.primary.withOpacity(0.3);

    final Size size = MediaQuery.of(context).orientation == Orientation.portrait
        ? const Size(328.0, 402.0)
        : const Size(328.0, 300.0);

    final int itemCount = DateUtils.monthDelta(widget.minDate, widget.maxDate) + 1;

    return LimitedBox(
      maxHeight: size.height,
      maxWidth: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PickerPlusHeader(
            centerLeadingDate: widget.centerLeadingDate,
            leadingDateTextStyle: leadingDateTextStyle,
            slidersColor: slidersColor,
            slidersSize: slidersSize,
            onDateTap: () => widget.onLeadingDateTap?.call(),
            displayedDate: MaterialLocalizations.of(context)
                .formatMonthYear(displayedMonth)
                .replaceAllMapped(RegExp('[٠-٩]'), (match) => (int.parse(match.group(0)!) + 0).toString()),
            onNextPage: () {
              final current = pageController.page?.round() ?? pageController.initialPage;
              if (current < itemCount - 1) {
                pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
            onPreviousPage: () {
              final current = pageController.page?.round() ?? pageController.initialPage;
              if (current > 0) {
                pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
            previousPageSemanticLabel: widget.previousPageSemanticLabel,
            nextPageSemanticLabel: widget.nextPageSemanticLabel,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              itemCount: itemCount,
              onPageChanged: (monthPage) {
                final totalMonths = DateUtils.monthDelta(widget.minDate, widget.maxDate);
                final clampedPage = monthPage.clamp(0, totalMonths);
                onPageChanged(clampedPage);
              },
              itemBuilder: (context, index) {
                final month = DateUtils.addMonthsToMonthDate(widget.minDate, index);
                return PickerPlusDaysView(
                  key: ValueKey<DateTime>(month),
                  currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                  maxDate: DateUtils.dateOnly(widget.maxDate),
                  minDate: DateUtils.dateOnly(widget.minDate),
                  displayedMonth: month,
                  selectedDate: selectedDay,
                  daysOfTheWeekTextStyle: daysOfTheWeekTextStyle,
                  enabledCellsTextStyle: enabledCellsTextStyle,
                  enabledCellsDecoration: widget.enabledCellsDecoration,
                  disabledCellsTextStyle: disabledCellsTextStyle,
                  disabledCellsDecoration: widget.disabledCellsDecoration,
                  currentDateTextStyle: currentDateTextStyle,
                  currentDateDecoration: currentDateDecoration,
                  selectedDayTextStyle: selectedCellTextStyle,
                  selectedDayDecoration: selectedCellDecoration,
                  splashColor: splashColor,
                  highlightColor: highlightColor,
                  splashRadius: widget.splashRadius,
                  disabledDayPredicate: widget.disabledDayPredicate,
                  onChanged: onUserSelectedDay,
                  onDoubleTap: onUserDoubleTapDay,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
