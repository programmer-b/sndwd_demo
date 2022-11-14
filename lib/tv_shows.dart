import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
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
                _episodeTile(seriesData[index]["episodes"][0]["thumbnail"],
                    seriesData[index]["episodes"][0]["name"]),
                _episodeTile(seriesData[index]["episodes"][1]["thumbnail"],
                    seriesData[index]["episodes"][1]["name"]),
              ],
            );
          },
          separatorBuilder: (context, index) => 8.height,
          itemCount: seriesData.length),
    );
  }
}

Widget _episodeTile(String url, String name) => Column(
      children: [
        ListTile(
          leading: CachedNetworkImage(
            width: 100,
            height: 60,
            progressIndicatorBuilder: (context, url, progress) => const Center(
              child: CircularProgressIndicator(),
            ),
            imageUrl: url,
            fit: BoxFit.cover,
          ),
          title: Text(
            name,
            style: boldTextStyle(),
          ),
          trailing: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.file_download_outlined,
              )),
        ),
        10.height
      ],
    );
