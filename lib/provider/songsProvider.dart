import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class SongsProvider with ChangeNotifier {
  List getsonglist = [];
  bool isSOng = true;
  Future<dynamic> getsong(dynamic catID) async {
    try {
      isSOng = true;
      final url = 'http://yudoo.in/musicapp/Api_controller/get_alltunedetails';
      var requestbody = {'category_id': catID};
      final response = await http.post(Uri.parse(url), body: requestbody);
      if (response.body.contains('staus_code":1')) {
        final responseData = await json.decode(response.body);
        getsonglist = await responseData['tunedetails'];
        print(responseData['tunedetails']);
        return getsonglist;
      }
      if (response.body.contains('staus_code":0')) {
        isSOng = false;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> getcategory() async {
    try {
      final url = 'http://yudoo.in/musicapp/Api_controller/category_details';

      final response = await http.get(
        Uri.parse(url),
      );
      final responseData = await json.decode(response.body);
      print(responseData);
      return responseData;
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
