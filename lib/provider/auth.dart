import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../httpException.dart';

class Auth with ChangeNotifier {
  bool sucess = false;
  dynamic userId;
  dynamic get uSERID {
    return userId;
  }

  Future<dynamic> authenticateSignup(
    dynamic name,
    dynamic mail,
    dynamic password,
    dynamic mobileNo,
  ) async {
    var str = {
      'name': name,
      'mail': mail,
      'password': password,
      'mobile_no': mobileNo,
    };
    try {
      final url = 'http://yudoo.in/musicapp/Api_controller/user_register';

      final response = await http.post(
        Uri.parse(url),
        body: str,
      );
      final responseData = response.body;
      print(responseData);
      if (responseData.contains('E-mail Already Exits.')) {
        throw HttpException('E-mail Already Exits.');
      }
      if (responseData.contains('Mobile Number Already Exits.')) {
        throw HttpException('Mobile Number Already Exits.');
      }

      if (responseData.contains('User Register Successfully.')) {
        sucess = true;
        final jsondata = json.decode(responseData);
        print(jsondata);
        // final prefs = await SharedPreferences.getInstance();
        // final userData = json.encode(
        //   {
        //     'userid': responseData[],
        //   },
        // );
        // prefs.setString('userData', userData);
        notifyListeners();
      }

      print(responseData);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> authenticateLogin(dynamic mobile, dynamic password) async {
    var str = {'mob_no': mobile, 'password': password};
    try {
      sucess = false;
      final url = 'http://yudoo.in/musicapp/Api_controller/user_login';

      final response = await http.post(
        Uri.parse(url),
        body: str,
      );
      final responseData = response.body;
      if (responseData.contains('Invaild Username Or Password.')) {
        throw HttpException('Invaild Username Or Password.');
      }
      if (responseData.contains('Login Successfully.')) {
        sucess = true;
        final jsondata = json.decode(responseData);
        print(jsondata);
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'userid': jsondata['login_deatils']['user_id'],
          },
        );
        prefs.setString('userData', userData);
        notifyListeners();
      }

      print(responseData);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  bool isauth;
  bool get isAuth {
    return isauth;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return isauth = false;
    }
    if (prefs.containsKey('userData')) {
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, dynamic>;
      // final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
      userId = extractedUserData['userid'];

      notifyListeners();
      return isauth = true;
      // notifyListeners();
    }
  }

  Future<void> logout() async {
    userId = await null;

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('userData');
    await prefs.clear();
  }
}
