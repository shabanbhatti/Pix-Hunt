import 'package:shared_preferences/shared_preferences.dart';

class SpService {
  
static const String loggedKEY= 'logged';
static const String userImgKEY= 'user_img';

static Future<void> setBool(String key, bool value)async{
var sp= await SharedPreferences.getInstance();
await sp.setBool(key, value);
}

static Future<bool> getBool(String key)async{
  var sp= await SharedPreferences.getInstance();
  return sp.getBool(key)??false;
}


static Future<void> setString(String key, String value)async{
var sp= await SharedPreferences.getInstance();
await sp.setString(key, value);
}

static Future<String?> getString(String key)async{
  var sp= await SharedPreferences.getInstance();
  return sp.getString(key);
}

static Future<void> remove(String key)async{
  var sp= await SharedPreferences.getInstance();
 await sp.remove(key);
}


}