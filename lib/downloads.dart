import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:sndwd_demo/components.dart';
import 'package:sndwd_demo/functions.dart';


class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {

  @override
  void initState() {
    super.initState();
    init();


  }

  List<DownloadTask> tasks = [];

  Future<void> init() async {
    tasks = await FlutterDownloader.loadTasks() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    log("TASKS: $tasks");
    return Container(
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<List<FileSystemEntity>>(
        stream: fileStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<FileSystemEntity> files = snapshot.data ?? [];
            return Column(
              children: [
                for (var file in files)
                  MyMovieListener(
                    path: file.path,
                    tasks: tasks,
                  )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
