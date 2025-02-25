import 'package:auto_route/auto_route.dart';
import 'package:azmod/config/resources/dimen.dart';
import 'package:azmod/domain/singleton/device_singleton.dart';
import 'package:azmod/generated/l10n.dart';
import 'package:azmod/utils/constants/app_constants.dart';
import 'package:azmod/utils/extensions/context_ext.dart';
import 'package:azmod/utils/extensions/widget_ext.dart';
import 'package:azmod/widgets/date_time_picker/datetime_picker.dart';
import 'package:azmod/widgets/text_field/text_field_auto_set_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

enum TimeSection {
  fiveMinutes,
  tenMinutes,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  twoHour
}

extension TimeSectionExt on TimeSection {
  String get title {
    switch (this) {
      case TimeSection.fiveMinutes:
        return S.current.time5Minutes;
      case TimeSection.tenMinutes:
        return S.current.time10Minutes;
      case TimeSection.fifteenMinutes:
        return S.current.time15Minutes;
      case TimeSection.thirtyMinutes:
        return S.current.time30Minutes;
      case TimeSection.oneHour:
        return S.current.time1Hour;
      case TimeSection.twoHour:
        return S.current.time2Hours;
    }
  }

  static TimeSection timeOfDayToEnum(TimeOfDay time) {
    switch (time) {
      case TimeOfDay(hour: 0, minute: 5):
        return TimeSection.fiveMinutes;
      case TimeOfDay(hour: 0, minute: 10):
        return TimeSection.tenMinutes;
      case TimeOfDay(hour: 0, minute: 15):
        return TimeSection.fifteenMinutes;
      case TimeOfDay(hour: 0, minute: 30):
        return TimeSection.thirtyMinutes;
      case TimeOfDay(hour: 1, minute: 00):
        return TimeSection.oneHour;
      case TimeOfDay(hour: 2, minute: 00):
        return TimeSection.twoHour;
      default:
        return TimeSection.twoHour;
    }
  }

  TimeOfDay get time {
    switch (this) {
      case TimeSection.fiveMinutes:
        return const TimeOfDay(hour: 0, minute: 5);
      case TimeSection.tenMinutes:
        return const TimeOfDay(hour: 0, minute: 10);
      case TimeSection.fifteenMinutes:
        return const TimeOfDay(hour: 0, minute: 15);
      case TimeSection.thirtyMinutes:
        return const TimeOfDay(hour: 0, minute: 30);
      case TimeSection.oneHour:
        return const TimeOfDay(hour: 1, minute: 00);
      case TimeSection.twoHour:
        return const TimeOfDay(hour: 2, minute: 00);
    }
  }
}

class TimerDialog extends StatefulWidget {
  const TimerDialog({
    super.key,
    this.initDate,
    this.onDelete,
    this.initTime,
  });

  final DateTime? initDate;
  final TimeOfDay? initTime;
  final Function()? onDelete;

  @override
  State<TimerDialog> createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {
  final timerTextController = TextEditingController();
  DateTime? selectedDate;
  TimeSection? selectedTimeSection;

  @override
  void initState() {
    super.initState();
    if (widget.initDate != null) {
      timerTextController.text = updateTime(widget.initDate!);
      selectedDate = widget.initDate;
    }
    if (widget.initTime != null) {
      selectedTimeSection = TimeSectionExt.timeOfDayToEnum(widget.initTime!);
    } else {
      selectedTimeSection = TimeSection.twoHour;
    }
  }

  @override
  void dispose() {
    timerTextController.dispose();
    super.dispose();
  }

  String updateTime(DateTime date) {
    return DateFormat(DateFormatPattern.fullDate).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.current.timer,
                style: context.typography.h6,
              ),
              spaceH20,
              Row(
                children: [
                  Text(
                    S.current.currentTime,
                    style: context.typography.bodyText2,
                  ),
                  spaceW12,
                  Expanded(
                    child: TextFieldCustom(
                      label: '',
                      controller: timerTextController,
                      readOnly: true,
                      removePadding: true,
                      onTap: () async {
                        final date = await showDateTimePicker(
                            context: context, initDate: selectedDate);
                        if (date == null) return;
                        selectedDate = date;
                        timerTextController.text = updateTime(date);
                      },
                    ),
                  ),
                  spaceW12,
                  Text(
                    S.current.from,
                    style: context.typography.bodyText2,
                  ),
                ],
              ),
              spaceH16,
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.current.currentTime,
                      style: context.typography.bodyText2
                          ?.copyWith(color: Colors.transparent),
                    ),
                    spaceW12,
                    _buildDropDown(
                        data: TimeSection.values,
                        onSelected: (value) {
                          selectedTimeSection = value;
                        },
                        initData: selectedTimeSection)
                        .expanded(),
                    spaceW12,
                    Text(
                      S.current.from,
                      style: context.typography.bodyText2
                          ?.copyWith(color: Colors.transparent),
                    ),
                  ],
                ),
              ),
              spaceH24,
              Row(
                children: [
                  OutlinedButton(
                    style: context.style.primaryOutlinedButton,
                    onPressed: () {
                      if (widget.initDate != null) {
                        widget.onDelete?.call();
                      }
                      context.maybePop();
                    },
                    child: Text(widget.initDate != null
                        ? S.current.delete
                        : S.current.cancel),
                  ),
                  spaceW16,
                  ElevatedButton(
                    style: context.style.primaryButton,
                    onPressed: () {
                      context.maybePop({
                      'date': selectedDate,
                      'time': selectedTimeSection?.time,
                      });
                    },
                    child: Text(widget.initDate != null
                        ? S.current.edit
                        : S.current.add),
                  ).expanded(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropDown({
    required List<TimeSection> data,
    required Function(TimeSection) onSelected,
    TimeSection? initData,
  }) {
    return DropdownMenu<TimeSection>(
      initialSelection: initData ?? TimeSection.twoHour,
      expandedInsets: EdgeInsets.zero,
      label: Text(S.current.setTimerForEach),
      dropdownMenuEntries:
      data.map((e) => DropdownMenuEntry(value: e, label: e.title)).toList(),
      onSelected: (value) {
        if (value != null) {
          onSelected(value);
        }
      },
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        constraints: BoxConstraints.tight( Size.fromHeight(DeviceSingleton.instance.isIpad ? 70 : 50)),
        isDense: true,
      ),
      textStyle: TextStyle(color: context.color.primary),
    );
  }
}
