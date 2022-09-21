import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

class CommandsPage extends StatefulWidget {
  const CommandsPage({Key? key}) : super(key: key);

  @override
  State<CommandsPage> createState() => _CommandsPageState();
}

class _CommandsPageState extends State<CommandsPage> {
  String returnTerminal = "...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Commands"),
      ),
      body: Column(
        children: [
          Center(
            child: Text(returnTerminal),
          ),
          ElevatedButton(
              onPressed: () async {
                await Future.wait([
                  execCommand(command: "adb tcpip 5555"),
                  execCommand(command: "adb connect 192.168.1.5:5555"),
                  execCommand(command: "scrcpy --tcpip=192.168.1.5")
                ]);
              },
              child: const Text("exec")),
        ],
      ),
    );
  }

  Future<void> execCommand({required String command}) async {
    var shell = Shell();

    shell.run(command).then((value) {
      setState(() {
        for (var element in value) {
          setState(() {
            returnTerminal = element.outText;
          });
        }
      });
    });

    shell = shell.popd();
  }
}
