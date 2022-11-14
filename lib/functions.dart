import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sndwd_demo/keys.dart';

Future<String> prepareFileDownloadPath({
  required String type,
  required String rootFileName,
  required String rootImageUrl,
  int? episodeIndex,
  String? episodeImageUrl,
}) async {
  if (type == 'tv' && (episodeIndex == null || episodeImageUrl == null)) {
    throw ArgumentError("Episode image or Episode index must not be null");
  }
  try {
    String rootPath = "";
    String episodePath = "";

    if (type == 'tv') {
      episodePath = "$rootFileName/episode$episodeIndex";
    }

    rootPath = rootFileName;

    final directoryRootPath = await localPath(path: rootPath);
    final directoryEpisodePath = await localPath(path: episodePath);

    await _storeString(
        path: "$directoryRootPath/$keyName.txt", value: rootFileName);

    await _storeString(
        path: "$directoryRootPath/$keyType.txt", value: rootFileName);

    await _storeImage(await _downloadImage(rootImageUrl),
        path: "$directoryRootPath/$keyBackdrop.jpg");

    if (type == 'tv') {
      await _storeString(
          path: "$directoryEpisodePath/$keyName.txt",
          value: "Episode $episodeIndex");
      await _storeImage(await _downloadImage(episodeImageUrl!),
          path: "$directoryEpisodePath/$keyBackdrop.jpg");
      return directoryEpisodePath;
    }

    return directoryRootPath;
  } on Exception catch (_) {
    rethrow;
  }
}

Stream<List<FileSystemEntity>> fileStream(
    {Directory? yDir,
    bool changeCurrentPath = true,
    bool reverse = false,
    bool recursive = false,
    bool keepHidden = false}) async* {
  final directory = (await getExternalStorageDirectory())!;

  var dir = yDir ?? directory;
  var files = <FileSystemEntity>[];
  try {
    if (dir.listSync(recursive: recursive).isNotEmpty) {
      if (!keepHidden) {
        yield* dir.list(recursive: recursive).transform(
            StreamTransformer.fromHandlers(
                handleData: (FileSystemEntity data, sink) {
          files.add(data);
          sink.add(files);
        }));
      } else {
        yield* dir.list(recursive: recursive).transform(
            StreamTransformer.fromHandlers(
                handleData: (FileSystemEntity data, sink) {
          if (basename("$data").startsWith('.')) {
            files.add(data);
            sink.add(files);
          }
        }));
      }
    } else {
      yield [];
    }
  } on FileSystemException catch (e) {
    log("$e");
    yield [];
  }
}

Future<String?> downloadFile({
  required String url,
  required String type,
  required String rootFileName,
  required rootImageUrl,
  int? episodeIndex,
  String? episodeImageUrl,
}) async {
  String path = await prepareFileDownloadPath(
      type: type,
      rootFileName: rootFileName,
      rootImageUrl: rootImageUrl,
      episodeImageUrl: episodeImageUrl,
      episodeIndex: episodeIndex);

  final String? taskId = await FlutterDownloader.enqueue(
      url: url, savedDir: path, fileName: rootFileName);

  if (taskId != null) {
    await _storeString(path: "$path/$keyTaskId.txt", value: taskId);
    return taskId;
  }
  throw Exception("Failed to download");
}

Future<String> getCustomPath(String type) async {
  Directory rootDir = await getExternalStorageDirectory() ??
      await getApplicationDocumentsDirectory();

  String rootPath = rootDir.path;
  String path = "$rootPath/$type";

  return (await generateDir(path)).path;
}

Future<Directory> generateDir(String path) async {
  if (await Directory(path).exists()) {
    return Directory(path);
  } else {
    final newDir = await Directory(path).create();
    return newDir;
  }
}

Future<String> localPath({required String path}) async {
  final Directory appDocDir = (await getExternalStorageDirectory())!;

  final Directory appDocDirFolder = Directory("${appDocDir.path}/$path");

  if (await appDocDirFolder.exists()) {
    return appDocDirFolder.path;
  } else {
    final Directory appDocDirNewFolder =
        await appDocDirFolder.create(recursive: true);
    return appDocDirNewFolder.path;
  }
}

Future<Uint8List> _downloadImage(String url) async {
  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;
  return bytes;
}

Future<File> _storeImage(List<int> bytes, {required String path}) async {
  final file = File(path);
  await file.writeAsBytes(bytes, flush: true);
  return file;
}

Future<File> _storeString({required String path, required String value}) async {
  final file = File(path);
  await file.writeAsString(value, flush: true);

  return file;
}

Future<String> readFileAsString(String path) async {
  final file = File(path);
  return await file.readAsString();
}

// Future<void> _deleteFile(String path) async {
//   bool exists = await directoryExists(filename: path);
//   if (exists) {
//     Directory(path).delete();
//   }
//   return;
// }

Future<bool> directoryExists({required String filename}) async {
  final pathName = await localPath(path: filename);

  bool fileExists = await File("$pathName/$filename").exists();
  bool exists = fileExists;
  return exists;
}
