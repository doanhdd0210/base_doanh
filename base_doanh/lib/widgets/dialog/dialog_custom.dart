// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:base_doanh/config/resources/styles.dart';
// import 'package:base_doanh/utils/app_utils.dart';
// import 'package:base_doanh/utils/constants/image_asset.dart';
// import 'package:base_doanh/utils/style_utils.dart';
//
// class DialogCustom extends StatefulWidget {
//   const DialogCustom(
//       {Key? key, this.childrenButton, this.image, this.title, this.description})
//       : super(key: key);
//
//   final Widget? childrenButton;
//   final String? image;
//   final String? title;
//   final String? description;
//
//   @override
//   State<DialogCustom> createState() => _DialogCustomState();
// }
//
// class _DialogCustomState extends State<DialogCustom> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaY: 5.0, sigmaX: 5.0),
//         child: Center(
//           child: GestureDetector(
//             onTap: () {
//               final FocusScopeNode currentFocus = FocusScope.of(context);
//               if (!currentFocus.hasPrimaryFocus) {
//                 currentFocus.unfocus();
//               }
//             },
//             child: Hero(
//               tag: '',
//               createRectTween: (begin, end) {
//                 return CustomRectTween(begin: begin!, end: end!);
//               },
//               child: Material(
//                 color: Colors.white,
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(36),
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 24,
//                   ),
//                   width: getWithSize(context) * 0.9,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: const BorderRadius.all(
//                       Radius.circular(20),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 5,
//                         blurRadius: 4, // changes position of shadow
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (widget.image != null)
//                         ImageAssets.svgAssets(
//                           widget.image!,
//                         ),
//                       Text(
//                         widget.title ?? '',
//                         style: DesignTextStyle.textHeading,
//                         textAlign: TextAlign.center,
//                       ),
//                       spaceH20,
//                       Text(
//                         widget.description ?? '',
//                         style: DesignTextStyle.textBody,
//                         textAlign: TextAlign.center,
//                       ),
//                       spaceH40,
//                       if (widget.childrenButton != null) widget.childrenButton!,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomRectTween extends RectTween {
//   CustomRectTween({
//     required Rect begin,
//     required Rect end,
//   }) : super(begin: begin, end: end);
//
//   @override
//   Rect lerp(double t) {
//     final elasticCurveValue = Curves.easeOut.transform(t);
//     return Rect.fromLTRB(
//       lerpDouble(begin?.left ?? 0, end?.left ?? 0.0, elasticCurveValue) ?? 0,
//       lerpDouble(begin?.top ?? 0.0, end?.top ?? 0.0, elasticCurveValue) ?? 0,
//       lerpDouble(begin?.right ?? 0.0, end?.right ?? 0, elasticCurveValue) ?? 0,
//       lerpDouble(begin?.bottom ?? 0.0, end?.bottom ?? 0.0, elasticCurveValue) ??
//           0,
//     );
//   }
// }
