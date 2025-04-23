import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomo_mobile/providers/background.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key, this.children});

  final List<Widget>? children;

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  @override
  initState() {
    super.initState();
    _getBackground();
  }

  Future<void> _getBackground() async {
    await ref.read(getBackgroundServiceProvider)();
  }

  @override
  Widget build(BuildContext context) {
    final background = ref.watch(backgroundProvider);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.purple.shade500,
              image:
                  background.isNotEmpty
                      ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(background),
                      )
                      : null,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
          ...?widget.children,
        ],
      ),
    );
  }
}
