import 'package:flutter/material.dart';
import 'package:music_player/category_choose_screen.dart';
import 'package:music_player/forgot_screen.dart';
import 'package:music_player/music_player.dart';
import 'package:music_player/provider/auth.dart';
import 'package:music_player/signUp_scrern.dart';
import 'package:provider/provider.dart';

import 'httpException.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    // _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).authenticateLogin(
          phoneController.text.trim(), passwordController.text.trim());
    } on HttpException catch (error) {
      var errorMessage = 'Login Failed';
      if (error.toString().contains('Invaild Username Or Password.')) {
        errorMessage = 'Please Check Login Credentials';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Please Check Internet Connection';
      _showErrorDialog(errorMessage);
    }
    // Provider.of<Auth>(context, listen: false).userName =
    //     '${firstnamecontroller.text.trim()} ${lastnamecontroller.text.trim()}';
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Container(
            height: deviceSize.height / 2 * .7,
            width: double.infinity,
            child: Image.asset(
              'assets/login.png',
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: deviceSize.width / 4,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 2,
                      bottom: deviceSize.width / 4 / 4 / 2),
                  child: Text('Mobile No.'),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 2,
                      right: deviceSize.width / 4 / 2),
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      left: deviceSize.width / 4 / 4,
                      right: deviceSize.width / 4 / 4,
                      top: 5,
                      bottom: 5),
                  height: deviceSize.height / 4 / 3,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Mobile No.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Mobile No.'),
                  ),
                ),
                SizedBox(
                  height: deviceSize.width / 4 / 4,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 2,
                      bottom: deviceSize.width / 4 / 4 / 2),
                  child: Text('Password'),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 2,
                      right: deviceSize.width / 4 / 2),
                  padding: EdgeInsets.only(
                      left: deviceSize.width / 4 / 4,
                      right: deviceSize.width / 4 / 4,
                      top: 5,
                      bottom: 5),
                  width: double.infinity,
                  height: deviceSize.height / 4 / 3,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Password.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Password'),
                  ),
                ),
                SizedBox(
                  height: deviceSize.width / 4 / 2,
                ),
                _isLoading == false
                    ? GestureDetector(
                        child: Container(
                            margin: EdgeInsets.only(
                                left: deviceSize.width / 4 / 2,
                                right: deviceSize.width / 4 / 2),
                            width: double.infinity,
                            height: deviceSize.height / 4 / 3,
                            decoration: BoxDecoration(
                                color: Color(0xFF2C98F0),
                                borderRadius: BorderRadius.circular(20)),
                            alignment: Alignment.center,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        onTap: () async {
                          await _submit();
                          Provider.of<Auth>(context, listen: false).sucess ==
                                  true
                              ? Navigator.push(context,
                                  MaterialPageRoute(builder: (ctx) {
                                  return CategoryChooseScreen();
                                }))
                              : null;
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: deviceSize.width / 4, right: deviceSize.width / 4),
              width: double.infinity,
              height: deviceSize.height / 4 / 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: Color(0xFF2C98F0),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return SignUpScreen();
                      }));
                    },
                  ),
                  InkWell(
                    child: Text(
                      'Forgot assword',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return ForgotScreen();
                      }));
                    },
                  )
                ],
              )),
        ],
      )),
    );
  }
}
