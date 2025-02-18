import 'package:web/web.dart' as web;
import 'dart:js' as js;

import 'package:flutter/material.dart';

/// [HtmlElementView] widget to hold image from url
class ImageHolder extends StatefulWidget {
  const ImageHolder({required this.url, super.key});

  final String url;

  @override
  State<ImageHolder> createState() => _ImageHolderState();
}

class _ImageHolderState extends State<ImageHolder> {
  late String _currentUrl;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
  }

  @override
  void didUpdateWidget(covariant ImageHolder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      setState(() {
        _currentUrl = widget.url; // Zaktualizuj URL
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _currentUrl.isEmpty
        ? Center(
            child: Icon(
              Icons.broken_image,
              size: 100,
            ),
          )
        : HtmlElementView.fromTagName(
            key: ValueKey(_currentUrl),
            tagName: 'div',
            onElementCreated: (element) {
              element as web.HTMLDivElement;
              element.style.width = '100%';
              element.style.height = '100%';
              element.style.display = 'flex';
              element.style.borderRadius = "12px";
              element.style.justifyContent = 'center';
              element.style.alignItems = 'center';
              element.style.overflow = 'hidden';

              // Create <img> tag and ad to <div> tag
              final img = web.HTMLImageElement()
                ..src = _currentUrl
                ..style.width = '100%'
                ..style.height = '100%'
                ..style.cursor = 'pointer';

              element.append(img);

              // Double-click to invoke js function
              img.onDoubleClick.listen((_) {
                js.context.callMethod('toggleFullScreen', [element]);
              });
            },
          );
  }
}
