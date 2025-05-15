import 'package:flutter/material.dart';
import 'picker_plus_year_view.dart';
import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';

class PickerPlusYearsPicker extends StatefulWidget {
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

  const PickerPlusYearsPicker({
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
    this.previousPageSemanticLabel = 'Previous Year',
    this.nextPageSemanticLabel = 'Next Year',
  });

  @override
  State<PickerPlusYearsPicker> createState() => _PickerPlusYearsPickerState();
}

class _PickerPlusYearsPickerState extends State<PickerPlusYearsPicker> {
  static const int yearsPerPage = 12;

  late final PageController _pageController;
  late int _pageCount;
  DateTimeRange? _displayedRange;
  DateTime? _selectedYear;

  @override
  void initState() {
    super.initState();

    _pageCount = ((widget.maxDate.year - widget.minDate.year + 1) / yearsPerPage).ceil();
    final initialPage = _calculateInitialPage(widget.initialDate ?? DateTime.now());

    _pageController = PageController(initialPage: initialPage);
    _displayedRange = _calculateDateRange(initialPage);
    _selectedYear = widget.selectedDate != null
        ? PickerPlusDateUtilsX.yearOnly(widget.selectedDate!)
        : null;
  }

  int _calculateInitialPage(DateTime date) {
    final clamped = PickerPlusDateUtilsX.clampDateToRange(
      max: widget.maxDate,
      min: widget.minDate,
      date: date,
    );
    final page = ((clamped.year - widget.minDate.year + 1) / yearsPerPage).ceil() - 1;
    return page < 0 ? 0 : page;
  }

  DateTimeRange _calculateDateRange(int pageIndex) {
    return DateTimeRange(
      start: DateTime(widget.minDate.year + pageIndex * yearsPerPage),
      end: DateTime(widget.minDate.year + pageIndex * yearsPerPage + yearsPerPage - 1),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _displayedRange = _calculateDateRange(index);
    });
  }

  void _onSelectYear(DateTime value) {
    final selected = PickerPlusDateUtilsX.yearOnly(value);
    setState(() {
      _selectedYear = selected;
    });
    widget.onDateSelected?.call(selected);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

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
          // --- Header ---
          PickerPlusHeader(
            previousPageSemanticLabel: widget.previousPageSemanticLabel,
            nextPageSemanticLabel: widget.nextPageSemanticLabel,
            centerLeadingDate: widget.centerLeadingDate,
            leadingDateTextStyle: leadingDateTextStyle,
            slidersColor: slidersColor,
            slidersSize: slidersSize,
            onDateTap: () => widget.onLeadingDateTap?.call(),
            displayedDate: _displayedRange != null
                ? '${_displayedRange!.start.year} - ${_displayedRange!.end.year}'
                : '',
            onNextPage: () {
              final current = _pageController.page?.round() ?? _pageController.initialPage;
              if (current < _pageCount - 1) {
                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
            onPreviousPage: () {
              final current = _pageController.page?.round() ?? _pageController.initialPage;
              if (current > 0) {
                _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
          ),
          const SizedBox(height: 10),
          Flexible(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pageCount,
              scrollDirection: Axis.horizontal,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final range = _calculateDateRange(index);
                return PickerPlusYearView(
                  key: ValueKey<DateTimeRange>(range),
                  currentDate: widget.currentDate != null
                      ? PickerPlusDateUtilsX.yearOnly(widget.currentDate!)
                      : PickerPlusDateUtilsX.yearOnly(DateTime.now()),
                  maxDate: PickerPlusDateUtilsX.yearOnly(widget.maxDate),
                  minDate: PickerPlusDateUtilsX.yearOnly(widget.minDate),
                  displayedYearRange: range,
                  selectedDate: _selectedYear,
                  enabledCellsDecoration: widget.enabledCellsDecoration,
                  enabledCellsTextStyle: enabledCellsTextStyle,
                  disabledCellsDecoration: widget.disabledCellsDecoration,
                  disabledCellsTextStyle: disabledCellsTextStyle,
                  currentDateDecoration: currentDateDecoration,
                  currentDateTextStyle: currentDateTextStyle,
                  selectedCellDecoration: selectedCellDecoration,
                  selectedCellTextStyle: selectedCellTextStyle,
                  highlightColor: highlightColor,
                  splashColor: splashColor,
                  splashRadius: widget.splashRadius,
                  onChanged: _onSelectYear,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
