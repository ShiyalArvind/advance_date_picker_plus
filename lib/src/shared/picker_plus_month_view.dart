import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';

class PickerPlusMonthView extends StatelessWidget {
  PickerPlusMonthView({
    super.key,
    required this.currentDate,
    this.selectedDate,
    required this.displayedDate,
    required this.onChanged,
    required this.minDate,
    required this.maxDate,
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
      if (selectedDate == null) return true;
      final max = PickerPlusDateUtilsX.monthOnly(maxDate);
      final min = PickerPlusDateUtilsX.monthOnly(minDate);
      final selected = PickerPlusDateUtilsX.monthOnly(selectedDate!);

      return (selected.isAfter(min) || selected.isAtSameMomentAs(min)) &&
          (selected.isBefore(max) || selected.isAtSameMomentAs(max));
    }(), "selected date should be in the range of min date & max date");
  }

  final DateTime? selectedDate;
  final DateTime currentDate;
  final ValueChanged<DateTime> onChanged;
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime displayedDate;
  final TextStyle enabledCellsTextStyle;
  final BoxDecoration enabledCellsDecoration;
  final TextStyle disabledCellsTextStyle;
  final BoxDecoration disabledCellsDecoration;
  final TextStyle currentDateTextStyle;
  final BoxDecoration currentDateDecoration;
  final TextStyle selectedCellTextStyle;
  final BoxDecoration selectedCellDecoration;
  final Color splashColor;
  final Color highlightColor;
  final double? splashRadius;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    final int year = displayedDate.year;
    final DateTime startMonth = PickerPlusDateUtilsX.monthOnly(minDate);
    final DateTime endMonth = PickerPlusDateUtilsX.monthOnly(maxDate);
    DateTime? selectedMonth;

    if (selectedDate != null) {
      selectedMonth = PickerPlusDateUtilsX.monthOnly(selectedDate!);
    }

    final monthsNames =
        DateFormat('', locale.toString()).dateSymbols.STANDALONESHORTMONTHS;
    final monthsWidgetList = <Widget>[];

    int month = 0;
    while (month < 12) {
      final DateTime monthToBuild = DateTime(year, month + 1);

      final bool isDisabled =
          monthToBuild.isAfter(endMonth) || monthToBuild.isBefore(startMonth);

      final bool isCurrentMonth =
          monthToBuild == PickerPlusDateUtilsX.monthOnly(currentDate);

      final bool isSelected = monthToBuild == selectedMonth;
      BoxDecoration decoration = enabledCellsDecoration;
      TextStyle style = enabledCellsTextStyle;

      if (isCurrentMonth) {
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
            monthsNames[month],
            style: style,
          ),
        ),
      );

      if (isDisabled) {
        monthWidget = ExcludeSemantics(
          child: monthWidget,
        );
      } else {
        monthWidget = InkResponse(
          onTap: () => onChanged(monthToBuild),
          radius: splashRadius,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: Semantics(
            label: localizations.formatMediumDate(monthToBuild),
            selected: isSelected,
            excludeSemantics: true,
            child: monthWidget,
          ),
        );
      }

      monthsWidgetList.add(monthWidget);
      month++;
    }

    return GridView.custom(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const PickerPlusPickerGridDelegate(columnCount: 3, rowCount: 4),
      childrenDelegate: SliverChildListDelegate(
        monthsWidgetList,
        addRepaintBoundaries: false,
      ),
    );
  }
}
