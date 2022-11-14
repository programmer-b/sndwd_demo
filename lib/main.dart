import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:sndwd_demo/downloads.dart';
import 'package:sndwd_demo/keys.dart';
import 'package:sndwd_demo/movies.dart';
import 'package:sndwd_demo/provider.dart';
import 'package:sndwd_demo/tv_shows.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  FlutterDownloader.registerCallback(MyHomePage.downloadCallback);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName(keyDownloadReport);
    if (send != null) {
      send.send([id, status, progress]);
    }
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _tabs.length, vsync: this);

    IsolateNameServer.registerPortWithName(_port.sendPort, keyDownloadReport);
    _port.listen((dynamic data) {
      context.read<MyProvider>().updateData(data);
      // String id = data[0];
      // DownloadTaskStatus status = data[1];
      // int progress = data[2];

      // log("listening ...");

      // setState(() {
      //   if (id == taskId) {
      //     this.progress = progress;
      //     this.status = status;

      //     if (status == DownloadTaskStatus.complete) {}
      //   }
      // });
    });
    FlutterDownloader.registerCallback(MyHomePage.downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  final List<Tab> _tabs = const [
    Tab(
      child: Text("Movies"),
    ),
    Tab(
      child: Text("Tv Shows"),
    ),
    Tab(
      child: Text("Downloads"),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: null,
          bottom: TabBar(
            tabs: _tabs,
            controller: _controller,
          ),
          elevation: 0,
        ),
        body: TabBarView(
          controller: _controller,
          children: const [Movies(), TvShows(), Downloads()],
        ));
  }
}
