import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:webplayer_embedded/player_type.dart';

abstract class IWebPlayerEmbedded {
  Future<HttpServer> createServer({ValueChanged<IMessage>? onMessage});

  Future dispose();

  String getRealUrl(IWebPlayerEmbeddedType type);
  String generatePlayerUrl(IWebPlayerEmbeddedType type, String playURL);

  Future<bool> checkRunning();
}
