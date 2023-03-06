import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/config/resources/styles.dart';
import 'package:base_doanh/config/themes/app_theme.dart';
import 'package:base_doanh/utils/screen_controller.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({
    Key? key,
    required this.onChange,
    this.minDate,
    this.maxDate,
    this.selectedDate,
  }) : super(key: key);
  final Function(DateTime) onChange;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? selectedDate;

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        height: 400,
        decoration: BoxDecoration(
          color: AppTheme.getInstance().backgroundColor(),
          borderRadius: BorderRadius.circular(24),
        ),
        child: SfDateRangePicker(
          maxDate: widget.maxDate,
          minDate: widget.minDate,
          initialSelectedDate: widget.selectedDate,
          initialDisplayDate: widget.selectedDate,
          todayHighlightColor: AppTheme.getInstance().primaryColor(),
          headerStyle: DateRangePickerHeaderStyle(
            textStyle: textNormalCustom(
              colorBlack85, //todo
              20,
              FontWeight.w600,
            ),
          ),
          headerHeight: 60,
          onSelectionChanged: (detail) {
            if (detail.value is DateTime) {
              closeScreen(context);
              widget.onChange(detail.value);
            }
          },
          yearCellStyle: DateRangePickerYearCellStyle(
            todayTextStyle: textNormalCustom(
              colorBlack85, //todo
              14,
              FontWeight.w400,
            ),
          ),
          showNavigationArrow: true,
          monthViewSettings: DateRangePickerMonthViewSettings(
            showTrailingAndLeadingDates: true,
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
              textStyle: textNormalCustom(
                colorBlack65, //todo
                12,
                FontWeight.w400,
              ),
            ),
            dayFormat: 'E',
          ),
          selectionColor: AppTheme.getInstance().primaryColor(),
          monthCellStyle: DateRangePickerMonthCellStyle(
            trailingDatesTextStyle: textNormalCustom(
              AppTheme.getInstance().borderColor(),
              14,
              FontWeight.w400,
            ),
            todayTextStyle: textNormalCustom(
              colorBlack85, //todo
              14,
              FontWeight.w400,
            ),
            leadingDatesTextStyle: textNormalCustom(
              AppTheme.getInstance().borderColor(),
              16,
              FontWeight.w400,
            ),
            textStyle: textNormalCustom(
              colorBlack85, //todo
              14,
              FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
