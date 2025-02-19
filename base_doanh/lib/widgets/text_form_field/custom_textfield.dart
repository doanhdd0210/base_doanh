// import 'package:flutter/material.dart';
// import 'package:hapycar/config/resources/styles.dart';
// import 'package:hapycar/config/themes/app_theme.dart';
//
// import 'form_group.dart';
//
// class CustomTextField extends StatefulWidget {
//   final String hintText;
//   final TextInputType textInputType;
//   final bool isShowClearText;
//   final String? Function(String?)? validator;
//   final Function(String) textChange;
//   final int? maxLength;
//   final String? initText;
//   final bool hidePass;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final Color? color;
//   final Color? borderColor;
//   final Color? focusColor;
//   final int? maxLine;
//
//   const CustomTextField({
//     Key? key,
//     required this.hintText,
//     required this.textChange,
//     required this.textInputType,
//     required this.isShowClearText,
//     this.maxLength,
//     this.initText,
//     this.validator,
//     this.hidePass = false,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.color,
//     this.borderColor,
//     this.focusColor,
//     this.maxLine,
//   }) : super(key: key);
//
//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }
//
// class _CustomTextFieldState extends State<CustomTextField> {
//   final key = GlobalKey<FormState>();
//   FormProvider? formProvider;
//   late final TextEditingController _controller;
//
//   @override
//   void initState() {
//     _controller = TextEditingController(text: widget.initText);
//     super.initState();
//   }
//
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     formProvider = FormProvider.of(context);
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       if (formProvider != null) {
//         if (widget.validator != null) {
//           final validator = widget.validator!(_controller.text) == null;
//           formProvider?.validator.addAll({key: validator});
//         } else {
//           formProvider?.validator.addAll({key: true});
//         }
//       }
//     });
//     if (formProvider != null) {
//       formProvider?.validator.addAll({key: true});
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: key,
//       child: TextFormField(
//         obscureText: widget.hidePass,
//         maxLength: widget.maxLength,
//         onChanged: widget.textChange,
//         keyboardType: widget.textInputType,
//         controller: TextEditingController(text: widget.initText ?? ''),
//         validator: (value) {
//           if (widget.validator != null) {
//             return widget.validator!(value);
//           }
//           return null;
//         },
//         style: textNormal(
//           widget.color ?? AppTheme.getInstance().getBlackText(),
//           14,
//         ),
//         maxLines: widget.maxLine,
//         decoration: InputDecoration(
//           prefixIcon: widget.prefixIcon,
//           suffixIcon: widget.suffixIcon,
//           border: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: widget.borderColor ??
//                   AppTheme.getInstance().borderColor().withOpacity(0.5),
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(6),
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: widget.focusColor ??
//                   AppTheme.getInstance().borderColor().withOpacity(0.5),
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(6),
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: widget.borderColor ??
//                   AppTheme.getInstance().borderColor().withOpacity(0.5),
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(6),
//             ),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: AppTheme.getInstance().borderColor().withOpacity(0.5),
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(6),
//             ),
//           ),
//           disabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: AppTheme.getInstance().borderColor().withOpacity(0.5),
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(6),
//             ),
//           ),
//           counterText: '',
//           hintText: widget.hintText,
//           hintStyle: textNormal(
//             AppTheme.getInstance().hintTextColor(),
//             14,
//           ),
//         ),
//       ),
//     );
//   }
// }
