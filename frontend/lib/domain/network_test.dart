import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  final String url;
  Network(this.url);

  Future<dynamic> getJsonData() async {
    // var url = Uri.parse('http://localhost:3000/get');
    http.Response response = await http.get(Uri.parse(url));
    var userJson = response.body;
    print(userJson);
    var parsingData = jsonDecode(userJson);
    return parsingData;
  }
}
