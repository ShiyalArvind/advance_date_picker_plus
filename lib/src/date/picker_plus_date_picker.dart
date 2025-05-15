import 'package:flutter/material.dart';
import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';

class PickerPlusDatePicker extends StatefulWidget {
  PickerPlusDatePicker({
    super.key,
    required this.maxDate,
    required this.minDate,
    this.onDateSelected,
    this.onDoubleTap,
    this.initialDate,
    this.selectedDate,
    this.currentDate,
    this.padding = const EdgeInsets.all(16),
    this.initialPickerType = PickerType.days,
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
    this.previousPageSemanticLabel,
    this.nextPageSemanticLabel,
    this.disabledDayPredicate,
    this.onOk,
    this.onCancel,
    this.showOkCancel = true,
    this.buttonPadding,
    this.cancelButtonStyle,
    this.okButtonStyle,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
  }

  final DateTime? initialDate;
  final DateTime? currentDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTime>? onDoubleTap;
  final DateTime minDate;
  final DateTime maxDate;
  final PickerType initialPickerType;
  final EdgeInsets padding;
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
  final DatePredicate? disabledDayPredicate;
  final VoidCallback? onOk;
  final VoidCallback? onCancel;
  final bool showOkCancel;
  final EdgeInsets? buttonPadding;
  final TextStyle? cancelButtonStyle;
  final TextStyle? okButtonStyle;

  @override
  State<PickerPlusDatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<PickerPlusDatePicker> {
  late PickerType pickerType;
  late DateTime displayedDate;
  DateTime? selectedDate;

  DateTime get _initialClampedDate {
    final nowClamped = PickerPlusDateUtilsX.clampDateToRange(
      max: widget.maxDate,
      min: widget.minDate,
      date: DateTime.now(),
    );
    return widget.initialDate ?? nowClamped;
  }

  @override
  void initState() {
    super.initState();
    pickerType = widget.initialPickerType;
    displayedDate = DateUtils.dateOnly(_initialClampedDate);
    selectedDate = widget.selectedDate != null ? DateUtils.dateOnly(widget.selectedDate!) : null;
  }

  @override
  void didUpdateWidget(covariant PickerPlusDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialDate != widget.initialDate) {
      setState(() {
        displayedDate = DateUtils.dateOnly(_initialClampedDate);
      });
    }
    if (oldWidget.initialPickerType != widget.initialPickerType) {
      setState(() {
        pickerType = widget.initialPickerType;
      });
    }
    if (oldWidget.selectedDate != widget.selectedDate) {
      setState(() {
        selectedDate = widget.selectedDate != null ? DateUtils.dateOnly(widget.selectedDate!) : null;
      });
    }
  }

  void _updatePickerType(PickerType type) {
    setState(() => pickerType = type);
  }

  void _updateDisplayedDate(DateTime date) {
    setState(() => displayedDate = date);
  }

  void _updateSelectedDate(DateTime? date) {
    setState(() => selectedDate = date);
  }

  void _handleDoubleTap(DateTime date) {
    _updateDisplayedDate(date);
    _updateSelectedDate(date);
    widget.onDateSelected?.call(date);
    widget.onOk?.call();
    widget.onDoubleTap?.call(date);
  }

  void _handleSingleTap(DateTime date) {
    _updateDisplayedDate(date);
    _updateSelectedDate(date);
    widget.onDateSelected?.call(date);
    if (!widget.showOkCancel) {
      widget.onOk?.call();
    }
  }

  void _handleOk() {
    if (selectedDate != null) {
      _updateDisplayedDate(selectedDate!);
      widget.onDateSelected?.call(selectedDate!);
      widget.onOk?.call();
    }
  }

  void _handleCancel() {
    _updateSelectedDate(null);
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    Widget picker;

    switch (pickerType) {
      case PickerType.days:
        picker = PickerPlusDaysPicker(
          centerLeadingDate: widget.centerLeadingDate,
          initialDate: displayedDate,
          selectedDate: selectedDate,
          currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
          maxDate: DateUtils.dateOnly(widget.maxDate),
          minDate: DateUtils.dateOnly(widget.minDate),
          daysOfTheWeekTextStyle: widget.daysOfTheWeekTextStyle,
          enabledCellsTextStyle: widget.enabledCellsTextStyle,
          enabledCellsDecoration: widget.enabledCellsDecoration,
          disabledCellsTextStyle: widget.disabledCellsTextStyle,
          disabledCellsDecoration: widget.disabledCellsDecoration,
          currentDateDecoration: widget.currentDateDecoration,
          currentDateTextStyle: widget.currentDateTextStyle,
          selectedCellDecoration: widget.selectedCellDecoration,
          selectedCellTextStyle: widget.selectedCellTextStyle,
          slidersColor: widget.slidersColor,
          slidersSize: widget.slidersSize,
          leadingDateTextStyle: widget.leadingDateTextStyle,
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          splashRadius: widget.splashRadius,
          previousPageSemanticLabel: widget.previousPageSemanticLabel,
          nextPageSemanticLabel: widget.nextPageSemanticLabel,
          disabledDayPredicate: widget.disabledDayPredicate,
          onLeadingDateTap: () => _updatePickerType(PickerType.months),
          onDoubleTap: widget.onDoubleTap != null ? _handleDoubleTap : null,
          onDateSelected: _handleSingleTap,
          onOk: widget.onOk,
          showOkCancel: widget.showOkCancel,
        );
        break;
      case PickerType.months:
        picker = PickerPlusMonthPicker(
          centerLeadingDate: widget.centerLeadingDate,
          initialDate: displayedDate,
          selectedDate: selectedDate,
          currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
          maxDate: DateUtils.dateOnly(widget.maxDate),
          minDate: DateUtils.dateOnly(widget.minDate),
          currentDateDecoration: widget.currentDateDecoration,
          currentDateTextStyle: widget.currentDateTextStyle,
          disabledCellsDecoration: widget.disabledCellsDecoration,
          disabledCellsTextStyle: widget.disabledCellsTextStyle,
          enabledCellsDecoration: widget.enabledCellsDecoration,
          enabledCellsTextStyle: widget.enabledCellsTextStyle,
          selectedCellDecoration: widget.selectedCellDecoration,
          selectedCellTextStyle: widget.selectedCellTextStyle,
          slidersColor: widget.slidersColor,
          slidersSize: widget.slidersSize,
          leadingDateTextStyle: widget.leadingDateTextStyle,
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          splashRadius: widget.splashRadius,
          previousPageSemanticLabel: widget.previousPageSemanticLabel,
          nextPageSemanticLabel: widget.nextPageSemanticLabel,
          onLeadingDateTap: () => _updatePickerType(PickerType.years),
          onDateSelected: (selectedMonth) {
            final clampedMonth = PickerPlusDateUtilsX.clampDateToRange(
              min: widget.minDate,
              max: widget.maxDate,
              date: selectedMonth,
            );
            _updateDisplayedDate(clampedMonth);
            _updatePickerType(PickerType.days);
          },
        );
        break;
      case PickerType.years:
        picker = PickerPlusYearsPicker(
          centerLeadingDate: widget.centerLeadingDate,
          initialDate: displayedDate,
          selectedDate: selectedDate,
          currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
          maxDate: DateUtils.dateOnly(widget.maxDate),
          minDate: DateUtils.dateOnly(widget.minDate),
          currentDateDecoration: widget.currentDateDecoration,
          currentDateTextStyle: widget.currentDateTextStyle,
          disabledCellsDecoration: widget.disabledCellsDecoration,
          disabledCellsTextStyle: widget.disabledCellsTextStyle,
          enabledCellsDecoration: widget.enabledCellsDecoration,
          enabledCellsTextStyle: widget.enabledCellsTextStyle,
          selectedCellDecoration: widget.selectedCellDecoration,
          selectedCellTextStyle: widget.selectedCellTextStyle,
          slidersColor: widget.slidersColor,
          slidersSize: widget.slidersSize,
          leadingDateTextStyle: widget.leadingDateTextStyle,
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          splashRadius: widget.splashRadius,
          previousPageSemanticLabel: widget.previousPageSemanticLabel,
          nextPageSemanticLabel: widget.nextPageSemanticLabel,
          onDateSelected: (selectedYear) {
            final clampedYear = PickerPlusDateUtilsX.clampDateToRange(
              min: widget.minDate,
              max: widget.maxDate,
              date: selectedYear,
            );
            _updateDisplayedDate(clampedYear);
            _updatePickerType(PickerType.months);
          },
        );
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: widget.padding,
          child: picker,
        ),
        if (widget.showOkCancel && pickerType == PickerType.days)
          Padding(
            padding: widget.buttonPadding ?? EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _handleCancel,
                  child: Text('Cancel', style: widget.cancelButtonStyle),
                ),
                TextButton(
                  onPressed: _handleOk,
                  child: Text('OK', style: widget.okButtonStyle),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
