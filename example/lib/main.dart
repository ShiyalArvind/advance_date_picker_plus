import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:advanced_date_picker_plus/advanced_picker_plus_date_picker.dart';

void main() {
  runApp(const MyApp());
}

class DateController extends GetxController {
  final selectedDate = Rx<DateTime?>(null);
  final selectedRange = Rx<DateTimeRange?>(null);
  final TextEditingController dateController = TextEditingController();
  final TextEditingController rangeController = TextEditingController();
  final selectionDate = Rx<DateTime?>(null);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Date Picker Demo',
      home: Scaffold(
        body: DatePickerField(),
      ),
    );
  }
}

class DatePickerField extends StatelessWidget {
  const DatePickerField({super.key});

  @override
  Widget build(BuildContext context) {
    final DateController controller = Get.put(DateController());

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text('Calendar Picker Demo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 60),
          TextField(
            controller: controller.dateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Select Date',
              hintText: 'MM/DD/YYYY',
              suffixIcon: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.calendar_today)),
              border: const OutlineInputBorder(),
            ),
            onTap: () {
              Get.dialog(
                Dialog(
                  child: SizedBox(
                    width: 600,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AdvancedDatePickerPlusDatePicker(
                          minDate: DateTime(1900),
                          maxDate: DateTime(2100),
                          initialDate: DateTime.now(),
                          selectedDate: controller.selectedDate.value,
                          onDateSelected: (val) {
                            controller.selectionDate.value = val;
                          },
                          onOk: () {
                            final selected = controller.selectionDate.value;
                            if (selected != null) {
                              controller.selectedDate.value = selected;
                              controller.dateController.text =
                                  DateFormat('MM/dd/yyyy').format(selected);
                            }
                            Get.back();
                          },
                          onDoubleTap: (val) {
                            controller.selectedDate.value = val;
                            controller.dateController.text =
                                DateFormat('MM/dd/yyyy').format(val);
                            Get.back();
                          },
                          onCancel: () => Get.back(),
                          selectedCellDecoration: const BoxDecoration(
                            color: Color(0x333B1550),
                            shape: BoxShape.circle,
                          ),
                          splashRadius: 18,
                          slidersColor: const Color(0xFF3B1550),
                          splashColor: const Color(0x4D3B1550),
                          highlightColor: const Color(0x4D3B1550),
                          currentDateDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF3B1550), width: 2),
                          ),
                          currentDateTextStyle: const TextStyle(
                            color: Color(0xFF3B1550),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          enabledCellsTextStyle: const TextStyle(
                            color: Color(0xFF111111),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          disabledCellsTextStyle: const TextStyle(
                            color: Color(0xFF3B1550),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          selectedCellTextStyle: const TextStyle(
                            color: Color(0xFF3B1550),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          showOkCancel: true,
                          padding: const EdgeInsets.all(16),
                          buttonPadding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 16),
                          cancelButtonStyle: const TextStyle(
                            color: Color(0x80111111),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          okButtonStyle: const TextStyle(
                            color: Color(0xFF3B1550),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          daysOfTheWeekTextStyle: const TextStyle(
                            color: Color(0xFF111111),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          leadingDateTextStyle: const TextStyle(
                            color: Color(0xFF3B1550),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          slidersSize: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          TextField(
            controller: controller.rangeController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Select Range',
              hintText: 'MM/DD/YYYY - MM/DD/YYYY',
              suffixIcon: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.calendar_today)),
              border: const OutlineInputBorder(),
            ),
            onTap: () {
              Get.dialog(
                Dialog(
                  child: SizedBox(
                    width: 600,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AdvancedDatePickerPlusDatePicker(
                          isRangePicker: true,
                          minDate: DateTime(1900),
                          maxDate: DateTime(2100),
                          initialDate: DateTime.now(),
                          selectedRange: controller.selectedRange.value,
                          onRangeSelected: (range) {
                            controller.selectedRange.value = range;
                          },
                          onOk: () {
                            final range = controller.selectedRange.value;
                            if (range != null) {
                              final start =
                              DateFormat('MM/dd/yyyy').format(range.start);
                              final end =
                              DateFormat('MM/dd/yyyy').format(range.end);
                              controller.rangeController.text = '$start - $end';
                            }
                            Get.back();
                          },
                          onCancel: () => Get.back(),
                          padding: const EdgeInsets.all(16),
                          buttonPadding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16),
                          splashRadius: 18,
                          slidersColor: const Color(0xFF3B1550),
                          splashColor: const Color(0x4D3B1550),
                          highlightColor: const Color(0x4D3B1550),
                          currentDateDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF3B1550), width: 2),
                          ),
                          currentDateTextStyle: const TextStyle(
                            color: Color(0xFF3B1550),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          enabledCellsTextStyle: const TextStyle(
                            color: Color(0xFF111111),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          disabledCellsTextStyle: const TextStyle(
                            color: Color(0xFF3B1550),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          selectedCellsDecoration: const BoxDecoration(
                            color: Color(0x4D3B1550),
                          ),
                          selectedCellsTextStyle: const TextStyle(
                            color: Color(0xFF3B1550),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          singleSelectedCellTextStyle: const TextStyle(
                            color: Color(0xFF3B1550),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          singleSelectedCellDecoration: const BoxDecoration(
                            color: Color(0x4D3B1550),
                            shape: BoxShape.circle,
                          ),
                          daysOfTheWeekTextStyle: const TextStyle(
                            color: Color(0xFF111111),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          leadingDateTextStyle: const TextStyle(
                            color: Color(0xFF3B1550),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          slidersSize: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
