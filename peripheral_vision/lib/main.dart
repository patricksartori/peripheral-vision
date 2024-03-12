import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

late List<CameraDescription> cameras;
// function to trigger build when the app is run
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeRoute(),
      '/second': (context) => const SecondRoute(),
      '/third': (context) => const ThirdRoute(),
    },
  )); //MaterialApp
}

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geeks for Geeks'),
        backgroundColor: Colors.green,
      ), // AppBar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Simulator'),
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('Tap Me!'),
              onPressed: () {
                Navigator.pushNamed(context, '/third');
              },
            ), // ElevatedButton
          ], // <Widget>[]
        ), // Column
      ), // Center
    ); // Scaffold
  }
}

class SecondRoute extends StatefulWidget {
  const SecondRoute({super.key});

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute>
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
    //final size = Size(1920, 1080);
    _cameraController.initialize().then((_) {
      //_cameraController.value = _cameraController.value.copyWith(previewSize: size);
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
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _setOrientation(ScreenOrientation.rotating);

    super.dispose();
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
          //print(_visible);
        },
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: SlidingAppBar(
                controller: _controller,
                visible: _visible,
                child: AppBar(
                  title: const Text("Camera Page"),
                  backgroundColor: Colors.green,
                )),
            body: Expanded(
                child: Row(
              children: [
                Flexible(
                    flex: 10,
                    child: AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: CameraPreview(_cameraController),
                    )),
                Spacer(
                  flex: 1,
                ),
                Flexible(
                  flex: 10,
                  child: AspectRatio(
                    aspectRatio: _cameraController.value.aspectRatio,
                    child: CameraPreview(_cameraController),
                  ),
                ),
              ],
            ))));
  }
}

class ThirdRoute extends StatefulWidget {
  const ThirdRoute({super.key});

  State<ThirdRoute> createState() => _ThirdRouteState();
}

class _ThirdRouteState extends State<ThirdRoute>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  late CameraController _bottomCameraController;

  bool _visible = true;
  late final AnimationController _controller;
  final size = Size(1920, 1080);

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _setOrientation(ScreenOrientation.landscapeOnly);
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    _bottomCameraController =
        CameraController(cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      _bottomCameraController.value =
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
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _setOrientation(ScreenOrientation.rotating);

    super.dispose();
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
          //print(_visible);
        },
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: SlidingAppBar(
                controller: _controller,
                visible: _visible,
                child: AppBar(
                  title: const Text("Camera Page"),
                  backgroundColor: Colors.green,
                )),
            body: Expanded(
                child: Row(
              children: [
                Flexible(
                    flex: 10,
                    child: Column(children: [
                      Flexible(
                          flex: 2,
                          child: AspectRatio(
                            aspectRatio: _cameraController.value.aspectRatio,
                            child: CameraPreview(_cameraController),
                          )),
                      Flexible(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio:  _cameraController.value.aspectRatio,
                    child: CameraPreview(_cameraController),
                    )),
                    ])),
                Spacer(
                  flex: 1,
                ),
                Flexible(
                    flex: 10,
                    child: Column(children: [
                      Flexible(
                          flex: 2,
                          child: AspectRatio(
                            aspectRatio: _cameraController.value.aspectRatio,
                            child: CameraPreview(_cameraController),
                          )),
Flexible(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio:  _cameraController.value.aspectRatio,
                    child: CameraPreview(_cameraController),
                    )),
                    ])),
              ],
            ))));
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
      position: Tween<Offset>(begin: Offset.zero, end: Offset(0, -1)).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}
