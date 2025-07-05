/// 播放器类型
enum IWebPlayerEmbeddedType {
  /// MUI播放器
  mui,

  /// P2P播放器
  p2p,

  /// P2P播放器-GO
  p2pGO,

  /// P2P播放器-HLS
  p2pHLS,
}

class IMessage {
  IMessage({required this.type, required this.value});

  final String type;
  final String value;
}

extension WebPlayerEmbeddedTypeStr on IWebPlayerEmbeddedType {
  String get toHuman {
    switch (this) {
      case IWebPlayerEmbeddedType.mui:
        return 'MUI播放器';
      case IWebPlayerEmbeddedType.p2p:
        return 'P2P播放器';
      case IWebPlayerEmbeddedType.p2pGO:
        return 'P2P播放器-GO';
      case IWebPlayerEmbeddedType.p2pHLS:
        return 'P2P播放器-HLS';
    }
  }
}
