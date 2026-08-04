import 'package:dio/dio.dart';

import '../libs/utils.dart';

final request = Dio(
  BaseOptions(
    baseUrl: 'https://api.resend.com',
    headers: {
      'Content-Type': 'application/json',
    },
  ),
);

Future<void> sendEmail({
  required String to,
  required String templateId,
  String? from,
  Map<String, dynamic>? context,
}) async {
  try {
    final resendKey = getEnv('RESEND_KEY', required: true);
    final fromEmail = from ?? getEnv('FROM_EMAIL');

    await request.post(
      '/emails',
      data: {
        'to': to,
        'from': fromEmail,
        'template': {
          'id': templateId,
          'variables': context,
        },
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $resendKey',
        },
      ),
    );
  } on DioException catch (e) {
    print(e.response?.data);
    print('');
    print('**********');
    rethrow;
  }
}
