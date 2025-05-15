import 'package:flutter/material.dart';
import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';

import 'picker_plus_range_days_view.dart';

class PickerPlusRangeDaysPicker extends StatefulWidget {
  PickerPlusRangeDaysPicker({
    super.key,
    required this.minDate,
    required this.maxDate,
    this.initialDate,
    this.currentDate,
    this.selectedStartDate,
    this.selectedEndDate,
    this.daysOfTheWeekTextStyle,
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration = const BoxDecoration(),
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration = const BoxDecoration(),
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellsTextStyle,
    this.selectedCellsDecoration,
    this.singleSelectedCellTextStyle,
    this.singleSelectedCellDecoration,
    this.onLeadingDateTap,
    this.onStartDateChanged,
    this.onEndDateChanged,
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel = 'Previous Day',
    this.nextPageSemanticLabel = 'Next Day',
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
    if (initialDate != null) {
      assert(!initialDate!.isBefore(minDate), 'initialDate $initialDate must be on or after minDate $minDate.');
      assert(!initialDate!.isAfter(maxDate), 'initialDate $initialDate must be on or before maxDate $maxDate.');
    }
  }

  final DateTime? initialDate;
  final DateTime? currentDate;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final ValueChanged<DateTime>? onStartDateChanged;
  final ValueChanged<DateTime>? onEndDateChanged;
  final DateTime minDate;
  final DateTime maxDate;
  final VoidCallback? onLeadingDateTap;
  final TextStyle? daysOfTheWeekTextStyle;
  final TextStyle? enabledCellsTextStyle;
  final BoxDecoration enabledCellsDecoration;
  final TextStyle? disabledCellsTextStyle;
  final BoxDecoration disabledCellsDecoration;
  final TextStyle? currentDateTextStyle;
  final BoxDecoration? currentDateDecoration;
  final TextStyle? selectedCellsTextStyle;
  final BoxDecoration? selectedCellsDecoration;
  final TextStyle? singleSelectedCellTextStyle;
  final BoxDecoration? singleSelectedCellDecoration;
  final TextStyle? leadingDateTextStyle;
  final Color? slidersColor;
  final double? slidersSize;
  final Color? splashColor;
  final Color? highlightColor;
  final double? splashRadius;
  final bool centerLeadingDate;
  final String? previousPageSemanticLabel;
  final String? nextPageSemanticLabel;

  @override
  State<PickerPlusRangeDaysPicker> createState() => _RangeDaysPickerState();
}

class _RangeDaysPickerState extends State<PickerPlusRangeDaysPicker> {
  late PageController _pageController;
  late DateTime? _displayedMonth;

  @override
  void initState() {
    super.initState();
    final clampedInitialDate = PickerPlusDateUtilsX.clampDateToRange(
      max: widget.maxDate,
      min: widget.minDate,
      date: DateTime.now(),
    );
    _displayedMonth = DateUtils.dateOnly(widget.initialDate ?? clampedInitialDate);
    _pageController = PageController(
      initialPage: DateUtils.monthDelta(widget.minDate, _displayedMonth!),
    );
  }

  @override
  void didUpdateWidget(covariant PickerPlusRangeDaysPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDate != widget.initialDate) {
      jumpToInitialPage();
    }
  }

  void onPageChanged(int page) {
    final totalMonths = DateUtils.monthDelta(widget.minDate, widget.maxDate);
    final clampedPage = page.clamp(0, totalMonths);
    final DateTime newMonth = DateUtils.addMonthsToMonthDate(widget.minDate, clampedPage);
    setState(() {
      _displayedMonth = newMonth;
    });
  }

