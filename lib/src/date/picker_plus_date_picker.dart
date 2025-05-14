import 'package:flutter/material.dart';
import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';

import 'package:get/get.dart';

class PickerPlusDatePickerController extends GetxController {
  late Rx<PickerType> pickerType;
  late Rx<DateTime?> displayedDate;
  late Rx<DateTime?> selectedDate;

  final PickerPlusDatePicker widget;

  PickerPlusDatePickerController(this.widget);
  DateTime get _initialClampedDate {
    final nowClamped = PickerPlusDateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
    return widget.initialDate ?? nowClamped;
  }

  @override
  void onInit() {
    // Ensure displayedDate is normalized (date-only) and within allowed range.
    displayedDate = DateUtils.dateOnly(_initialClampedDate).obs;
    pickerType = widget.initialPickerType.obs;
    selectedDate = (widget.selectedDate != null ? DateUtils.dateOnly(widget.selectedDate!) : null).obs;
    super.onInit();
  }

  void updateDisplayedDate(DateTime date) {
    displayedDate.value = date;
  }

  void updateSelectedDate(DateTime? date) {
    selectedDate.value = date;
  }

  void updatePickerType(PickerType type) {
    pickerType.value = type;
  }

  void resetDisplayedDate() {
    displayedDate.value = DateUtils.dateOnly(_initialClampedDate);
  }

  void updateFromWidget(PickerPlusDatePicker oldWidget, PickerPlusDatePicker newWidget) {
    final bool initialDateChanged = oldWidget.initialDate != newWidget.initialDate;
    final bool pickerTypeChanged = oldWidget.initialPickerType != newWidget.initialPickerType;
    final bool selectedDateChanged = oldWidget.selectedDate != newWidget.selectedDate;

    if (initialDateChanged) {
      resetDisplayedDate();
    }
    if (pickerTypeChanged) {
      pickerType.value = newWidget.initialPickerType;
    }
    if (selectedDateChanged) {
      selectedDate.value = (newWidget.selectedDate != null ? DateUtils.dateOnly(newWidget.selectedDate!) : null);
    }
  }
}

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
  final VoidCallback? onOk; // Callback for OK button
  final VoidCallback? onCancel; // Callback for Cancel button
  final bool showOkCancel; // Control to show/hide buttons
  final EdgeInsets? buttonPadding;
  final TextStyle? cancelButtonStyle;
  final TextStyle? okButtonStyle;

  @override
  State<PickerPlusDatePicker> createState() => _DatePickerGetXState();
}

class _DatePickerGetXState extends State<PickerPlusDatePicker> {
  late final PickerPlusDatePickerController controller;

  @override
  void initState() {
    super.initState();
    controller = PickerPlusDatePickerController(widget);
    controller.onInit();
  }

  @override
  void didUpdateWidget(covariant PickerPlusDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.updateFromWidget(oldWidget, widget);
  }

  void _handleDoubleTap(DateTime date) {
    controller.updateDisplayedDate(date);
    controller.updateSelectedDate(date);

    if (widget.onDoubleTap != null) {
      widget.onDateSelected?.call(date);
      widget.onOk?.call();
      widget.onDoubleTap!.call(date);
    }
  }

  void _handleSingleTap(DateTime date) {
    controller.updateDisplayedDate(date);
    controller.updateSelectedDate(date);
    if (!widget.showOkCancel) {
      widget.onDateSelected?.call(date);
      widget.onOk?.call();
    }else{
      widget.onDateSelected?.call(date);
    }
  }

  void _handleOk() {
    final picked = controller.selectedDate.value;
    controller.updateDisplayedDate(picked!);
    controller.updateSelectedDate(picked);
    widget.onDateSelected?.call(picked);
      widget.onOk?.call();
  }

  void _handleCancel() {
    controller.updateSelectedDate(null);
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pickerType = controller.pickerType.value;
      final displayedDate = controller.displayedDate.value;
      final selectedDate = controller.selectedDate.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: widget.padding,
            child: Builder(builder: (context) {
              switch (pickerType) {
                case PickerType.days:
                  return PickerPlusDaysPicker(
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
                    onLeadingDateTap: () {
                      controller.updatePickerType(PickerType.months);
                    },
                    onDoubleTap: widget.onDoubleTap != null
                        ? _handleDoubleTap
                        : null,
                    onDateSelected: _handleSingleTap,
                    onOk: widget.onOk,
                    showOkCancel: widget.showOkCancel,
                  );
                case PickerType.months:
                  return PickerPlusMonthPicker(
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
                    onLeadingDateTap: () {
                      controller.updatePickerType(PickerType.years);
                    },
                    onDateSelected: (selectedMonth) {
                      final clampedSelectedMonth = PickerPlusDateUtilsX.clampDateToRange(
                        min: widget.minDate,
                        max: widget.maxDate,
                        date: selectedMonth,
                      );
                      controller.updateDisplayedDate(clampedSelectedMonth);
                      controller.updatePickerType(PickerType.days);
                    },
                  );
                case PickerType.years:
                  return PickerPlusYearsPicker(
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
                      final clampedSelectedYear = PickerPlusDateUtilsX.clampDateToRange(
                        min: widget.minDate,
                        max: widget.maxDate,
                        date: selectedYear,
                      );
                      controller.updateDisplayedDate(clampedSelectedYear);
                      controller.updatePickerType(PickerType.months);
                    },
                  );
              }
            }),
          ),
          if (widget.showOkCancel && controller.pickerType.value == PickerType.days)
            Padding(
              padding: widget.buttonPadding ?? EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _handleCancel,
                    child: Text('Cancel', style: widget.cancelButtonStyle,),
                  ),
                  TextButton(
                    onPressed: _handleOk,
                    child: Text('OK', style: widget.okButtonStyle,),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}