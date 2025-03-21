import 'package:dio/dio.dart';

import 'utils.dart';

Dio requestFactory() {
  return Dio(BaseOptions(baseUrl: getEnvVariable('BASE_URL') ?? ''));
}
