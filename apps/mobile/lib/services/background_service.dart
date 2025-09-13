import 'package:pomo_mobile/libs/request.dart';

Future<String> fetchBackground() async {
  final request = requestFactory();
  final res = await request.get<Map<String, dynamic>?>('/background');
  final data = res.data;
  if (data == null || data['img'] == null) {
    return 'https://media.giphy.com/media/Basrh159dGwKY/giphy.gif';
  }
  return data['img'] as String;
}
