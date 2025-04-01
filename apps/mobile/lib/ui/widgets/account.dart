import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomo_mobile/providers/auth.dart';
import 'package:pomo_mobile/providers/settings.dart';
import 'package:pomo_mobile/providers/timer.dart';
import 'package:pomo_mobile/ui/screens/login_screen.dart';

class Account extends ConsumerWidget {
  const Account({super.key, this.beforeLogout});

  final Future<void> Function()? beforeLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authTokenProvider);
    if (auth == null) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: Text('SIGN IN', style: TextStyle(fontSize: 20.0)),
      );
    }
    return GestureDetector(
      onTap: () async {
        if (beforeLogout != null) {
          await beforeLogout!.call();
        }
        await ref.read(logoutProvider)();
        ref.read(timerProvider.notifier).state = null;
        ref.read(settingsProvider.notifier).state = null;
      },
      child: Text('SIGN OUT', style: TextStyle(fontSize: 20.0)),
    );
  }
}
