import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

late List<CameraDescription> cameras;
// function to trigger build when the app is run
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeRoute(),
      '/simulator': (context) => const MaculopathySimulator(),
      '/reading_mode': (context) => const ReadingMode(),
      '/simulator_menu': (context) => const MaculopathySimulatorMenu(),
    },
  ));
}

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peripheral Vision'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Maculopathy Simulator'),
              onPressed: () {
                Navigator.pushNamed(context, '/simulator_menu');
              },
            ),
            ElevatedButton(
              child: const Text('Reading Mode'),
              onPressed: () {
                Navigator.pushNamed(context, '/reading_mode');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MaculopathySimulator extends StatefulWidget {
  const MaculopathySimulator({super.key});

  @override
  State<MaculopathySimulator> createState() => _MaculopathySimulator();
}

class _MaculopathySimulator extends State<MaculopathySimulator>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  bool _visible = true;
  late final AnimationController _controller;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _setOrientation(ScreenOrientation.landscapeOnly);
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("access denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _setOrientation(ScreenOrientation.portraitOnly);
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as FromMenuToSimulation;
    return GestureDetector(
      onTap: () {
        print("TAP");
        setState(() => _visible = !_visible);

        if (_visible) {
          print("Visible");
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: SlidingAppBar(
          controller: _controller,
          visible: _visible,
          child: AppBar(
            title: const Text("Maculopathy Simulator"),
            backgroundColor: Colors.green,
          )
        ),
        body: SizedBox(
          height: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Flexible(
                flex: 15,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 400,
                      child: CameraPreview(_cameraController),
                    ),
                    Opacity(
                      opacity: args.opacity / 100,
                      child: Image.asset(
                        args.imageUrl,
                        width: args.resolution,
                        height: args.resolution
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 15,
                child: Stack(
                  alignment: Alignment.center, 
                  children: [
                    SizedBox(
                      height: 300,
                      width: 400,
                      child: CameraPreview(_cameraController),
                    ),
                    Opacity(
                      opacity: args.opacity / 100,
                      child: Image.asset(args.imageUrl,
                        width: args.resolution,
                        height: args.resolution
                      )
                    ),
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}

class ReadingMode extends StatefulWidget {
  const ReadingMode({super.key});

  @override
  State<ReadingMode> createState() => _ReadingModeState();
}

class _ReadingModeState extends State<ReadingMode>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;

  bool _visible = true;
  late final AnimationController _controller;
  final size = const Size(1920, 1080);

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _setOrientation(ScreenOrientation.landscapeOnly);
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    CameraController(cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      _cameraController.value.copyWith(previewSize: size);
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("access denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []);
    _setOrientation(ScreenOrientation.rotating);
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("TAP");
        setState(() => _visible = !_visible);

        if (_visible) {
          print("Visible");
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: SlidingAppBar(
          controller: _controller,
          visible: _visible,
          child: AppBar(
            title: const Text("Reading Mode"),
            backgroundColor: Colors.green,
          )
        ),
        body: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 15,
                child: Stack(
                  alignment: Alignment.center, 
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 195,
                          width: 400,
                          child: CameraPreview(_cameraController),
                        ),
                        SizedBox(
                          width: 400,
                          child: ClipRect(
                            child: Align(
                              heightFactor: 0.35,
                              alignment: Alignment.center,
                              child: CameraPreview(_cameraController),
                            ),
                          )
                        )
                      ]
                    ),
                  ]
                )
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 15,
                child: Stack(
                  alignment: Alignment.center, 
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 195,
                          width: 400,
                          child: CameraPreview(_cameraController),
                        ),
                        SizedBox(
                          width: 400,
                          child: ClipRect(
                            child: Align(
                              heightFactor: 0.35,
                              alignment: Alignment.center,
                              child: CameraPreview(_cameraController),
                            )
                          )
                        )
                      ]
                    )
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}

class MaculopathySimulatorMenu extends StatefulWidget {
  const MaculopathySimulatorMenu({super.key});

  @override
  State<MaculopathySimulatorMenu> createState() =>
      _MaculopathySimulatorMenuState();
}

class _MaculopathySimulatorMenuState extends State<MaculopathySimulatorMenu>
    with SingleTickerProviderStateMixin {
  bool _visible = true;
  double _resolutionValue = 50.0;
  double _opacityValue = 100.0;
  late final AnimationController _controller;
  late String _selectedImageUrl = 'assets/Scotoma01.png';

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _setOrientation(ScreenOrientation.portraitOnly);
    super.initState();
    setState(() {});
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _setOrientation(ScreenOrientation.rotating);
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
      onTap: () {
        print("TAP");
        setState(() => _visible = !_visible);

        if (_visible) {
          print("Visible");
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: SlidingAppBar(
          controller: _controller,
          visible: _visible,
          child: AppBar(
            title: const Text("Maculopathy Simulator Menu"),
            backgroundColor: Colors.green,
          )
        ),
        body: Center(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 80.0),
                  child: const Text("Scotoma shape:"),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 1.0),
                    itemCount: 24,
                    itemBuilder: (BuildContext context, int index) {
                      final imageUrl = 'assets/Scotoma${(index + 1).toString().padLeft(2, '0')}.png';
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImageUrl = imageUrl;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedImageUrl == imageUrl
                                ? Colors.blue
                                : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Image.asset(
                            imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 80.0),
                  child: Text(
                    'Scotoma Size: ${_resolutionValue.toInt()}px \u00d7 ${_resolutionValue.toInt()}px'
                  )
                ),
                Slider(
                  value: _resolutionValue,
                  min: 50.0,
                  max: 400.0,
                  onChanged: (value) {
                    setState(() {
                      _resolutionValue = value;
                    });
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  child: Text(
                    'Scotoma Opacity: ${_opacityValue.toInt()}%'
                  )
                ),
                Slider(
                  value: _opacityValue,
                  min: 0.0,
                  max: 100.0,
                  onChanged: (value) {
                    setState(() {
                      _opacityValue = value;
                    });
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                  child: ElevatedButton(
                    child: const Text("Start Simulation"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/simulator',
                        arguments: FromMenuToSimulation(
                          _resolutionValue,
                          _opacityValue,
                          _selectedImageUrl
                        )
                      );
                    }
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}

enum ScreenOrientation {
  portraitOnly,
  landscapeOnly,
  rotating,
}

void _setOrientation(ScreenOrientation orientation) {
  List<DeviceOrientation> orientations;
  switch (orientation) {
    case ScreenOrientation.portraitOnly:
      orientations = [
        DeviceOrientation.portraitUp,
      ];
      break;
    case ScreenOrientation.landscapeOnly:
      orientations = [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      break;
    case ScreenOrientation.rotating:
      orientations = [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      break;
  }
  SystemChrome.setPreferredOrientations(orientations);
}

class SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SlidingAppBar({
    super.key,
    required this.child,
    required this.controller,
    required this.visible,
  });

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}

class FromMenuToSimulation {
  final double resolution;
  final double opacity;
  final String imageUrl;

  FromMenuToSimulation(this.resolution, this.opacity, this.imageUrl);
}
