import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';

class PickerPlusDaysView extends StatelessWidget {
  PickerPlusDaysView({
    super.key,
    required this.currentDate,
    required this.onChanged,
    required this.minDate,
    required this.maxDate,
    this.selectedDate,
    this.onDoubleTap,
    required this.displayedMonth,
    required this.daysOfTheWeekTextStyle,
    required this.enabledCellsTextStyle,
    required this.enabledCellsDecoration,
    required this.disabledCellsTextStyle,
    required this.disabledCellsDecoration,
    required this.currentDateTextStyle,
    required this.currentDateDecoration,
    required this.selectedDayTextStyle,
    required this.selectedDayDecoration,
    required this.highlightColor,
    required this.splashColor,
    this.splashRadius,
    this.disabledDayPredicate,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

    assert(() {
      if (selectedDate == null) return true;
      final min = DateTime(minDate.year, minDate.month, minDate.day);
      final max = DateTime(maxDate.year, maxDate.month, maxDate.day);
      final selected = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);
      return (selected.isAfter(min) || selected.isAtSameMomentAs(min)) &&
          (selected.isBefore(max) || selected.isAtSameMomentAs(max));
    }(), "selected date should be in the range of min date & max date");
  }

  final DateTime? selectedDate;
  final DateTime currentDate;
  final ValueChanged<DateTime> onChanged;
  final ValueChanged<DateTime>? onDoubleTap;
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime displayedMonth;
  final TextStyle daysOfTheWeekTextStyle;
  final TextStyle enabledCellsTextStyle;
  final BoxDecoration enabledCellsDecoration;
  final TextStyle disabledCellsTextStyle;
  final BoxDecoration disabledCellsDecoration;
  final TextStyle currentDateTextStyle;
  final BoxDecoration currentDateDecoration;
  final TextStyle selectedDayTextStyle;
  final BoxDecoration selectedDayDecoration;
  final Color splashColor;
  final Color highlightColor;
  final double? splashRadius;
  final DatePredicate? disabledDayPredicate;

  List<Widget> _dayHeaders(TextStyle headerStyle, Locale locale, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    final weekdayNames = DateFormat('', locale.toString()).dateSymbols.SHORTWEEKDAYS;

    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      // to save space in arabic as arabic don't has short week days.
      final String weekday = weekdayNames[i].replaceFirst('ال', '');
      result.add(ExcludeSemantics(child: Center(child: Text(weekday.toUpperCase(), style: daysOfTheWeekTextStyle))));
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) {
        break;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final int year = displayedMonth.year;
    final int month = displayedMonth.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);

    final fusionMaxDate = DateUtils.dateOnly(maxDate);
    final fusionMinDate = DateUtils.dateOnly(minDate);

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
            dayToBuild.isAfter(fusionMaxDate) ||
            dayToBuild.isBefore(fusionMinDate) ||
            (disabledDayPredicate?.call(dayToBuild) ?? false);

        final bool isSelectedDay = DateUtils.isSameDay(selectedDate, dayToBuild);
        final bool isCurrent = DateUtils.isSameDay(currentDate, dayToBuild);

        BoxDecoration decoration = enabledCellsDecoration;
        TextStyle style = enabledCellsTextStyle;

        if (isCurrent) {
          style = currentDateTextStyle;
          decoration = currentDateDecoration;
        }

        if (isSelectedDay) {
          style = selectedDayTextStyle;
          decoration = selectedDayDecoration;
        }

        if (isDisabled) {
          style = disabledCellsTextStyle;
          decoration = disabledCellsDecoration;
        }

        if (isCurrent && isDisabled) {
          style = disabledCellsTextStyle;
          decoration = currentDateDecoration;
        }

        Widget dayWidget = Container(
          decoration: decoration,
          child: Center(child: Text(localizations.formatDecimal(day), style: style)),
        );

        if (isDisabled) {
          dayWidget = ExcludeSemantics(child: dayWidget);
        } else {
          dayWidget = InkResponse(
            onTap: () => onChanged(dayToBuild),
            onDoubleTap: () {
              if (onDoubleTap != null) {
                onDoubleTap!(dayToBuild); // Ensure onDoubleTap is not null
              }
            },
            radius: splashRadius,
            splashColor: splashColor,
            highlightColor: highlightColor,
            child: Semantics(
              label: '${localizations.formatDecimal(day)}, ${localizations.formatFullDate(dayToBuild)}',
              selected: isSelectedDay,
              excludeSemantics: true,
              child: dayWidget,
            ),
          );
        }

        dayItems.add(dayWidget);
      }
    }
    return GridView.custom(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: PickerPlusPickerGridDelegate(columnCount: 7, rowCount: dayItems.length >= 43 ? 7 : 6),
      childrenDelegate: SliverChildListDelegate(addRepaintBoundaries: false, dayItems),
    );
  }
}
