import 'package:flutter/material.dart';

class ForgotScreen extends StatelessWidget {
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
              'assets/forgot.png',
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: deviceSize.width / 4,
          ),
          Container(
            margin: EdgeInsets.only(
                left: deviceSize.width / 4 * .6,
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
            height: deviceSize.height / 4 / 3,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20)),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: 'Enter Register Email ID',
                  border: InputBorder.none),
            ),
          ),
          SizedBox(
            height: deviceSize.width / 4 / 2,
          ),
          Container(
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
                'Send',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ],
      )),
    );
  }
}
