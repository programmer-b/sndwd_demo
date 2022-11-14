import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:provider/provider.dart';
import 'package:sndwd_demo/provider.dart';

import 'functions.dart';
import 'keys.dart';

class MyMovieTile extends StatefulWidget {
  const MyMovieTile(
      {super.key,
      required this.taskId,
      required this.tasks,
      required this.path});
  final String taskId;
  final List<DownloadTask> tasks;
  final String path;

  @override
  State<MyMovieTile> createState() => _MyMovieTileState();
}

class _MyMovieTileState extends State<MyMovieTile> {
  int? progress;
  DownloadTaskStatus? status;

  late List<DownloadTask> tasks = widget.tasks;
  late String taskId = widget.taskId;
  late String path = widget.path;

  void _setInitialConfigs() {
    for (var task in tasks) {
      if (task.taskId == taskId) {
        progress = task.progress;
        status = task.status;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _setInitialConfigs();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<MyProvider>().data;

    log("TASK ID: $taskId");

    if (data != null) {
      if (data[0] == taskId) setState(() => progress = data[2]);
    }

    log("$data");
    return _movieTile(path);
  }

  Widget _fileImage(String path) => Image.file(
        File(
          "$path/$keyBackdrop.jpg",
        ),
        width: 100,
        fit: BoxFit.cover,
      );

  Widget _fileText(String path) => FutureBuilder(
      future: readFileAsString("$path/$keyName.txt"),
      builder: (context, snap) {
        if (snap.hasData) {
          return Text("${snap.data}");
        }
        return Container();
      });

  Widget _movieTile(String path) => Builder(builder: (context) {
        return ListTile(
          leading: _fileImage(path),
          title: _fileText(path),
          trailing: Text("$progress"),
        ).paddingSymmetric(vertical: 10);
      });

  Widget _tvTile() => Builder(builder: (context) {
        return ListTile();
      });
}
