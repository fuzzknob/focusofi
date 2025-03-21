import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomo_mobile/libs/ui_utils.dart';
import 'package:pomo_mobile/providers/auth.dart';
import 'package:pomo_mobile/providers/settings.dart';
import 'package:pomo_mobile/providers/timer.dart';

class InitializationLayer extends ConsumerStatefulWidget {
  const InitializationLayer({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<InitializationLayer> createState() =>
      _InitializationLayerState();
}

class _InitializationLayerState extends ConsumerState<InitializationLayer> {
  late final List<Future> _futures;

  @override
  void initState() {
    super.initState();
    // INFO: add futures here
    _futures = [
      Future.forEach([
        ref.read(initializeAuthProvider),
        ref.read(getSettingsProvider),
        ref.read(getTimerProvider),
      ], (cb) => cb()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);

    return FutureBuilder(
      future: Future.wait(_futures),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.child;
        }
        return Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.deepPurpleAccent,
        );
      },
    );
  }
}
