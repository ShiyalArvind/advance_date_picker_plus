import 'package:flutter/material.dart';
import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';
import 'picker_plus_month_view.dart';

class PickerPlusMonthPicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? currentDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime minDate;
  final DateTime maxDate;
  final VoidCallback? onLeadingDateTap;
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

  const PickerPlusMonthPicker({
    super.key,
    required this.minDate,
    required this.maxDate,
    this.initialDate,
    this.currentDate,
    this.selectedDate,
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration = const BoxDecoration(),
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration = const BoxDecoration(),
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellTextStyle,
    this.selectedCellDecoration,
    this.onLeadingDateTap,
    this.onDateSelected,
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel = 'Previous Month',
    this.nextPageSemanticLabel = 'Next Month',
  });

  @override
  State<PickerPlusMonthPicker> createState() => _PickerPlusMonthPickerState();
}

class _PickerPlusMonthPickerState extends State<PickerPlusMonthPicker> {
  late final PageController pageController;
  late DateTime displayedYear;
  DateTime? selectedMonth;

  int get yearsCount => (widget.maxDate.year - widget.minDate.year) + 1;

  @override
  void initState() {
    super.initState();
    final clampedInitialDate = PickerPlusDateUtilsX.clampDateToRange(
      max: widget.maxDate,
      min: widget.minDate,
      date: DateTime.now(),
    );
    displayedYear = PickerPlusDateUtilsX.yearOnly(widget.initialDate ?? clampedInitialDate);
    selectedMonth = widget.selectedDate != null ? PickerPlusDateUtilsX.monthOnly(widget.selectedDate!) : null;
    pageController = PageController(
      initialPage: displayedYear.year - widget.minDate.year,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void updateDisplayedYear(int pageIndex) {
    setState(() {
      displayedYear = DateTime(widget.minDate.year + pageIndex);
    });
  }

  void updateSelectedMonth(DateTime? newDate) {
    setState(() {
      selectedMonth = newDate != null ? PickerPlusDateUtilsX.monthOnly(newDate) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final enabledCellsTextStyle = widget.enabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        );
    final disabledCellsTextStyle = widget.disabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface.withOpacity(0.30),
        );
    final currentDateTextStyle = widget.currentDateTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.primary,
        );
    final currentDateDecoration = widget.currentDateDecoration ??
        BoxDecoration(
          border: Border.all(color: colorScheme.primary),
          shape: BoxShape.circle,
        );
    final selectedCellTextStyle = widget.selectedCellTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onPrimary,
        );
    final selectedCellDecoration = widget.selectedCellDecoration ??
        BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        );
    final leadingDateTextStyle = widget.leadingDateTextStyle ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        );
    final slidersColor = widget.slidersColor ?? colorScheme.primary;
    final slidersSize = widget.slidersSize ?? 20;
    final splashColor = widget.splashColor ?? selectedCellDecoration.color?.withOpacity(0.3);
    final highlightColor = widget.highlightColor ?? selectedCellDecoration.color?.withOpacity(0.3);

    final Size size = MediaQuery.of(context).orientation == Orientation.portrait
        ? const Size(328.0, 402.0)
        : const Size(328.0, 300.0);

    return LimitedBox(
      maxHeight: size.height,
      maxWidth: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          PickerPlusHeader(
            previousPageSemanticLabel: widget.previousPageSemanticLabel,
            nextPageSemanticLabel: widget.nextPageSemanticLabel,
            centerLeadingDate: widget.centerLeadingDate,
            leadingDateTextStyle: leadingDateTextStyle,
            slidersColor: slidersColor,
            slidersSize: slidersSize,
            onDateTap: () => widget.onLeadingDateTap?.call(),
            displayedDate: displayedYear.year.toString(),
            onNextPage: () {
              final current = pageController.page?.round() ?? pageController.initialPage;
              if (current < yearsCount - 1) {
                pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
            onPreviousPage: () {
              final current = pageController.page?.round() ?? pageController.initialPage;
              if (current > 0) {
                pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
          ),
          const SizedBox(height: 10),
          // Month Pages
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: yearsCount,
              onPageChanged: updateDisplayedYear,
              itemBuilder: (context, index) {
                final DateTime year = DateTime(widget.minDate.year + index);
                return PickerPlusMonthView(
                  key: ValueKey<DateTime>(year),
                  currentDate: PickerPlusDateUtilsX.monthOnly(widget.currentDate ?? DateTime.now()),
                  maxDate: PickerPlusDateUtilsX.monthOnly(widget.maxDate),
                  minDate: PickerPlusDateUtilsX.monthOnly(widget.minDate),
                  displayedDate: year,
                  selectedDate: selectedMonth,
                  enabledCellsDecoration: widget.enabledCellsDecoration,
                  enabledCellsTextStyle: enabledCellsTextStyle,
                  disabledCellsDecoration: widget.disabledCellsDecoration,
                  disabledCellsTextStyle: disabledCellsTextStyle,
                  currentDateDecoration: currentDateDecoration,
                  currentDateTextStyle: currentDateTextStyle,
                  selectedCellDecoration: selectedCellDecoration,
                  selectedCellTextStyle: selectedCellTextStyle,
                  highlightColor: highlightColor!,
                  splashColor: splashColor!,
                  splashRadius: widget.splashRadius,
                  onChanged: (value) {
                    final selected = PickerPlusDateUtilsX.monthOnly(value);
                    widget.onDateSelected?.call(selected);
                    updateSelectedMonth(selected);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
