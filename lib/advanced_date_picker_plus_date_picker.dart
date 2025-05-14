import 'package:flutter/material.dart';
import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';
import 'package:advanced_date_picker_plus/src/date/picker_plus_date_picker.dart';

class AdvancedDatePickerPlusDatePicker extends StatefulWidget {
  const AdvancedDatePickerPlusDatePicker({
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
    this.isRangePicker = false,
    this.onRangeSelected,
    this.onLeadingDateTap,
    this.onStartDateChanged,
    this.onEndDateChanged,
    this.selectedRange,
    this.selectedCellsTextStyle,
    this.selectedCellsDecoration,
    this.singleSelectedCellTextStyle,
    this.singleSelectedCellDecoration,
});

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
  final bool? isRangePicker;

  final DateTimeRange? selectedRange;
  final ValueChanged<DateTimeRange>? onRangeSelected;
  final VoidCallback? onLeadingDateTap;
  final ValueChanged<DateTime>? onStartDateChanged;
  final ValueChanged<DateTime>? onEndDateChanged;
  final TextStyle? selectedCellsTextStyle;
  final BoxDecoration? selectedCellsDecoration;
  final TextStyle? singleSelectedCellTextStyle;
  final BoxDecoration? singleSelectedCellDecoration;

  @override
  State<AdvancedDatePickerPlusDatePicker> createState() => _AdvancedDatePickerPlusDatePickerState();
}

class _AdvancedDatePickerPlusDatePickerState extends State<AdvancedDatePickerPlusDatePicker> {
  @override
  Widget build(BuildContext context) {
    return (widget.isRangePicker!)
    ? PickerPlusRangeDatePicker(
      centerLeadingDate: widget.centerLeadingDate,
      initialDate: widget.initialDate,
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
      slidersColor: widget.slidersColor,
      slidersSize: widget.slidersSize,
      leadingDateTextStyle: widget.leadingDateTextStyle,
      splashColor: widget.splashColor,
      highlightColor: widget.highlightColor,
      splashRadius: widget.splashRadius,
      previousPageSemanticLabel: widget.previousPageSemanticLabel,
      nextPageSemanticLabel: widget.nextPageSemanticLabel,
      onOk: widget.onOk,
      buttonPadding: widget.buttonPadding,
      onCancel: widget.onCancel,
      padding: widget.padding,
      singleSelectedCellTextStyle: widget.singleSelectedCellTextStyle,
      selectedCellsDecoration: widget.selectedCellsDecoration,
      selectedCellsTextStyle: widget.selectedCellsTextStyle,
      onLeadingDateTap: widget.onLeadingDateTap,
      onStartDateChanged: widget.onStartDateChanged,
      onEndDateChanged: widget.onEndDateChanged,
      onRangeSelected: widget.onRangeSelected,
      selectedRange: widget.selectedRange,
      initialPickerType: widget.initialPickerType,
      singleSelectedCellDecoration: widget.singleSelectedCellDecoration,
      okButtonStyle: widget.okButtonStyle,
      cancelButtonStyle: widget.cancelButtonStyle,
    )
    : PickerPlusDatePicker(
      centerLeadingDate: widget.centerLeadingDate,
      initialDate: widget.initialDate,
      selectedDate: widget.selectedDate,
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
      onDoubleTap: widget.onDoubleTap!,
      onDateSelected: widget.onDateSelected,
      onOk: widget.onOk,
      showOkCancel: widget.showOkCancel,
      okButtonStyle: widget.okButtonStyle,
      buttonPadding: widget.buttonPadding,
      cancelButtonStyle: widget.cancelButtonStyle,
      onCancel: widget.onCancel,
      padding: widget.padding,
    );
  }
}
