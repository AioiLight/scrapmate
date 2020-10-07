import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/scrap.dart';

class ScrapPage extends StatefulWidget {
  ScrapPage({this.title, this.lead, this.thumbnail, this.id});

  final String title;
  final String lead;
  final String thumbnail;
  final String id;

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
      child: ListTile(
        title: Text(widget.title),
        subtitle: widget.thumbnail != null
            ? Image(image: CachedNetworkImageProvider(widget.thumbnail))
            : Text(widget.lead),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
}
