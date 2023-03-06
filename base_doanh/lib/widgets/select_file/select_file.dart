import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:base_doanh/config/resources/color.dart';
import 'package:base_doanh/config/resources/styles.dart';
import 'package:base_doanh/config/themes/app_theme.dart';
import 'package:base_doanh/generated/l10n.dart';
import 'package:base_doanh/utils/app_utils.dart';
import 'package:base_doanh/utils/constants/app_constants.dart';
import 'package:base_doanh/utils/constants/image_asset.dart';
import 'package:base_doanh/utils/extensions/string_ext.dart';
import 'package:base_doanh/utils/screen_controller.dart';
import 'package:base_doanh/utils/style_utils.dart';
import 'package:base_doanh/widgets/button/button_custom.dart';
import 'package:base_doanh/widgets/dialog/dialog_utils.dart';
import 'package:base_doanh/widgets/select_file/select_file_cubit.dart';
import 'package:base_doanh/widgets/toast/toast.dart';

class SelectFileButton extends StatefulWidget {
  const SelectFileButton({
    Key? key,
    this.hasMultiFile = true,
    this.maxSize,
    this.allowedExtensions,
    required this.onChange,
    this.initFileSystem,
    this.initFileFromApi,
    this.onDeletedFileApi,
    this.errMultipleFileMessage,
    this.textButton,
    this.iconButton,
    this.replaceFile = false,
    this.overSizeTextMessage,
    this.isShowFile = true,
    this.needClearAfterPick = false,
    this.maxFile,
    this.needResize = true,
    this.checkSizeAllFile = true,
    this.hozirontalView = MainAxisAlignment.start,
    this.buttonView,
    this.typePick = TypePick.IMAGE,
  }) : super(key: key);

  final bool hasMultiFile;
  final bool replaceFile;

  final double? maxSize;
  final List<String>? allowedExtensions;
  final String? textButton;
  final Function(List<File> fileSelected) onChange;
  final List<FileModel>? initFileFromApi;
  final List<File>? initFileSystem;
  final Function(FileModel fileDeleted)? onDeletedFileApi;
  final String? errMultipleFileMessage;
  final String? iconButton;
  final String? overSizeTextMessage;
  final bool isShowFile;
  final bool needClearAfterPick;
  final int? maxFile;
  final bool needResize;
  final bool checkSizeAllFile;
  final MainAxisAlignment hozirontalView;
  final Widget? buttonView;
  final TypePick typePick;

  @override
  State<SelectFileButton> createState() => SelectFileButtonState();
}

class SelectFileButtonState extends State<SelectFileButton> {
  final SelectFileCubit cubit = SelectFileCubit();
  Directory? pathTmp;
  late final List<String> allowedExtensions;

  @override
  void initState() {
    super.initState();
    cubit.filesFromApi.addAll(widget.initFileFromApi ?? []);
    cubit.fileFromApiSubject.add(cubit.filesFromApi);
    cubit.selectedFiles.addAll(widget.initFileSystem ?? []);
    getTemporaryDirectory().then((value) => pathTmp = value);
    allowedExtensions = widget.allowedExtensions ??
        const [
          FileExtension.HEIC,
          FileExtension.JPG,
          FileExtension.JPEG,
          FileExtension.PNG,
        ];
    for (final element in allowedExtensions) {
      element.toLowerCase();
    }
  }


