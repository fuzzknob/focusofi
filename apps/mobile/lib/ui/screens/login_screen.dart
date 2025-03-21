import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomo_mobile/libs/ui_utils.dart';
import 'package:pomo_mobile/providers/settings.dart';
import 'package:pomo_mobile/providers/timer.dart';
import 'package:pomo_mobile/services/auth_service.dart';
import 'package:pomo_mobile/providers/auth.dart';
import 'package:pomo_mobile/ui/widgets/button.dart';
import 'package:pomo_mobile/ui/widgets/text_input.dart';

import '../layouts/main_layout.dart';

enum _Forms { login, code }

final _currentFormProvider = StateProvider<_Forms>((ref) => _Forms.login);

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final currentForm = ref.watch(_currentFormProvider);

    return MainLayout(
      children: [
        IntrinsicHeight(
          child: Container(
            color: Colors.purple.shade100,
            width: size.width - 40,
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: currentForm == _Forms.login ? _LoginForm() : _AuthCode(),
          ),
        ),
      ],
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final TextEditingController _controller = TextEditingController();
  bool _canSubmit = false;
  bool _isSubmitting = false;

  @override
  initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _canSubmit = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login',
          style: textTheme.displaySmall?.copyWith(color: Colors.black),
        ),
        const Gap(15.0),
        TextInput(
          controller: _controller,
          type: TextInputType.emailAddress,
          label: 'Email',
          placeholder: 'you@example.com',
        ),
        const Gap(15.0),
        SizedBox(
          width: double.maxFinite,
          child: Button(
            disabled: !_canSubmit,
            onPressed: () async {
              if (!_controller.text.isNotEmpty) {
                return;
              }
              setState(() {
                _isSubmitting = true;
              });
              try {
                await requestLogin(_controller.text);
                ref.read(_currentFormProvider.notifier).state = _Forms.code;
              } catch (e) {
                print('There is an error');
              } finally {
                setState(() {
                  _isSubmitting = false;
                });
              }
            },
            child: Text(
              _isSubmitting ? 'REQUESTING...' : 'REQUEST LOGIN',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthCode extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AuthCode> createState() => _AuthCodeState();
}

class _AuthCodeState extends ConsumerState<_AuthCode> {
  final TextEditingController _controller = TextEditingController();
  bool _canSubmit = false;
  bool _isSubmitting = false;

  @override
  initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _canSubmit = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'We\'ve sent you a code on your email. Please check your inbox and enter the code below',
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        const Gap(10.0),
        TextInput(controller: _controller, placeholder: 'AUTH CODE'),
        const Gap(10.0),
        SizedBox(
          width: double.maxFinite,
          child: Button(
            disabled: !_canSubmit,
            onPressed: () async {
              setState(() {
                _isSubmitting = true;
              });
              try {
                await ref.read(loginWithOtpProvider)(_controller.text);
                await ref.read(getSettingsProvider)();
                await ref.read(getTimerProvider)();
                if (context.mounted) Navigator.pop(context);
                ref.read(_currentFormProvider.notifier).state = _Forms.login;
              } catch (e) {
                print(e);
              } finally {
                setState(() {
                  _isSubmitting = false;
                });
              }
            },
            child: Text(
              _isSubmitting ? 'SUBMITTING...' : 'SUBMIT',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ),
      ],
    );
  }
}