  void jumpToInitialPage() {
    final clampedInitialDate = PickerPlusDateUtilsX.clampDateToRange(
      max: widget.maxDate,
      min: widget.minDate,
      date: DateTime.now(),
    );
    final initialDate = DateUtils.dateOnly(widget.initialDate ?? clampedInitialDate);
    setState(() {
      _displayedMonth = initialDate;
    });
    _pageController.jumpToPage(DateUtils.monthDelta(widget.minDate, initialDate));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final TextStyle daysOfTheWeekTextStyle = widget.daysOfTheWeekTextStyle ??
        textTheme.titleSmall!.copyWith(
          color: colorScheme.onSurface.withOpacity(0.30),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );

    final TextStyle enabledCellsTextStyle = widget.enabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(color: colorScheme.onSurface);

    final TextStyle disabledCellsTextStyle = widget.disabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(color: colorScheme.onSurface.withOpacity(0.30));

    final TextStyle currentDateTextStyle = widget.currentDateTextStyle ??
        textTheme.titleLarge!.copyWith(color: colorScheme.primary);

    final BoxDecoration currentDateDecoration = widget.currentDateDecoration ??
        BoxDecoration(border: Border.all(color: colorScheme.primary), shape: BoxShape.circle);

    final TextStyle selectedCellsTextStyle = widget.selectedCellsTextStyle ??
        textTheme.titleLarge!.copyWith(color: colorScheme.onPrimaryContainer);

    final BoxDecoration selectedCellsDecoration = widget.selectedCellsDecoration ??
        BoxDecoration(color: colorScheme.primaryContainer, shape: BoxShape.rectangle);

    final TextStyle singleSelectedCellTextStyle = widget.singleSelectedCellTextStyle ??
        textTheme.titleLarge!.copyWith(color: colorScheme.onPrimary);

    final BoxDecoration singleSelectedCellDecoration = widget.singleSelectedCellDecoration ??
        BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle);

    final TextStyle leadingDateTextStyle = widget.leadingDateTextStyle ??
        textTheme.titleMedium!.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold);

    final Color slidersColor = widget.slidersColor ?? colorScheme.primary;
    final double slidersSize = widget.slidersSize ?? 20;
    final Color splashColor =
        widget.splashColor ?? singleSelectedCellDecoration.color!.withOpacity(0.3);
    final Color highlightColor =
        widget.highlightColor ?? singleSelectedCellDecoration.color!.withOpacity(0.3);

    final displayedMonth = _displayedMonth!;

    return DeviceOrientationBuilder(builder: (context, orientation) {
      final size = orientation == Orientation.portrait
          ? const Size(328, 402)
          : const Size(328, 300);

      return LimitedBox(
        maxHeight: size.height,
        maxWidth: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PickerPlusHeader(
              previousPageSemanticLabel: widget.previousPageSemanticLabel,
              nextPageSemanticLabel: widget.nextPageSemanticLabel,
              centerLeadingDate: widget.centerLeadingDate,
              leadingDateTextStyle: leadingDateTextStyle,
              slidersColor: slidersColor,
              slidersSize: slidersSize,
              onDateTap: () => widget.onLeadingDateTap?.call(),
              displayedDate: MaterialLocalizations.of(context)
                  .formatMonthYear(displayedMonth)
                  .replaceAllMapped(RegExp(r'[٠-٩]'), (m) => (m[0]!.codeUnitAt(0) - 0x0660).toString()),
              onNextPage: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
              onPreviousPage: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: onPageChanged,
                itemCount: DateUtils.monthDelta(widget.minDate, widget.maxDate) + 1,
                itemBuilder: (context, index) {
                  final DateTime month = DateUtils.addMonthsToMonthDate(widget.minDate, index);
                  return PickerPlusRangeDaysView(
                    key: ValueKey<DateTime>(month),
                    currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                    minDate: DateUtils.dateOnly(widget.minDate),
                    maxDate: DateUtils.dateOnly(widget.maxDate),
                    displayedMonth: month,
                    selectedEndDate: widget.selectedEndDate == null
                        ? null
                        : DateUtils.dateOnly(widget.selectedEndDate!),
                    selectedStartDate: widget.selectedStartDate == null
                        ? null
                        : DateUtils.dateOnly(widget.selectedStartDate!),
                    daysOfTheWeekTextStyle: daysOfTheWeekTextStyle,
                    enabledCellsTextStyle: enabledCellsTextStyle,
                    enabledCellsDecoration: widget.enabledCellsDecoration,
                    disabledCellsTextStyle: disabledCellsTextStyle,
                    disabledCellsDecoration: widget.disabledCellsDecoration,
                    currentDateDecoration: currentDateDecoration,
                    currentDateTextStyle: currentDateTextStyle,
                    selectedCellsDecoration: selectedCellsDecoration,
                    selectedCellsTextStyle: selectedCellsTextStyle,
                    singleSelectedCellTextStyle: singleSelectedCellTextStyle,
                    singleSelectedCellDecoration: singleSelectedCellDecoration,
                    highlightColor: highlightColor,
                    splashColor: splashColor,
                    splashRadius: widget.splashRadius,
                    onEndDateChanged: (value) => widget.onEndDateChanged?.call(value),
                    onStartDateChanged: (value) => widget.onStartDateChanged?.call(value),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
