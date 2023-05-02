import 'dart:io';

import 'package:collection/collection.dart';
import 'package:slang/builder/model/i18n_locale.dart';
import 'package:slang/builder/utils/regex_utils.dart';

/// Operations on paths
class PathUtils {
  /// converts /some/path/file.json to file.json
  static String getFileName(String path) {
    return path.replaceAll('\\', '/').split('/').last;
  }

  /// converts /some/path/file.json to file
  static String getFileNameNoExtension(String path) {
    return getFileName(path).split('.').first;
  }

  /// converts /some/path/file.i18n.json to i18n.json
  static String getFileExtension(String path) {
    final fileName = getFileName(path);
    final firstDot = fileName.lastIndexOf('.');
    return fileName.substring(firstDot + 1);
  }

  /// converts /a/b/file.json to [a, b, file.json]
  static List<String> getPathSegments(String path) {
    return path
        .replaceAll('\\', '/')
        .split('/')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  /// converts /a/b/file.json to b
  static String? getParentDirectory(String path) {
    final segments = getPathSegments(path);
    if (segments.length == 1) {
      return null;
    }
    return segments[segments.length - 2];
  }

  /// finds locale in directory path
  /// eg. /en-US/b/file.json will result in en-US
  static I18nLocale? findDirectoryLocale(
      {required String filePath, required String? inputDirectory}) {
    List<String> segments = PathUtils.getPathSegments(filePath);

    // either first directory after inputDirectory, or last directory
    RegExpMatch? match = null;

    if (inputDirectory != null) {
      final inputDirectorySegments = PathUtils.getPathSegments(inputDirectory);
      if (inputDirectorySegments.isNotEmpty &&
          inputDirectorySegments.firstOrNull == segments.firstOrNull &&
          segments.length > inputDirectorySegments.length) {
        match = RegexUtils.localeRegex
            .firstMatch(segments[inputDirectorySegments.length]);
      }
    } else if (segments.length >= 2) {
      match = RegexUtils.localeRegex.firstMatch(segments.first);
    }

    if (match == null && segments.length >= 2) {
      match = RegexUtils.localeRegex.firstMatch(segments[segments.length - 2]);
    }

    if (match == null) {
      return null;
    }

    return I18nLocale(
      language: match.group(1)!,
      script: match.group(2),
      country: match.group(3),
    );
  }

  /// converts /some/path/file.json to /some/path/newFile.json
  static String replaceFileName({
    required String path,
    required String newFileName,
    required String pathSeparator,
  }) {
    final index = path.lastIndexOf(pathSeparator);
    if (index == -1) {
      return newFileName;
    } else {
      return path.substring(0, index + pathSeparator.length) + newFileName;
    }
  }

  /// converts /some/path to /some/path/my_file.json
  static String withFileName({
    required String directoryPath,
    required String fileName,
    required String pathSeparator,
  }) {
    if (directoryPath.endsWith(pathSeparator)) {
      return directoryPath + fileName;
    } else {
      return directoryPath + pathSeparator + fileName;
    }
  }
}

class BuildResultPaths {
  static String mainPath(String outputPath) {
    return outputPath;
  }

  static String localePath({
    required String outputPath,
    required I18nLocale locale,
  }) {
    final fileNameNoExtension = PathUtils.getFileNameNoExtension(outputPath);
    final localeExt = locale.languageTag.replaceAll('-', '_');
    final fileName = '${fileNameNoExtension}_$localeExt.g.dart';
    return PathUtils.replaceFileName(
      path: outputPath,
      newFileName: fileName,
      pathSeparator: '/',
    );
  }

  static String flatMapPath({
    required String outputPath,
  }) {
    final fileNameNoExtension = PathUtils.getFileNameNoExtension(outputPath);
    final fileName = '${fileNameNoExtension}_map.g.dart';
    return PathUtils.replaceFileName(
      path: outputPath,
      newFileName: fileName,
      pathSeparator: '/',
    );
  }
}

// This file is not exported so we can include dart:io
extension RawConfigStringExt on String {
  /// converts to absolute file path
  String toAbsolutePath() {
    String result = this
        .replaceAll('/', Platform.pathSeparator)
        .replaceAll('\\', Platform.pathSeparator);

    if (result.startsWith(Platform.pathSeparator)) {
      result = result.substring(Platform.pathSeparator.length);
    }

    if (result.endsWith(Platform.pathSeparator)) {
      result =
          result.substring(0, result.length - Platform.pathSeparator.length);
    }

    return Directory.current.path + Platform.pathSeparator + result;
  }
}
