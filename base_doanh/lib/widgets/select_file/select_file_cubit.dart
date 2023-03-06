import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:base_doanh/utils/constants/app_constants.dart';
import 'package:base_doanh/widgets/select_file/select_file.dart';

class SelectFileCubit {
  BehaviorSubject<bool> needRebuildListFile = BehaviorSubject();
  BehaviorSubject<List<FileModel>> fileFromApiSubject = BehaviorSubject();
  BehaviorSubject<bool> showLoading = BehaviorSubject();

  List<FileModel> filesFromApi = [];
  List<File> selectedFiles = [];

  bool checkOverMaxSize({double? maxSize, List<File>? newFiles}) {
    double totalSize = 0;
    for (final file in selectedFiles) {
      totalSize += file.lengthSync();
    }
    for (final file in newFiles ?? []) {
      totalSize += (file as File).lengthSync();
    }

    return totalSize > (maxSize ?? FileSize.SIZE_5_MB);
  }
}
