import 'package:flutter/material.dart';

import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';
import 'picker_plus_range_days_picker.dart';
import 'package:get/get.dart';
class PickerPlusRangeDatePickerController extends GetxController {
  final PickerPlusRangeDatePicker widget;

  late Rx<PickerType> pickerType;
  late Rx<DateTime?> displayedDate;
  late Rx<DateTime?> selectedStartDate;
  late Rx<DateTime?> selectedEndDate;

  PickerPlusRangeDatePickerController(this.widget);

  DateTime get _initialClampedDate {
    final nowClamped = PickerPlusDateUtilsX.clampDateToRange(
      max: widget.maxDate,
      min: widget.minDate,
      date: DateTime.now(),
    );
    return widget.initialDate ?? nowClamped;
  }

  @override
  void onInit() {
    pickerType = widget.initialPickerType.obs;
    displayedDate = DateUtils.dateOnly(_initialClampedDate).obs;

    if (widget.selectedRange != null) {
      selectedStartDate = Rx<DateTime?>(DateUtils.dateOnly(widget.selectedRange!.start));
      selectedEndDate = Rx<DateTime?>(DateUtils.dateOnly(widget.selectedRange!.end));
    } else {
      selectedStartDate = Rx<DateTime?>(null);
      selectedEndDate = Rx<DateTime?>(null);
    }
    super.onInit();
  }

  void updatePickerType(PickerType type) {
    pickerType.value = type;
  }

  void updateDisplayedDate(DateTime date) {
    displayedDate.value = date;
  }

  void updateSelectedStartDate(DateTime? date) {
    selectedStartDate.value = date;
    // If starting selection over, clear end date
    selectedEndDate.value = null;
  }

  void updateSelectedEndDate(DateTime? date) {
    selectedEndDate.value = date;
  }

  void resetSelection() {
    selectedStartDate.value = null;
    selectedEndDate.value = null;
  }

  void updateFromWidget(PickerPlusRangeDatePicker oldWidget, PickerPlusRangeDatePicker newWidget) {
    if (oldWidget.initialPickerType != newWidget.initialPickerType) {
      pickerType.value = newWidget.initialPickerType;
    }

    if (oldWidget.selectedRange != newWidget.selectedRange) {
      if (newWidget.selectedRange == null) {
        selectedStartDate.value = null;
        selectedEndDate.value = null;
      } else {
        selectedStartDate.value =
            DateUtils.dateOnly(newWidget.selectedRange!.start);
        selectedEndDate.value =
            DateUtils.dateOnly(newWidget.selectedRange!.end);
      }
    }

    if (oldWidget.initialDate != newWidget.initialDate) {
      final clampedInitialDate = PickerPlusDateUtilsX.clampDateToRange(
        max: newWidget.maxDate,
        min: newWidget.minDate,
        date: DateTime.now(),
      );
      displayedDate.value =
          DateUtils.dateOnly(newWidget.initialDate ?? clampedInitialDate);
    }
  }
}

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
  late final PickerPlusRangeDatePickerController controller;

  @override
  void initState() {
    super.initState();
    controller = PickerPlusRangeDatePickerController(widget);
    controller.onInit();
  }

  @override
  void didUpdateWidget(covariant PickerPlusRangeDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.updateFromWidget(oldWidget, widget);
  }

  void _handleOk() {
    final startDate = controller.selectedStartDate.value;
    final endDate = controller.selectedEndDate.value;

    if (startDate != null &&
        endDate != null) {
      final range = DateTimeRange(
        start: startDate,
        end: endDate,
      );

      controller.updateSelectedStartDate(startDate);
      controller.updateSelectedEndDate(endDate);

      widget.onRangeSelected?.call(range);
      widget.onOk?.call();
      Get.back();
    }
  }

  void _handleCancel() {
    controller.updateSelectedStartDate(null);
    controller.updateSelectedEndDate(null);

    widget.onCancel?.call();
    Get.back();
  }


  @override
  Widget build(BuildContext context) {
  return  Obx(() {
      final pickerType = controller.pickerType.value;
      final displayedDate = controller.displayedDate.value;
      final selectedStartDate = controller.selectedStartDate.value;
      final selectedEndDate = controller.selectedEndDate.value;
    return Column(
      children: [
        Padding(
          padding: widget.padding,
        child: Builder(
            builder: (context) {
              switch (pickerType) {
                case PickerType.days:
                  return PickerPlusRangeDaysPicker(
                    centerLeadingDate: widget.centerLeadingDate,
                    currentDate:
                    DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
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
                      controller.updatePickerType(PickerType.months);
                      widget.onLeadingDateTap?.call();
                    },
                    onEndDateChanged: (date) {
                      controller.updateSelectedEndDate(date);
                      widget.onEndDateChanged?.call(date);
                      if (controller.selectedStartDate.value != null) {
                        widget.onRangeSelected?.call(DateTimeRange(
                          start: controller.selectedStartDate.value!,
                          end: controller.selectedEndDate.value!,
                        ));
                      }
                    },
                    onStartDateChanged: (date) {
                      if (controller.selectedStartDate.value != null &&
                          controller.selectedEndDate.value != null) {
                        controller.resetSelection();
                      }
                      controller.updateSelectedStartDate(date);
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
                    currentDate:
                    DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
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
                    selectedDate: null,
                    initialDate: displayedDate,
                    maxDate: DateUtils.dateOnly(widget.maxDate),
                    minDate: DateUtils.dateOnly(widget.minDate),
                    currentDate:
                    DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
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
                      controller.updateDisplayedDate(clampedSelectedYear);
                      controller.updatePickerType(PickerType.months);
                    },
                  );}
            }
        ),),
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
