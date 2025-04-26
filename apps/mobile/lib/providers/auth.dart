import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomo_mobile/libs/utils.dart';
import 'package:pomo_mobile/providers/storage.dart';
import 'package:pomo_mobile/services/auth_service.dart';

const authTokenKey = 'FOCUSOFI_AUTH_TOKEN';

final authTokenProvider = StateProvider<String?>((ref) => '');

final authRequestProvider = Provider((ref) {
  final token = ref.watch(authTokenProvider);
  if (token == null) return null;
  return Dio(
    BaseOptions(
      baseUrl: getEnvVariable('BASE_URL') ?? '',
      headers: {'Authorization': 'Bearer $token'},
    ),
  );
});

final isLoggedIn = Provider((ref) {
  final token = ref.watch(authTokenProvider);
  return token != null && token.isNotEmpty;
});

final initializeAuthProvider = Provider((ref) {
  return () async {
    final localStorage = await ref.read(localStorageProvider.future);
    final token = await localStorage.get<String>(authTokenKey);
    ref.read(authTokenProvider.notifier).state = token;
  };
});

final loginWithOtpProvider = Provider((ref) {
  return (String otpCode) async {
    final token = await loginWithOtp(otpCode);
    if (token == null || token.isEmpty) {
      // todo throw an error
      return;
    }
    final localStorage = await ref.read(localStorageProvider.future);
    await localStorage.set(authTokenKey, token);
    ref.read(authTokenProvider.notifier).state = token;
  };
});

final logoutProvider = Provider((ref) {
  return () async {
    final authRequest = ref.read(authRequestProvider);
    if (authRequest == null) return;
    await authRequest.get('/auth/logout');
    final localStorage = await ref.read(localStorageProvider.future);
    localStorage.clear();
    ref.read(authTokenProvider.notifier).state = null;
  };
});
