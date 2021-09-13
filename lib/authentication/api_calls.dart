import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

postDataRequest({ address, myBody}) async {
  print('=======$address====================');

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('token');
  Map<String, String> headers = {};
  headers['x-access-token'] = token;

  if (await checkInternetIsConnected()) {
    String url = "https://api.queschat.com/api/$address";
    dynamic response = await http.Client().post(
      Uri.parse(url),
      headers: headers,
      body: myBody,
    );
    print(response.body);
    var body = json.decode(response.body);

    return body;
  } else {
    var data = {'message': 'noInternet'};
    return data;
  }
}

getDataRequest({ address}) async {
  print('=======$address====================');

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('token');
  Map<String, String> headers = {};
  headers['x-access-token'] = token;

  if (await checkInternetIsConnected()) {

    String url = "https://api.queschat.com/api/$address";
    dynamic response = await http.Client().get(
      Uri.parse(url),
      headers: headers,
    );
    print(response.body);
    var body = json.decode(response.body);

    return body;
  } else {
    var data = {'message': 'noInternet'};
    return data;
  }
}



patchDataRequest({ address, myBody}) async {
  print('=======$address====================');

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('token');
  Map<String, String> headers = {};
  headers['x-access-token'] = token;

  if (await checkInternetIsConnected()) {

    String url = "https://api.queschat.com/api/$address";
    dynamic response = await http.Client().patch(
      Uri.parse(url),
      headers: headers,
      body: myBody,
    );
    print(response.body);
    var body = json.decode(response.body);

    return body;
  } else {
    var data = {'message': 'noInternet'};
    return data;
  }
}

deleteDataRequest({ address}) async {
  print('=======$address====================');

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString('token');
  Map<String, String> headers = {};
  headers['x-access-token'] = token;

  if (await checkInternetIsConnected()) {
    String url = "https://api.queschat.com/api/$address";
    dynamic response = await http.Client().delete(
      Uri.parse(url),
      headers: headers,
    );
    print(response.body);
    var body = json.decode(response.body);

    return body;
  } else {
    var data = {'message': 'noInternet'};
    return data;
  }
}

checkInternetIsConnected() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}

