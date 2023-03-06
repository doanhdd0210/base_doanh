import 'package:flutter/material.dart';
import 'package:base_doanh/config/resources/styles.dart';

class CustomSearchText extends StatelessWidget {
  final String hintText;
  final Function(String) textChange;

  const CustomSearchText({
    Key? key,
    required this.hintText,
    required this.textChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: TextField(
        onChanged: (text) {
          textChange(text);
        },
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        style: textNormal(null, 16,),
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          suffixIcon: const Icon(Icons.search),
          hintText: hintText,
          hintStyle: textNormal(Colors.grey, 14),
        ),
      ),
    );
  }
}
