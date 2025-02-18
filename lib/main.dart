// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:ui';
import 'dart:html' as html;
import 'package:flutter/material.dart';

import 'package:it_solution/widgets/image_holder.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

/// [Widget] displaying the home page consisting of an image the the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  final List<String> choices = <String>[
    "Enter fullscreen",
    "Exit fullscreen",
  ];
  GlobalKey key = GlobalKey();
  late final TextEditingController _controller;
  String imageUrl = '';
  OverlayEntry? _overlayEntry;

  bool _isMenuOpen = false;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ImageHolder(
                        url: imageUrl,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(hintText: 'Image URL'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          imageUrl = _controller.text;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
          if (_isMenuOpen)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withAlpha(100),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: key,
        onPressed: () async {
          _showCustomMenu(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCustomMenu(BuildContext context) {
    setState(() {
      _isMenuOpen = true;
    });

    final overlay = Overlay.of(context);

    // Overlay for custom menu
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: _removeOverlay,
          child: Stack(
            children: [
              // Menu over FAB
              Positioned(
                bottom: 100,
                right: 10,
                child: Material(
                  color: Colors.transparent,
                  child: ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Check browser service fullscreen
                              final html.Element? documentElement = html.document.documentElement;
                              if (documentElement != null) {
                                documentElement.requestFullscreen();
                              } else {
                                // Old borwsers
                                html.document.body?.requestFullscreen();
                              }
                              _removeOverlay();
                            },
                            child: Text(
                              'Enter fullscreen',
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                // Check is fullcsren mode is enabled
                                if (html.document.fullscreenElement != null) {
                                  // Exit to normal screen
                                  html.document.exitFullscreen();
                                }
                                _removeOverlay();
                              },
                              child: Text('Exit fullscreen')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  // Remover overlay
  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      setState(() {
        _isMenuOpen = false;
      });
    }
  }
}
