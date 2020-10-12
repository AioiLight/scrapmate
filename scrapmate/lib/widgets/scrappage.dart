import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrapmate/const.dart';
import 'package:scrapmate/scrap.dart';
import 'package:scrapmate/view.dart';

class ScrapPage extends StatefulWidget {
  ScrapPage({this.title, this.lead, this.thumbnail, this.id, this.projectUrl});

  final String title;
  final String lead;
  final String thumbnail;
  final String id;
  final String projectUrl;

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
            ? CachedNetworkImage(
                imageUrl: widget.thumbnail,
                errorWidget: (context, url, error) => Text(widget.lead))
            : Text(widget.lead),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScrapView(
                      title: widget.title, projectName: widget.projectUrl)))
        },
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
}
