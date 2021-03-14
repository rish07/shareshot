library shareshot;

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ShareShot extends StatefulWidget {
  final BuildContext context;
  final Widget child;
  final int number;
  final GlobalKey containerKey;
  final String title;

  const ShareShot(
      {Key key,
      this.context,
      this.number,
      this.containerKey,
      this.child,
      this.title})
      : super(key: key);

  shareTheShot({@required GlobalKey containerKe}) =>
      createState().createShareShot(
          child: child,
          containerKey: containerKe,
          context: context,
          title: title);
  @override
  _ShareShotState createState() => _ShareShotState();
}

class _ShareShotState extends State<ShareShot> {
  void createShareShot({
    @required Widget child,
    @required BuildContext context,
    @required GlobalKey containerKey,
    @required String title,
  }) async {
    Timer(Duration(seconds: 2), () {
      return shareShot(
          child: child,
          context: context,
          containerKey: containerKey,
          title: title);
    });
  }

  static Future shareShot(
      {@required Widget child,
      @required BuildContext context,
      @required GlobalKey containerKey,
      String title}) async {
    RenderRepaintBoundary renderRepaintBoundary =
        containerKey.currentContext.findRenderObject();
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 1);
    ByteData byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uInt8List = byteData.buffer.asUint8List();
    try {
      await Share.file("", 'shareShot.png', uInt8List, 'image/png',
          text: title ?? " ");
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.containerKey,
      child: widget.child,
    );
  }
}
