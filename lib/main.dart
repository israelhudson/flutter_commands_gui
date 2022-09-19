import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

void main() {
  // This works on Windows/Linux/Mac
  runApp(const MyApp());
}

Future<String> executeShell() async {
  var shell = Shell();
  String result = "nada";

  await shell.run('''echo Hello''').then((value) => result = value.toString());

  shell = shell.popd();

  return result;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeDataTween(
        begin: ThemeData.light(),
        end: ThemeData.dark(),
      ).lerp(1.0),
      home: const MyHomePage(title: 'Flutter Terminal command'),
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
  String returnTerminal = "...";
  int volumeAudio = 0;
  int volumeMic = 0;

  @override
  void initState() {
    super.initState();
    audioVolumeValue();
    micVolumeValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  setMuteSound(isMuted: true);
                },
                child: Icon(Icons.volume_off)),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  setMuteSound(isMuted: false);
                },
                child: Icon(Icons.volume_up)),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  upVolumeAudio();
                },
                child: Text("+")),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  downVolumeAudio();
                },
                child: Text("-")),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Volume audio: $volumeAudio",
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
                onPressed: () {
                  setMuteMic(isMuted: true);
                },
                child: Icon(Icons.mic_off)),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  setMuteMic(isMuted: false);
                },
                child: Icon(Icons.mic)),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  upVolumeMic();
                },
                child: Text("+ mic")),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  downVolumeMic();
                },
                child: Text("- mic")),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Volume mic: $volumeMic",
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              returnTerminal,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        onPressed: () {
          whatchCommand();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void setMuteSound({required bool isMuted}) {
    var shell = Shell();

    shell
        .run("osascript -e 'set volume output muted ${isMuted}'")
        .then((value) {
      setState(() {
        returnTerminal = value[0].outText;
      });
    });

    shell = shell.popd();
  }

  Future<void> audioVolumeValue() async {
    var shell = Shell();

    shell
        .run("osascript -e 'output volume of (get volume settings)'")
        .then((value) {
      setState(() {
        for (var element in value) {
          volumeAudio = int.parse(element.outText);
        }
      });
    });

    shell = shell.popd();
  }

  Future<void> upVolumeAudio() async {
    var shell = Shell();

    shell
        .run("osascript -e 'set volume output volume ${volumeAudio += 5}'")
        .then((value) {
      setState(() {
        audioVolumeValue();
      });
    });

    shell = shell.popd();
  }

  Future<void> downVolumeAudio() async {
    var shell = Shell();

    shell
        .run("osascript -e 'set volume output volume ${volumeAudio -= 5}'")
        .then((value) {
      setState(() {
        audioVolumeValue();
      });
    });

    shell = shell.popd();
  }

  Future<void> upVolumeMic() async {
    var shell = Shell();

    shell
        .run("osascript -e 'set volume input volume ${volumeMic += 5}'")
        .then((value) {
      setState(() {
        micVolumeValue();
      });
    });

    shell = shell.popd();
  }

  Future<void> downVolumeMic() async {
    var shell = Shell();

    shell
        .run("osascript -e 'set volume input volume ${volumeMic -= 5}'")
        .then((value) {
      setState(() {
        micVolumeValue();
      });
    });

    shell = shell.popd();
  }

  Future<void> micVolumeValue() async {
    var shell = Shell();

    shell
        .run("osascript -e 'input volume of (get volume settings)'")
        .then((value) {
      setState(() {
        for (var element in value) {
          volumeMic = int.parse(element.outText);
        }
      });
    });

    shell = shell.popd();
  }

  void setMuteMic({required bool isMuted}) {
    var shell = Shell();

    shell
        .run("osascript -e 'set volume input volume ${isMuted ? 0 : 100}'")
        .then((value) {
      setState(() {
        for (var element in value) {
          setState(() {
            returnTerminal = element.outText;
          });
        }
      });
    });

    shell = shell.popd();
    micVolumeValue();
  }

  void whatchCommand() {
    var shell = Shell();
    shell
        .run(
            "osascript -e 'set volume input volume 0' with administrator privileges")
        .then((value) => print(value));
    //"osascript -e 'tell application \"System Events\" to get name of every process'")

    shell = shell.popd();
  }
}
