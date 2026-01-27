import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class EnvUtils {
  static String? apiey = dotenv.env['API_KEY'];
  static String? serverClientId = dotenv.env['SERVER_CLIENT_ID'];
}
