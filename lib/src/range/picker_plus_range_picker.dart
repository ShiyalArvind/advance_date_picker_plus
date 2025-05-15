import 'package:flutter/material.dart';
import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';
import 'picker_plus_range_days_picker.dart';

class PickerPlusRangeDatePicker extends StatefulWidget {
  PickerPlusRangeDatePicker({
    super.key,
    required this.maxDate,
    required this.minDate,
    this.onRangeSelected,
    this.onLeadingDateTap,
    this.onStartDateChanged,
    this.onEndDateChanged,
    this.currentDate,
    this.initialDate,
    this.selectedRange,
    this.padding = const EdgeInsets.all(16),
    this.initialPickerType = PickerType.days,
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
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel,
    this.nextPageSemanticLabel,
    this.onOk,
    this.onCancel,
    this.buttonPadding,
    this.cancelButtonStyle,
    this.okButtonStyle,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
  }

  final DateTimeRange? selectedRange;
  final DateTime? currentDate;
  final DateTime? initialDate;
  final ValueChanged<DateTimeRange>? onRangeSelected;
  final VoidCallback? onLeadingDateTap;
  final ValueChanged<DateTime>? onStartDateChanged;
  final ValueChanged<DateTime>? onEndDateChanged;
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
  final VoidCallback? onOk;
  final VoidCallback? onCancel;
  final EdgeInsets? buttonPadding;
  final TextStyle? cancelButtonStyle;
  final TextStyle? okButtonStyle;

  @override
  State<PickerPlusRangeDatePicker> createState() => _PickerPlusRangeDatePickerState();
}

class _PickerPlusRangeDatePickerState extends State<PickerPlusRangeDatePicker> {
  late PickerType pickerType;
  late DateTime displayedDate;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

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
    selectedStartDate = widget.selectedRange?.start != null ? DateUtils.dateOnly(widget.selectedRange!.start) : null;
    selectedEndDate = widget.selectedRange?.end != null ? DateUtils.dateOnly(widget.selectedRange!.end) : null;
  }

