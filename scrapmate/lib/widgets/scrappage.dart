import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrapmate/util.dart';

class ScrapPage extends StatelessWidget {
  ScrapPage(
      {this.title,
      this.lead,
      this.thumbnail,
      this.id,
      this.projectUrl,
      this.pin,
      this.showImage,
      Key key})
      : super(key: key);

  final String title;
  final String lead;
  final String thumbnail;
  final String id;
  final String projectUrl;
  final bool pin;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Stack(children: [
          ListTile(
            title: Text(title),
            subtitle: (thumbnail != null && showImage)
                ? CachedNetworkImage(
                    imageUrl: thumbnail,
                    errorWidget: (context, url, error) => Text(lead))
                : Text(lead),
          ),
          if (pin)
            const Positioned(
              child: Icon(Icons.push_pin),
              right: 0,
              bottom: 0,
            )
        ]),
        onTap: () => Util.openScrapPage(context, title, projectUrl),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
}
