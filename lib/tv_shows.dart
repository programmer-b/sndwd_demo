import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sndwd_demo/components.dart';
import 'package:sndwd_demo/functions.dart';
import 'package:sndwd_demo/utils.dart';

class TvShows extends StatefulWidget {
  const TvShows({super.key});

  @override
  State<TvShows> createState() => _TvShowsState();
}

class _TvShowsState extends State<TvShows> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: ListView.separated(
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seriesData[index]["name"],
                  style: boldTextStyle(),
                ),
                6.height,
                _episodeTile(
                    seriesData[index]["episodes"][0]["thumbnail"],
                    seriesData[index]["episodes"][0]["name"],
                    seriesData[index]["episodes"][0]["url"],
                    context,
                    index,
                    seriesData[index]["name"],
                    seriesData[index]["thumbnail"]),
                _episodeTile(
                    seriesData[index]["episodes"][1]["thumbnail"],
                    seriesData[index]["episodes"][1]["name"],
                    seriesData[index]["episodes"][1]["url"],
                    context,
                    index,
                    seriesData[index]["name"],
                    seriesData[index]["thumbnail"]),
              ],
            );
          },
          separatorBuilder: (context, index) => 8.height,
          itemCount: seriesData.length),
    );
  }
}

Widget _episodeTile(
        String episodeImageUrl,
        String episodeName,
        String episodeUrl,
        BuildContext context,
        int index,
        String seriesName,
        String seriesImageUrl) =>
    Column(
      children: [
        ListTile(
          leading: CachedNetworkImage(
            width: 100,
            height: 60,
            progressIndicatorBuilder: (context, url, progress) => const Center(
              child: CircularProgressIndicator(),
            ),
            imageUrl: episodeImageUrl,
            fit: BoxFit.cover,
          ),
          title: Text(
            episodeName,
            style: boldTextStyle(),
          ),
          trailing: IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => downloadComponent());
                await downloadFile(
                        url: episodeUrl,
                        type: "movie",
                        rootFileName: seriesName,
                        rootImageUrl: seriesImageUrl,
                        episodeIndex: index,
                        episodeImageUrl: episodeImageUrl,
                        seasonIndex: 1)
                    .then((value) => finish(context));
              },
              icon: const Icon(
                Icons.file_download_outlined,
              )),
        ),
        10.height
      ],
    );
