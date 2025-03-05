import 'package:flutter/material.dart';
import 'package:notes_with_hive/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  double _opacity = 0.0;
  double _scale = 0.8;
  double _textPosition = 50;
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
        _textPosition = 0;
      });
    });

    Future.delayed(
      const Duration(
        seconds: 2,
      ),
      () => Navigator.pushReplacementNamed(
        context,
        RouteManager.main,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: _opacity,
                child: AnimatedScale(
                  duration: const Duration(seconds: 1),
                  scale: _scale,
                  curve: Curves.easeOutBack, // Smooth effect
                  child: const Text(
                    'Notable',
                    style: TextStyle(
                      fontSize: 39,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(0, _textPosition, 0),
                child: const Text(
                  'Offline | Reliable | Secure',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
