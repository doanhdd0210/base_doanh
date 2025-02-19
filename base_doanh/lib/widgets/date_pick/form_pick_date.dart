import 'package:hapycar/config/resources/styles.dart';
import 'package:hapycar/config/themes/app_theme.dart';
import 'package:hapycar/utils/constants/image_asset.dart';
import 'package:hapycar/utils/extensions/date_time_ext.dart';
import 'package:hapycar/utils/style_utils.dart';
import 'package:flutter/material.dart';
import '../../presentation/language/language_data.dart';

class FormPickDate extends StatefulWidget {
  const FormPickDate({
    Key? key,
    required this.onTap,
    this.initDate,
    required this.title,
    this.isLine,
  }) : super(key: key);

  final Function(DateTime) onTap;
  final DateTime? initDate;
  final String title;
  final bool? isLine;
  @override
  State<FormPickDate> createState() => _FormPickDateState();
}

class _FormPickDateState extends State<FormPickDate> {
  DateTime selectedDate = DateTime.now();
  DateTime? selectedDateUi;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.getInstance()
                  .primaryColor(), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    AppTheme.getInstance().colorOrange(), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      // locale: Locale(getLang()),
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      selectedDateUi = selectedDate;
      widget.onTap(selectedDate);
      setState(() {});
    }
  }

  @override
  void initState() {
    DateTime? day = widget.initDate;
    if (day != null) {
      selectedDate = day;
      selectedDateUi = day;
      widget.onTap(day);
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.title}',
            style: TextStyleCustom.f16w600,
          ),
          spaceH10,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '${selectedDateUi?.convertToString() ?? Lang.key(keyT.DD_MM_YYYY)}',
                      style: TextStyleCustom.f14w500.copyWith(
                        color: selectedDateUi?.convertToString() == null
                            ? AppTheme.getInstance()
                                .greyTextColor()
                                .withOpacity(0.5)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              spaceW16,
              InkWell(
                onTap: () => _selectDate(context),
                child: Image.asset(
                  ImageAssets.icCalendar,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          if (widget.isLine == true) ...[
            spaceH10,
            line(
                color: AppTheme.getInstance().greyTextColor().withOpacity(0.5)),
          ],
        ],
      ),
    );
  }
}
