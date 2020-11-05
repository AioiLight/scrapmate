import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrapmate/util.dart';

class ScrapPage extends StatefulWidget {
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
  _ScrapPageState createState() => _ScrapPageState();
}

class _ScrapPageState extends State<ScrapPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Stack(children: [
          ListTile(
            title: Text(widget.title),
            subtitle: (widget.thumbnail != null && widget.showImage)
                ? CachedNetworkImage(
                    imageUrl: widget.thumbnail,
                    errorWidget: (context, url, error) => Text(widget.lead))
                : Text(widget.lead),
          ),
          if (widget.pin)
            const Positioned(
              child: Icon(Icons.push_pin),
              right: 0,
              bottom: 0,
            )
        ]),
        onTap: () =>
            Util.openScrapPage(context, widget.title, widget.projectUrl),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
}
