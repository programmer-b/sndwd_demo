import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sndwd_demo/components.dart';
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


