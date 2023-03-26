import 'package:battle_words/src/features/multiplayer/data/setup_repository.dart';
import 'package:battle_words/src/api/web_socket_channel/web_socket_manager.dart';
import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SetupRepository(webSocketManager: WebSocketManager()),
      child: BlocProvider<SetupBloc>(
        create: (context) => SetupBloc(setupRepo: RepositoryProvider.of<SetupRepository>(context))
          ..add(InitializeSetup()),
        child: const SetupView(),
      ),
    );
  }
}

class SetupView extends StatelessWidget {
  const SetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SetupBloc, SetupState>(
      listener: (context, state) {
        if (state.isServerSaidHi) {
          print("server said hi!");
        }
      },
      child: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => BlocProvider.of<SetupBloc>(context).add(PressButton()),
                child: Text('Communicate with server')),
            Text("Hi! Let's setup!"),
          ],
        ),
      ),
    );
  }
}
