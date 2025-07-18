import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:webplayer_embedded/player_type.dart';

const kWebPlayerEmbeddedPort = 4399;

abstract class IWebPlayerEmbedded {
  Future<HttpServer> createServer({
    int? port,
    ValueChanged<IMessage>? onMessage,
  });

  Future dispose();

  String getRealUrl(IWebPlayerEmbeddedType type);
  String generatePlayerUrl(IWebPlayerEmbeddedType type, String playURL);
  int getRealPort();

  Future<bool> checkRunning();
}
