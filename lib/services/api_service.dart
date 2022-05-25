
import '../constants.dart';
class ApiService {


  static Uri getUri(String path) {
    return Uri.parse(API_URL+path+'?key='+API_KEY);
  }

}