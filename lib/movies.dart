import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sndwd_demo/functions.dart';
import 'package:sndwd_demo/utils.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: List<Widget>.generate(
            moviesData.length,
            (index) => _tile(moviesData[index]["thumbnail"],
                moviesData[index]["name"], moviesData[index]["url"])),
      ),
    );
  }

  Widget _tile(String imageUrl, String rootFileName, String url) => Column(
        children: [
          ListTile(
            leading: CachedNetworkImage(
              width: 100,
              height: 60,
              progressIndicatorBuilder: (context, url, progress) =>
                  const Center(
                child: CircularProgressIndicator(),
              ),
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            ),
            title: Text(
              rootFileName,
              style: boldTextStyle(),
            ),
            trailing: IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) => downloadComponent());
                  await downloadFile(
                          url: url,
                          type: "movie",
                          rootFileName: rootFileName,
                          rootImageUrl: imageUrl)
                      .then((value) => finish(context));
                },
                icon: const Icon(
                  Icons.file_download_outlined,
                )),
          ),
          10.height
        ],
      );
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
