import 'package:flutter/material.dart';
import 'package:advanced_date_picker_plus/src/shared/picker_plus_picker_grid_delegate.dart'
    show PickerPlusPickerGridDelegate;
import 'package:intl/intl.dart' show DateFormat;

class PickerPlusRangeDaysView extends StatelessWidget {
  PickerPlusRangeDaysView({
    super.key,
    required this.currentDate,
    required this.minDate,
    required this.maxDate,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.displayedMonth,
    required this.daysOfTheWeekTextStyle,
    required this.enabledCellsTextStyle,
    required this.enabledCellsDecoration,
    required this.disabledCellsTextStyle,
    required this.disabledCellsDecoration,
    required this.currentDateTextStyle,
    required this.currentDateDecoration,
    required this.selectedCellsTextStyle,
    required this.selectedCellsDecoration,
    required this.singleSelectedCellTextStyle,
    required this.singleSelectedCellDecoration,
    required this.highlightColor,
    required this.splashColor,
    required this.splashRadius,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

    assert(() {
      if (selectedStartDate == null) return true;
      final min = DateTime(minDate.year, minDate.month, minDate.day);
      final max = DateTime(maxDate.year, maxDate.month, maxDate.day);
      final selected = DateTime(
        selectedStartDate!.year,
        selectedStartDate!.month,
        selectedStartDate!.day,
      );

      return (selected.isAfter(min) || selected.isAtSameMomentAs(min)) &&
          (selected.isBefore(max) || selected.isAtSameMomentAs(max));
    }(), "selected start date should be in the range of min date & max date");
    assert(() {
      if (selectedEndDate == null) return true;
      final min = DateTime(minDate.year, minDate.month, minDate.day);
      final max = DateTime(maxDate.year, maxDate.month, maxDate.day);
      final selected = DateTime(
        selectedEndDate!.year,
        selectedEndDate!.month,
        selectedEndDate!.day,
      );
      return (selected.isAfter(min) || selected.isAtSameMomentAs(min)) &&
          (selected.isBefore(max) || selected.isAtSameMomentAs(max));
    }(), "selected end date should be in the range of min date & max date");
  }

  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final DateTime currentDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onEndDateChanged;
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime displayedMonth;
  final TextStyle daysOfTheWeekTextStyle;
  final TextStyle enabledCellsTextStyle;
  final BoxDecoration enabledCellsDecoration;
  final TextStyle disabledCellsTextStyle;
  final BoxDecoration disabledCellsDecoration;
  final TextStyle singleSelectedCellTextStyle;
  final BoxDecoration singleSelectedCellDecoration;
  final TextStyle currentDateTextStyle;
  final BoxDecoration currentDateDecoration;
  final TextStyle selectedCellsTextStyle;
  final BoxDecoration selectedCellsDecoration;
  final Color splashColor;
  final Color highlightColor;
  final double? splashRadius;

  List<Widget> _dayHeaders(
    TextStyle headerStyle,
    Locale locale,
    MaterialLocalizations localizations,
  ) {
    final List<Widget> result = <Widget>[];
    final weekdayNames =
        DateFormat('', locale.toString()).dateSymbols.SHORTWEEKDAYS;

    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      final String weekday = weekdayNames[i].replaceFirst('ال', '');
      result.add(
        ExcludeSemantics(
          child: Center(
            child: Text(
              weekday.toUpperCase(),
              style: daysOfTheWeekTextStyle,
            ),
          ),
        ),
      );
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) {
        break;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final int year = displayedMonth.year;
    final int month = displayedMonth.month;
    final int daysInMonth =
        DateUtils.getDaysInMonth(displayedMonth.year, displayedMonth.month);
    final int dayOffset = DateUtils.firstDayOffset(
        displayedMonth.year, displayedMonth.month, localizations);

    DateTime? selectedEndDateOnly =
        selectedEndDate != null ? DateUtils.dateOnly(selectedEndDate!) : null;

    DateTime? selectedStartDateOnly = selectedStartDate != null
        ? DateUtils.dateOnly(selectedStartDate!)
        : null;

    final _maxDate = DateUtils.dateOnly(maxDate);
    final _minDate = DateUtils.dateOnly(minDate);

    final List<Widget> dayItems = _dayHeaders(
      daysOfTheWeekTextStyle,
      Localizations.localeOf(context),
      MaterialLocalizations.of(context),
    );

    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(const SizedBox.shrink());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool isDisabled =
            dayToBuild.isAfter(_maxDate) || dayToBuild.isBefore(_minDate);

        final isRangeSelected =
            selectedStartDateOnly != null && selectedEndDateOnly != null;

        final isStartSelectedOnly = selectedStartDateOnly != null &&
            dayToBuild == selectedStartDateOnly &&
            selectedEndDateOnly == null;

        final isEndSelectedOnly = selectedStartDateOnly == null &&
            selectedEndDateOnly != null &&
            dayToBuild == selectedEndDateOnly;

        final isRangeOnlyOneDate =
            selectedStartDateOnly == selectedEndDateOnly &&
                dayToBuild == selectedStartDateOnly;

        final isSingleCellSelected =
            isStartSelectedOnly || isEndSelectedOnly || isRangeOnlyOneDate;

        final bool isWithinRange = isRangeSelected &&
            dayToBuild.isAfter(selectedStartDateOnly) &&
            dayToBuild.isBefore(selectedEndDateOnly) &&
            !isRangeOnlyOneDate;

        final isStartDate =
            DateUtils.isSameDay(selectedStartDateOnly, dayToBuild);

        final isEndDate = DateUtils.isSameDay(selectedEndDateOnly, dayToBuild);

        final bool isCurrent = DateUtils.isSameDay(currentDate, dayToBuild);
        BoxDecoration decoration = enabledCellsDecoration;
        TextStyle style = enabledCellsTextStyle;

        if (isCurrent) {
          style = currentDateTextStyle;
          decoration = currentDateDecoration;
        }

        if (isSingleCellSelected || isStartDate || isEndDate) {
          style = singleSelectedCellTextStyle;
          decoration = singleSelectedCellDecoration;
        }

        if (isWithinRange) {
          style = selectedCellsTextStyle;
          decoration = selectedCellsDecoration;
        }

        if (isDisabled) {
          style = disabledCellsTextStyle;
          decoration = disabledCellsDecoration;
        }

        if (isCurrent && isDisabled) {
          style = disabledCellsTextStyle;
          decoration = currentDateDecoration;
        }

        Widget dayWidget = Center(
          child: Text(
            localizations.formatDecimal(day),
            style: style,
          ),
        );

        dayWidget = Container(
          clipBehavior: Clip.hardEdge,
          decoration: decoration,
          child: dayWidget,
        );

        if ((isStartDate || isEndDate) &&
            isRangeSelected &&
            !isRangeOnlyOneDate) {
          dayWidget = CustomPaint(
            painter: _DecorationPainter(
              textDirection: Directionality.of(context),
              color: selectedCellsDecoration.color,
              start: isStartDate,
            ),
            child: dayWidget,
          );
        }

        if (isDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        } else {
          dayWidget = InkResponse(
            onTap: () {
              final isRangeComplete =
                  selectedEndDateOnly != null && selectedStartDateOnly != null;

              if (isRangeComplete) {
                onStartDateChanged(dayToBuild);
                return;
              }

              final isStart = (selectedEndDateOnly == null && selectedStartDateOnly == null) ||
                  (selectedEndDateOnly != null && selectedStartDateOnly != null);

              if (isStart) {
                onStartDateChanged(dayToBuild);
              } else {
                if (dayToBuild.isBefore(selectedStartDateOnly!)) {
                  onStartDateChanged(dayToBuild);
                  onEndDateChanged(selectedStartDateOnly);
                } else {
                  onEndDateChanged(dayToBuild);
                }
              }
            },
            radius: splashRadius,
            splashColor: splashColor,
            highlightColor: highlightColor,
            child: dayWidget,
          );
        }

        dayItems.add(dayWidget);
      }
    }

    return GridView.custom(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const PickerPlusPickerGridDelegate(columnCount: 7, rowCount: 7),
      childrenDelegate: SliverChildListDelegate(
        dayItems,
        addRepaintBoundaries: false,
      ),
    );
  }
}

class _DecorationPainter extends CustomPainter {
  _DecorationPainter({
    required this.textDirection,
    required this.color,
    required this.start,
  });

  final TextDirection textDirection;
  final Color? color;
  final bool start;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width / 2;
    final height = size.height;

    final painter = Paint();

    if (color != null) {
      painter.color = color!;
    }

    late final Offset offset;
    switch (textDirection) {
      case TextDirection.ltr:
        if (start) {
          offset = Offset(width, 0);
        } else {
          offset = Offset.zero;
        }
        break;
      case TextDirection.rtl:
        if (start) {
          offset = Offset.zero;
        } else {
          offset = Offset(width, 0);
        }
        break;
    }

    canvas.drawRect(offset & Size(width, height), painter);
  }

  @override
  bool shouldRepaint(covariant _DecorationPainter oldDelegate) {
    return oldDelegate.textDirection != textDirection ||
        oldDelegate.color != color ||
        oldDelegate.start != start;
  }
}
