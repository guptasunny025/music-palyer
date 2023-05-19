import 'package:flutter/material.dart';
import 'package:music_player/category_choose_screen.dart';
import 'package:music_player/login_screen.dart';
import 'package:music_player/music_player.dart';
import 'package:music_player/provider/auth.dart';
import 'package:provider/provider.dart';

import 'httpException.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
      await Provider.of<Auth>(context, listen: false).authenticateSignup(
          nameController.text.trim(),
          mailController.text.trim(),
          passwordController.text.trim(),
          phoneController.text.trim());
    } on HttpException catch (error) {
      var errorMessage = 'Signup Failed';
      if (error.toString().contains('Mobile Number Already Exits.')) {
        errorMessage = 'This Mobile Number Already Registered With Us';
      }
      if (error.toString().contains('E-mail Already Exits.')) {
        errorMessage = 'This Email Already Registered With Us';
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
            height: deviceSize.height / 2 * .6,
            width: double.infinity,
            child: Image.asset(
              'assets/signUp.png',
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: deviceSize.width / 4 / 4 / 2,
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
                  child: Text('Name'),
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
                  height: deviceSize.height / 4 / 3 * .9,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Name.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Name'),
                  ),
                ),
                SizedBox(
                  height: deviceSize.width / 4 / 4 / 2,
                ),
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
                  height: deviceSize.height / 4 / 3 * .9,
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
                  height: deviceSize.width / 4 / 4 / 2,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 2,
                      bottom: deviceSize.width / 4 / 4 / 2),
                  child: Text('Email'),
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
                  height: deviceSize.height / 4 / 3 * .9,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    controller: mailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Email.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Email'),
                  ),
                ),
                SizedBox(
                  height: deviceSize.width / 4 / 4 / 2,
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
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      left: deviceSize.width / 4 / 4,
                      right: deviceSize.width / 4 / 4,
                      top: 5,
                      bottom: 5),
                  height: deviceSize.height / 4 / 3 * .9,
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
                  height: deviceSize.width / 4 / 4 / 2,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 2,
                      bottom: deviceSize.width / 4 / 4 / 2),
                  child: Text('Confirm Password'),
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
                  height: deviceSize.height / 4 / 3 * .9,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Confirm Password.';
                      } else if (confirmPasswordController.text.trim() !=
                          passwordController.text.trim()) {
                        return 'Passwrod Should Be Match';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Confirm Password'),
                  ),
                ),
                SizedBox(
                  height: deviceSize.width / 4 / 3 * .9,
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
                              'SIGN IN',
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
                                  return LoginScreen();
                                }))
                              : null;
                        },
                      )
                    : Center(child: CircularProgressIndicator())
              ],
            ),
          ),
          Container(
              // margin: EdgeInsets.only(
              //     left: deviceSize.width / 4, right: deviceSize.width / 4),
              width: double.infinity,
              height: deviceSize.height / 4 / 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Note :- All field are mandatory',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ],
      )),
    );
  }
}
