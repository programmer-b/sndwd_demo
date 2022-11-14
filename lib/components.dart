import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:sndwd_demo/functions.dart';
import 'package:sndwd_demo/keys.dart';
import 'package:sndwd_demo/my_movie_tile.dart';

class MyMovieListener extends StatelessWidget {
  const MyMovieListener({super.key, required this.path, required this.tasks});
  final String path;
  final List<DownloadTask> tasks;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: readFileAsString("$path/$keyTaskId.txt"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final String? taskId = snapshot.data;
            if (taskId == null) throw "Task ID not specified";
            return MyMovieTile(taskId: taskId, tasks: tasks, path: path);
          }
          return Container();
        });
  }
}

Widget downloadComponent() => Container(
      decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpinKitFadingCircle(
            color: Colors.white,
          ),
          8.height,
          Text(
            "Preparing download ...",
            style: primaryTextStyle(color: Colors.white),
          )
        ],
      ),
    );
