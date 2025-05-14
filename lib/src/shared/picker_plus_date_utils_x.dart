import 'package:flutter/material.dart';

extension PickerPlusDateUtilsX on DateUtils {
  static DateTime monthOnly(DateTime date) {
    return DateTime(date.year, date.month);
  }

  static DateTime yearOnly(DateTime date) {
    return DateTime(date.year);
  }

  static DateTime clampDateToRange({
    required DateTime min,
    required DateTime max,
    required DateTime date,
  }) {
    if (date.isBefore(min)) return min;
    if (date.isAfter(max)) return max;
    return date;
  }
}
