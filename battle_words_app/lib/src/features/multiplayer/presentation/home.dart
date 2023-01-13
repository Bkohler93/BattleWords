import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class MultiplayerHomePage extends StatefulWidget {
  const MultiplayerHomePage({super.key});

  @override
  State<MultiplayerHomePage> createState() => _MultiplayerHomePageState();
}

class _MultiplayerHomePageState extends State<MultiplayerHomePage> {
  final textController = TextEditingController();
  String message = "";
  late final WebSocketChannel channel;

  @override
  void initState() {
    super.initState();

    //connect websocket
    final wsUrl = Uri.parse('ws://192.168.0.249:8080/ws');
    channel = WebSocketChannel.connect(wsUrl);

    channel.stream.listen((data) {
      setState(() {
        message = data;
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  void sendInput() {
    //send through websocket
    channel.sink.add(textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: ElevatedButton(
            child: Icon(Icons.home),
            onPressed: () => Navigator.of(context).pop(),
          ),
          body: Column(
            children: [
              Spacer(),
              Expanded(
                flex: 2,
                child: Text(
                  message,
                  style: TextStyle(fontSize: 45),
                ),
              ),
              TextField(
                controller: textController,
              ),
              TextButton(onPressed: sendInput, child: Text("Send"))
            ],
          )),
    );
  }
}
