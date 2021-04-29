// Created by Eng Amr Haitham
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:text_me/widgets/custom_btn.dart';
import 'package:text_me/widgets/custom_input.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SnackBar _snackBarError =
      SnackBar(content: Text(("Could not text the number")));
  bool _switchValue = false;
  String _number;
  String _text;
  String url;
  bool _isItSMS = false;

  launchChat(bool withText) async {
    if (withText == false) {
      url = 'http://wa.me/${_number}?';
    } else {
      url = 'http://wa.me/${_number}?text=${_text}';
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(_snackBarError);
    }
  }
  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents,)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.5,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.13 ),
                  width: double.infinity,
                  height: _switchValue ? MediaQuery.of(context).size.height * 0.9 :MediaQuery.of(context).size.height * 0.75,
                  child: Container(
                    margin: EdgeInsets.only( left: 25 ,right: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Icon(
                            Icons.message,
                            size: 110,
                            color: Colors.green,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _isItSMS ? Colors.transparent : Colors.green,
                                    border:
                                    Border.all(color: Colors.green, width: 2.0),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text("Whatsapp")),
                              onTap: (){
                                setState(() {
                                  _isItSMS = false;
                                });
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _isItSMS ? Colors.green : Colors.transparent,
                                    border:
                                    Border.all(color: Colors.green, width: 2.0),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text("SMS")),
                              onTap: (){
                                setState(() {
                                  _isItSMS = true;
                                });
                              },
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: (_number==null) ? Colors.red.withOpacity(0.9) :Colors.green.withOpacity(0.9),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(), gapPadding: 5),
                            ),
                            initialCountryCode: 'EG',
                            onChanged: (phone) {
                              _number = phone.completeNumber;
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border:
                                  Border.all(color: _switchValue ? Colors.green :Colors.red, width: 2.0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text("Text with message")),
                            CupertinoSwitch(
                              trackColor: Colors.red,
                              activeColor: Colors.green,
                              value: _switchValue,
                              onChanged: (value) {
                                setState(() {
                                  _switchValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                        if(_switchValue == true)
                        Custom_input(hint: "write your message",onChanged: (value){
                          _text = value;
                        },),
                        Stack(children: [
                          CustomBtn(
                            text: "Text this number",
                            onPressed: () {
                              if (_number == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(_snackBarError);
                              } else {
                                if(_isItSMS == false){
                                  if(_switchValue == false){
                                    launchChat(false);
                                  }
                                  else{
                                    launchChat(true);
                                  }
                                }
                                else if(_isItSMS == true){
                                  List<String> _numbers=[];
                                  _numbers.add(_number);
                                  if(_text==null){
                                    _text = " ";
                                  }
                                  _sendSMS(_text, _numbers);
                                }
                              }
                            },
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 35, left: 50),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ]),
                      ],
                    ),
                  )),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.redAccent,
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Column(
                          children: [
                            Text("Developed by ENG Amr Haitham"),
                            SelectableText("amro88981@gmail.com"),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Exit"))
                      ],
                    );
                  });
            },
            child: Icon(
              Icons.account_box_outlined,
            )));
  }
}
