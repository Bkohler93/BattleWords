import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class MatchmakingScreen extends StatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  State<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen> {
  final textController = TextEditingController();
  String message = "";
  late final WebSocketChannel channel;

  @override
  void initState() {
    super.initState();

    //connect websocket
    final wsUrl = Uri.parse('ws://${dotenv.env['LOCALIP']}:8080/ws');
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
