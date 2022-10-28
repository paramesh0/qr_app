import 'package:http/http.dart' as http;

class APIRepository {

  static const String publicAPI = 'https://api.ipify.org?format=json';

  Future<dynamic> getPublicIP(arguments) async {
    dynamic returnableValues;
    Uri uri = Uri.parse(publicAPI);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      returnableValues= response.body;

      return  returnableValues;
    } else {
      returnableValues= response.body;
      return  returnableValues;
    }
  }
}
