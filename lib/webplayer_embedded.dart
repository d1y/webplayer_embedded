library webplayer_embedded;

import 'dart:io';

import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:webplayer_embedded/player_abs.dart';
import 'package:webplayer_embedded/player_type.dart';
import 'package:webplayer_embedded/shelf_flutter_asset.dart';

class WebPlayerEmbedded implements IWebPlayerEmbedded {
  int _port = 0;
  HttpServer? _server;

  @override
  Future<bool> checkRunning() async {
    return _server != null;
  }

  @override
  int getRealPort() {
    return _port;
  }

  @override
  Future<HttpServer> createServer({int? port}) async {
    var realPort = port ?? kWebPlayerEmbeddedPort;
    var ctx = _run(realPort);
    _port = realPort;
    return ctx;
  }

  Future<HttpServer> _run(int port) async {
    var app = Router();
    final assetHandler = createAssetHandler(defaultDocument: 'index.htm');

    app.get('/assets/<ignored|.*>', (Request request) {
      return assetHandler(request.change(path: 'assets'));
    });

    _server = await io.serve(app, 'localhost', port);
    return _server!;
  }

  @override
  dispose() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
    }
  }

  @override
  generatePlayerUrl(IWebPlayerEmbeddedType type, String playURL) {
    var url = getRealUrl(type);
    return '$url?url=$playURL';
  }

  @override
  getRealUrl(IWebPlayerEmbeddedType type) {
    var prefix = "http://localhost:$_port/";
    switch (type) {
      case IWebPlayerEmbeddedType.mui:
        return '${prefix}mui/index.html';
      case IWebPlayerEmbeddedType.p2p:
        return '${prefix}p2p-media-loader/p2pm3u8.html';
      case IWebPlayerEmbeddedType.p2pHLS:
        return '${prefix}p2phls.html/p2phls.html';
      case IWebPlayerEmbeddedType.p2pGO:
        return '${prefix}p2pplayer/index.htm';
    }
  }
}
