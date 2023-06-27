import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webplayer_embedded/webplayer_embedded.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final webPlayer = WebPlayerEmbedded();
  final textEditingController = TextEditingController();
  bool isRunning = false;

  String get runningText => isRunning ? '已开启' : '已关闭';

  updateRunningStatus() async {
    isRunning = await webPlayer.checkRunning();
    setState(() {});
  }

  List<Map<String, dynamic>> menus = [
    {"key": "MUI播放器", "e": IWebPlayerEmbeddedType.mui},
    {"key": "P2P播放器", "e": IWebPlayerEmbeddedType.p2p},
    {"key": "P2P播放器-GO", "e": IWebPlayerEmbeddedType.p2pGO},
    {"key": "P2P播放器-HLS", "e": IWebPlayerEmbeddedType.p2pHLS},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                keyboardType: TextInputType.number,
                controller: textEditingController,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("当前状态: $runningText"),
              ),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () async {
                      if (await webPlayer.checkRunning()) return;
                      var currPort = textEditingController.text;
                      if (currPort.isEmpty) return;
                      var newPort = int.parse(currPort);
                      await webPlayer.createServer(port: newPort);
                      await updateRunningStatus();
                    },
                    child: const Text("打开服务器"),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (await webPlayer.checkRunning()) {
                        await webPlayer.dispose();
                      }
                      updateRunningStatus();
                    },
                    child: const Text("关闭服务器"),
                  ),
                ],
              ),
              const Divider(),
              Opacity(
                opacity: isRunning ? 1 : 0.5,
                child: Row(
                  children: menus.map((item) {
                    return MouseRegion(
                      cursor: isRunning
                          ? SystemMouseCursors.click
                          : SystemMouseCursors.forbidden,
                      child: GestureDetector(
                        onTap: isRunning
                            ? () {
                                var e = item["e"];
                                var targetURL = webPlayer.generatePlayerUrl(
                                  e,
                                  "https://vod2.bdzybf7.com/20220330/pFuZoqdd/index.m3u8",
                                );
                                var url0 = Uri.parse(targetURL);
                                launchUrl(url0);
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item['key']),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