  @override
  void didUpdateWidget(covariant PickerPlusRangeDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPickerType != widget.initialPickerType) {
      setState(() {
        pickerType = widget.initialPickerType;
      });
    }
    if (oldWidget.selectedRange != widget.selectedRange) {
      setState(() {
        selectedStartDate = widget.selectedRange?.start != null ? DateUtils.dateOnly(widget.selectedRange!.start) : null;
        selectedEndDate = widget.selectedRange?.end != null ? DateUtils.dateOnly(widget.selectedRange!.end) : null;
      });
    }
    if (oldWidget.initialDate != widget.initialDate) {
      final clampedInitialDate = PickerPlusDateUtilsX.clampDateToRange(
        max: widget.maxDate,
        min: widget.minDate,
        date: DateTime.now(),
      );
      setState(() {
        displayedDate = DateUtils.dateOnly(widget.initialDate ?? clampedInitialDate);
      });
    }
  }

  void _handleOk() {
    if (selectedStartDate != null) {
      final range = DateTimeRange(
        start: selectedStartDate!,
        end: selectedEndDate ?? selectedStartDate!,
      );
      widget.onRangeSelected?.call(range);
      widget.onOk?.call();
    }
  }

  void _handleCancel() {
    setState(() {
      selectedStartDate = null;
      selectedEndDate = null;
    });
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: widget.padding,
          child: Builder(builder: (context) {
            switch (pickerType) {
              case PickerType.days:
                return PickerPlusRangeDaysPicker(
                  centerLeadingDate: widget.centerLeadingDate,
                  currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                  initialDate: displayedDate,
                  selectedEndDate: selectedEndDate,
                  selectedStartDate: selectedStartDate,
                  maxDate: DateUtils.dateOnly(widget.maxDate),
                  minDate: DateUtils.dateOnly(widget.minDate),
                  daysOfTheWeekTextStyle: widget.daysOfTheWeekTextStyle,
                  enabledCellsTextStyle: widget.enabledCellsTextStyle,
                  enabledCellsDecoration: widget.enabledCellsDecoration,
                  disabledCellsTextStyle: widget.disabledCellsTextStyle,
                  disabledCellsDecoration: widget.disabledCellsDecoration,
                  currentDateDecoration: widget.currentDateDecoration,
                  currentDateTextStyle: widget.currentDateTextStyle,
                  selectedCellsDecoration: widget.selectedCellsDecoration,
                  selectedCellsTextStyle: widget.selectedCellsTextStyle,
                  singleSelectedCellTextStyle: widget.singleSelectedCellTextStyle,
                  singleSelectedCellDecoration: widget.singleSelectedCellDecoration,
                  slidersColor: widget.slidersColor,
                  slidersSize: widget.slidersSize,
                  leadingDateTextStyle: widget.leadingDateTextStyle,
                  splashColor: widget.splashColor,
                  highlightColor: widget.highlightColor,
                  splashRadius: widget.splashRadius,
                  previousPageSemanticLabel: widget.previousPageSemanticLabel,
                  nextPageSemanticLabel: widget.nextPageSemanticLabel,
                  onLeadingDateTap: () {
                    setState(() {
                      pickerType = PickerType.months;
                    });
                    widget.onLeadingDateTap?.call();
                  },
                  onEndDateChanged: (date) {
                    setState(() {
                      selectedEndDate = date;
                    });
                    widget.onEndDateChanged?.call(date);
                    if (selectedStartDate != null) {
                      widget.onRangeSelected?.call(DateTimeRange(start: selectedStartDate!, end: date));
                    }
                  },
                  onStartDateChanged: (date) {
                    setState(() {
                      if (selectedStartDate != null && selectedEndDate != null) {
                        selectedStartDate = null;
                        selectedEndDate = null;
                      }
                      selectedStartDate = date;
                    });
                    widget.onStartDateChanged?.call(date);
                  },
                );
              case PickerType.months:
                return PickerPlusMonthPicker(
                  centerLeadingDate: widget.centerLeadingDate,
                  initialDate: displayedDate,
                  selectedDate: null,
                  maxDate: DateUtils.dateOnly(widget.maxDate),
                  minDate: DateUtils.dateOnly(widget.minDate),
                  currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                  currentDateDecoration: widget.currentDateDecoration,
                  currentDateTextStyle: widget.currentDateTextStyle,
                  disabledCellsDecoration: widget.disabledCellsDecoration,
                  disabledCellsTextStyle: widget.disabledCellsTextStyle,
                  enabledCellsDecoration: widget.enabledCellsDecoration,
                  enabledCellsTextStyle: widget.enabledCellsTextStyle,
                  selectedCellDecoration: widget.singleSelectedCellDecoration,
                  selectedCellTextStyle: widget.singleSelectedCellTextStyle,
                  slidersColor: widget.slidersColor,
                  slidersSize: widget.slidersSize,
                  leadingDateTextStyle: widget.leadingDateTextStyle,
                  splashColor: widget.splashColor,
                  highlightColor: widget.highlightColor,
                  splashRadius: widget.splashRadius,
                  previousPageSemanticLabel: widget.previousPageSemanticLabel,
                  nextPageSemanticLabel: widget.nextPageSemanticLabel,
                  onLeadingDateTap: () {
                    setState(() {
                      pickerType = PickerType.years;
                    });
                  },
                  onDateSelected: (selectedMonth) {
                    final clampedSelectedMonth = PickerPlusDateUtilsX.clampDateToRange(
                      min: widget.minDate,
                      max: widget.maxDate,
                      date: selectedMonth,
                    );
                    setState(() {
                      displayedDate = clampedSelectedMonth;
                      pickerType = PickerType.days;
                    });
                  },
                );
              case PickerType.years:
                return PickerPlusYearsPicker(
                  centerLeadingDate: widget.centerLeadingDate,
                  selectedDate: null,
                  initialDate: displayedDate,
                  maxDate: DateUtils.dateOnly(widget.maxDate),
                  minDate: DateUtils.dateOnly(widget.minDate),
                  currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                  currentDateDecoration: widget.currentDateDecoration,
                  currentDateTextStyle: widget.currentDateTextStyle,
                  disabledCellsDecoration: widget.disabledCellsDecoration,
                  disabledCellsTextStyle: widget.disabledCellsTextStyle,
                  enabledCellsDecoration: widget.enabledCellsDecoration,
                  enabledCellsTextStyle: widget.enabledCellsTextStyle,
                  selectedCellDecoration: widget.singleSelectedCellDecoration,
                  selectedCellTextStyle: widget.singleSelectedCellTextStyle,
                  slidersColor: widget.slidersColor,
                  slidersSize: widget.slidersSize,
                  leadingDateTextStyle: widget.leadingDateTextStyle,
                  splashColor: widget.splashColor,
                  highlightColor: widget.highlightColor,
                  splashRadius: widget.splashRadius,
                  previousPageSemanticLabel: widget.previousPageSemanticLabel,
                  nextPageSemanticLabel: widget.nextPageSemanticLabel,
                  onDateSelected: (selectedYear) {
                    final clampedSelectedYear = PickerPlusDateUtilsX.clampDateToRange(
                      min: widget.minDate,
                      max: widget.maxDate,
                      date: selectedYear,
                    );
                    setState(() {
                      displayedDate = clampedSelectedYear;
                      pickerType = PickerType.months;
                    });
                  },
                );
            }
          }),
        ),
        if(pickerType == PickerType.days)
        Padding(
          padding: widget.buttonPadding ?? const EdgeInsets.all(10),
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
