import 'package:flutter/material.dart';

import 'picker_plus_picker_grid_delegate.dart';
import 'picker_plus_date_utils_x.dart';

class PickerPlusYearView extends StatelessWidget {
  PickerPlusYearView({
    super.key,
    required this.maxDate,
    required this.minDate,
    required this.currentDate,
    this.selectedDate,
    required this.onChanged,
    required this.displayedYearRange,
    required this.enabledCellsTextStyle,
    required this.enabledCellsDecoration,
    required this.disabledCellsTextStyle,
    required this.disabledCellsDecoration,
    required this.currentDateTextStyle,
    required this.currentDateDecoration,
    required this.selectedCellTextStyle,
    required this.selectedCellDecoration,
    required this.highlightColor,
    required this.splashColor,
    this.splashRadius,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
    assert(() {
      return displayedYearRange.end.year - displayedYearRange.start.year == 11;
    }(), "the display year range must always be 12 years.");

    assert(() {
      if (selectedDate == null) return true;
      final max = PickerPlusDateUtilsX.yearOnly(maxDate);
      final min = PickerPlusDateUtilsX.yearOnly(minDate);
      final selected = PickerPlusDateUtilsX.yearOnly(selectedDate!);
      return (selected.isAfter(min) || selected.isAtSameMomentAs(min)) &&
          (selected.isBefore(max) || selected.isAtSameMomentAs(max));
    }(), "selected date should be in the range of min date & max date");
  }

  final DateTime? selectedDate;
  final DateTime currentDate;
  final ValueChanged<DateTime> onChanged;
  final DateTime minDate;
  final DateTime maxDate;
  final DateTimeRange displayedYearRange;
  final TextStyle enabledCellsTextStyle;
  final BoxDecoration enabledCellsDecoration;
  final TextStyle disabledCellsTextStyle;
  final BoxDecoration disabledCellsDecoration;
  final TextStyle currentDateTextStyle;
  final BoxDecoration currentDateDecoration;
  final TextStyle selectedCellTextStyle;
  final BoxDecoration selectedCellDecoration;
  final Color? splashColor;
  final Color? highlightColor;
  final double? splashRadius;

  @override
  Widget build(BuildContext context) {
    final int currentYear = currentDate.year;
    final int startYear = displayedYearRange.start.year;
    final int endYear = displayedYearRange.end.year;
    final int numberOfYears = endYear - startYear + 1;

    final yearsName = List.generate(
      numberOfYears,
      (index) => startYear + index,
    );

    final yearWidgetsList = <Widget>[];

    int i = 0;
    while (i < numberOfYears) {
      final bool isDisabled =
          yearsName[i] > maxDate.year || yearsName[i] < minDate.year;

      final bool isCurrentYear = yearsName[i] == currentYear;

      final bool isSelected = yearsName[i] == selectedDate?.year;
      BoxDecoration decoration = enabledCellsDecoration;
      TextStyle style = enabledCellsTextStyle;

      if (isCurrentYear) {
        style = currentDateTextStyle;
        decoration = currentDateDecoration;
      }
      if (isSelected) {
        style = selectedCellTextStyle;
        decoration = selectedCellDecoration;
      }

      if (isDisabled) {
        style = disabledCellsTextStyle;
        decoration = disabledCellsDecoration;
      }

      Widget monthWidget = Container(
        decoration: decoration,
        child: Center(
          child: Text(
            yearsName[i].toString(),
            style: style,
          ),
        ),
      );

      if (isDisabled) {
        monthWidget = ExcludeSemantics(
          child: monthWidget,
        );
      } else {
        final date = DateTime(yearsName[i]);
        monthWidget = InkResponse(
          onTap: () => onChanged(date),
          radius: splashRadius,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: Semantics(
            label: yearsName[i].toString(),
            selected: isSelected,
            excludeSemantics: true,
            child: monthWidget,
          ),
        );
      }

      yearWidgetsList.add(monthWidget);
      i++;
    }

    return GridView.custom(
      padding: EdgeInsets.zero,
      shrinkWrap: false,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const PickerPlusPickerGridDelegate(columnCount: 3, rowCount: 4),
      childrenDelegate: SliverChildListDelegate(
        yearWidgetsList,
        addRepaintBoundaries: false,
      ),
    );
  }
}