  Future<List<File>> pickFile() async {
    List<File> filePicked = [];
    if (widget.typePick == TypePick.FILE) {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: widget.hasMultiFile,
        allowedExtensions: allowedExtensions,
        type: widget.allowedExtensions?.isNotEmpty ?? true
            ? FileType.custom
            : FileType.any,
      );
      filePicked =
          result?.files.map((file) => File(file.path ?? '')).toList() ?? [];
    } else {
      final ImagePicker picker = ImagePicker();
      if (Platform.isIOS) {
        final filesPicked = await picker.pickMultiImage();
        filePicked = filesPicked.map((file) => File(file.path)).toList();
      } else {
        filePicked = await pickImageOnAndroid();
      }
    }
    return filePicked;
  }

  Future<List<File>> pickImageOnAndroid() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final filesPicked =
          result.files.map((file) => File(file.path ?? '')).toList();
      return filesPicked;
    }
    return [];
  }

  bool checkMultipleFile() {
    if (!widget.hasMultiFile &&
        (cubit.selectedFiles.isNotEmpty || cubit.filesFromApi.isNotEmpty) &&
        !widget.replaceFile) {
      showToast(
        message: widget.errMultipleFileMessage ?? '',
      );
      return false;
    }
    return true;
  }

  Future<List<File>> resizeAllFile(List<File> file) async {
    if (!widget.needResize) {
      return file;
    }

    final List<File> fileResized = [];
    cubit.showLoading.add(true);
    await Future.wait(
      file.map((file) {
        return resizeImage(file.path).then(
          (value) => fileResized.add(File(value)),
        );
      }).toList(),
    );
    cubit.showLoading.add(false);
    return fileResized;
  }

  void removeFileInvalidFormat(List<File> file) {
    file.removeWhere(
      (element) {
        final result = !allowedExtensions.contains(
          path.extension(element.path).replaceAll('.', '').toLowerCase(),
        );
        if (result) {
          showToast(
            message: S.current.error, ///todo
          );
        }
        return result;
      },
    );
  }

  Future<List<File>> moveAllToTmp(List<File> files) async {
    if (Platform.isAndroid) {
      return files;
    }

    final List<File> newFiles = [];
    await Future.wait(
      files.map(
        (file) => moveFile(
          File(file.path),
          '${pathTmp?.path}/${path.basename(file.path)}',
        ).then(
          (newFile) => newFiles.add(newFile),
        ),
      ),
    );
    return newFiles;
  }

  Future<bool> checkSizeAll(List<File> files) async {
    if (widget.maxSize == null) {
      return true;
    }

    if (!widget.checkSizeAllFile) {
      /// Check size each file
      bool isOverMaxSize = false;
      files.removeWhere((file) {
        if (file.lengthSync() > widget.maxSize!) {
          isOverMaxSize = true;
        }
        return file.lengthSync() > widget.maxSize!;
      });
      if (isOverMaxSize) {
        showToast(
          message: widget.overSizeTextMessage ?? S.current.error, ///todo
        );
        return false;
      }
      return true;
    } else {
      /// Check size all file
      final bool isOverMaxSize = cubit.checkOverMaxSize(
        maxSize: widget.maxSize,
        newFiles: files,
      );
      if (isOverMaxSize) {
        showToast(
          message: widget.overSizeTextMessage ?? S.current.error, //todo
        );
        return false;
      }
      return true;
    }
  }

  Future<void> handleButtonFileClicked() async {
    /// Check max file
    if (widget.maxFile != null &&
        cubit.selectedFiles.length >= widget.maxFile!) {
      showToast(
        message: '${S.current.error} ${widget.maxFile} files /'  ///todo upload_up_to
            ' ${S.current.error} ${widget.maxFile} files', ///todo no_more_than
      );
      return;
    }

    final result = await pickFile();
    if (result.isEmpty) {
      return;
    }

    /// Check if not enable pick multiple file
    final checkMultiple = checkMultipleFile();
    if (!checkMultiple) {
      return;
    }

    // Remove file invalid format
    removeFileInvalidFormat(result);

    /// Resize file
    final fileResized = await resizeAllFile(result);

    /// Move file to Temporary Directory
    final fileMoved = await moveAllToTmp(fileResized);

    if (widget.replaceFile) {
      cubit.selectedFiles.clear();
    }

    // Check size
    final checkSize = await checkSizeAll(fileMoved);
    if (!checkSize) {
      return;
    }

    if (widget.replaceFile) {
      cubit.selectedFiles = fileMoved;
    } else {
      cubit.selectedFiles.addAll(fileMoved);
    }

    if (widget.isShowFile) {
      cubit.needRebuildListFile.sink.add(true);
    }

    widget.onChange(cubit.selectedFiles);

    if (widget.needClearAfterPick) {
      await Future.delayed(const Duration(milliseconds: 1000), () {
        cubit.selectedFiles.clear();
      });
    }
  }

  void showToast({required String message}) {
    showToastCoral(context, message: message);
  }

  /// On IOS, after 1 minutes file will be remove automatics
  /// so we need move file to Temporary Directory
  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      return await sourceFile.rename(newPath);
    } catch (e) {
      final newFile = await sourceFile.copy(newPath);
      return newFile;
    }
  }

  /// Resize Image
  Future<String> resizeImage(String filePath) async {
    String path = filePath;
    final file = File(path);
    int length = file.lengthSync();
    if (length <= FileSize.SIZE_5_MB) {
      return filePath;
    }
    while (length > FileSize.SIZE_5_MB) {
      final File result = await FlutterNativeImage.compressImage(
        path,
      );
      length = result.lengthSync();
      path = result.path;
    }
    return path;
  }

  Future<bool> handleFilePermission() async {
    final PermissionStatus permission;
    if (Platform.isAndroid && await getAndroidOSVersion() < 33) {
      permission = await Permission.storage.request();
    } else {
      permission = await Permission.photos.request();
    }
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.permanentlyDenied) {
      return false;
    } else {
      return true;
    }
  }

  void showSettingDialog() {
    DialogUtils.showCoralDialog(
      contentWidget: Text(
        S.current.allow_permission,  // todo allow_permission
        style: TextStyleCustom.textMedium14.copyWith(
          color: colorBlack85,
        ),
        textAlign: TextAlign.center,
      ),
      content: '',
      negative: S.current.cancel,
      positive: S.current.go_to_setting,
      positiveClick: () {
        closeScreen(context);
        openAppSettings();
      },
      negativeClick: () {
        closeScreen(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TODO: chưa thấy có design chung, vẽ lại theo design nếu cần
        if (widget.buttonView != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final permission = await handleFilePermission();
              if (permission) {
                unawaited(handleButtonFileClicked());
              } else {
                showSettingDialog();
              }
            },
            child: widget.buttonView,
          )
        else
          ButtonCustom(
            onPressed: () async {
              final permission = await handleFilePermission();
              if (permission) {
                unawaited(handleButtonFileClicked());
              } else {
                showSettingDialog();
              }
            },
            text: 'Attachment',
            // colorBtn: Colors.transparent,
          ),
        if (widget.isShowFile) ...[
          StreamBuilder<List<FileModel>>(
            stream: cubit.fileFromApiSubject.stream,
            builder: (context, snapshot) {
              final listFile = snapshot.data ?? [];
              return Column(
                children: listFile
                    .map(
                      (file) => itemListFile(
                        onDelete: () {
                          cubit.filesFromApi.remove(file);
                          cubit.fileFromApiSubject.sink.add(cubit.filesFromApi);
                          widget.onDeletedFileApi?.call(file);
                        },
                        fileName: file.name.convertNameFile(),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          spaceH16,
          StreamBuilder(
            stream: cubit.needRebuildListFile.stream,
            builder: (context, snapshot) {
              return Column(
                children: cubit.selectedFiles
                    .map(
                      (file) => itemListFile(
                        onDelete: () {
                          cubit.selectedFiles.remove(file);
                          cubit.needRebuildListFile.add(true);
                          widget.onChange(cubit.selectedFiles);
                        },
                        fileName: file.path.convertNameFile(),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          StreamBuilder<bool>(
            stream: cubit.showLoading,
            builder: (context, snapshot) {
              final showLoading = snapshot.data ?? false;
              return showLoading
                  ? const SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ],
    );
  }

  Widget itemListFile({
    required String fileName,
    required Function() onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            fileName,
            style: TextStyleCustom.textMedium14.copyWith(),
          ),
          spaceW8,
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              onDelete();
            },
            child: SvgPicture.asset(
              ImageAssets.ic_close,
              width: 10,
              height: 10,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class FileModel {
  String id;
  String name;
  String path;
  double fileLength;

  FileModel({
    this.id = '',
    this.name = '',
    this.path = '',
    this.fileLength = 0,
  });
}

enum TypePick {
  IMAGE,
  FILE,
}
