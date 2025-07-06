import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart' show MimeTypeResolver;
import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';


// The lib copy by https://github.com/r8/shelf_flutter_asset

const kPackageName = 'webplayer_embedded';

/// The default resolver for MIME types.
final _defaultMimeTypeResolver = MimeTypeResolver();

/// Creates a Shelf [Handler] that serves files from Flutter assets.
///
/// If requested resource does not exist and [defaultDocument] is specified,
/// request path is checked for a resource with that name.
/// If it exists, it is served.
///
/// Specify a custom [contentTypeResolver] to customize automatic content type
/// detection.
Handler createAssetHandler(
    {String? defaultDocument, MimeTypeResolver? contentTypeResolver}) {
  final mimeResolver = contentTypeResolver ?? _defaultMimeTypeResolver;

  return (Request request) async {
    final segments = [
      'packages',
      kPackageName,
      'assets',
      ...request.url.pathSegments
    ];

    String key = p.joinAll(segments);

    Uint8List? body;

    body = await _loadResource(key);

    if (body == null && defaultDocument != null) {
      key = p.join(key, defaultDocument);

      body = await _loadResource(key);
    }

    if (body == null) {
      return Response.notFound('Not Found');
    }

    final contentType = mimeResolver.lookup(key);

    final headers = {
      HttpHeaders.contentLengthHeader: '${body.length}',
      if (contentType != null) HttpHeaders.contentTypeHeader: contentType,
    };

    return Response.ok(body, headers: headers);
  };
}

Future<Uint8List?> _loadResource(String key) async {
  try {
    // Ensure path uses forward slashes for Flutter asset loading
    final normalizedKey = key.replaceAll('\\', '/');
    debugPrint('curr path key: $normalizedKey');
    final byteData = await rootBundle.load(normalizedKey);
    return byteData.buffer.asUint8List();
  } catch (e) {
    debugPrint('Error loading resource: $e');
  }

  return null;
}
