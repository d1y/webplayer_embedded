import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                controller: textEditingController,
              ),
              Text("当前状态: $runningText"),
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
        ),
      ),
    );
  }
}
