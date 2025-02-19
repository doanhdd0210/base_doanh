import 'dart:io';
import 'package:hapycar/config/themes/app_theme.dart';
import 'package:hapycar/utils/screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_view/photo_view.dart';
import '../../config/resources/styles.dart';
import '../../presentation/language/language_data.dart';
import '../../utils/style_utils.dart';
import '../back/icon_back.dart';
import '../button/button_custom.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class PreviewImage extends StatefulWidget {
  const PreviewImage({
    Key? key,
    required this.file,
    this.isNetwork = false,
  }) : super(key: key);
  final File file;
  final bool isNetwork;

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getInstance().primaryColor(),
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spaceH16,
                IconBack(),
                spaceH24,
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    Lang.key(keyT.PREVIEW_AVATAR_IMAGE),
                    style: TextStyleCustom.f22w600.copyWith(
                      color: AppTheme.getInstance().whiteColor(),
                    ),
                  ),
                ),
                spaceH50,
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.hardEdge,
                    height: MediaQuery.of(context).size.width - 50,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: RepaintBoundary(
                        key: _globalKey,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: PhotoView(
                            imageProvider: widget.isNetwork
                                ? NetworkImage(widget.file.path)
                                : FileImage(widget.file) as ImageProvider,
                            minScale: PhotoViewComputedScale.covered * 1,
                            // maxScale: PhotoViewComputedScale.covered * 2.0,
                            backgroundDecoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ButtonCustom(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    size: ButtonSize.LARGE,
                    text: Lang.key(keyT.FINISH),
                    background: AppTheme.getInstance().whiteColor(),
                    textColor: AppTheme.getInstance().primaryColor(),
                    onPressed: () async {
                      final result = await _captureRenderObject();
                      if (result != null) {
                        closeScreenWithData(context, result);
                      } else {
                        closeScreen(context);
                      }
                    }),
                spaceH32,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> _captureRenderObject() async {
    RenderRepaintBoundary? boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 1.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    return pngBytes;
  }
}
