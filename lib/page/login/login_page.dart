import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:will_support/common/auth/global_secure_storage.dart';
import 'package:will_support/common/constant/common_style.dart';
import 'package:will_support/common/constant/ws_constant.dart';
import 'package:will_support/common/widget/common_widget.dart';
import 'package:will_support/page/home/home_page.dart';
import 'package:will_support/page/login/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idTextController = new TextEditingController();
  final TextEditingController _passwordTextController =
      new TextEditingController();

  String _idErrorMassage = "아이디를 입력해주세요";
  String _passwordErrorMassage = "패스워드를 확인해주세요";
  bool isNotValidId = false;
  bool isNotValidPassword = false;
  bool _rememberIdYn = false;

  ButtonState stateTextWithIcon = ButtonState.idle;

  final globalStorage = GlobalSecureStorage().getStorage();
  final String authApiUrl = "http://aomr.hopto.org:20001/auth/login";
  late String authToken;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(0.0, 48.0, 0.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(36.0, 36.0, 36.0, 36.0),
                  child: Image.asset('images/title_icon_v2.png',
                      width: 150, height: 150),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[500]!,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0),
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0)
                      ]),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(60.0, 4.0, 60.0, 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFieldFrontText("아이디", CommonStyle.normalText16KR),
                      Container(
                          child: Stack(
                        children: <Widget>[
                          TextField(
                            controller: _idTextController,
                            decoration: InputDecoration(
                                hintText: "ID",
                                errorText:
                                    isNotValidId ? _idErrorMassage : null,
                                border:
                                    isNotValidId ? OutlineInputBorder() : null),
                            onChanged: (text) {},
                          ),
                          Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                child: TextFieldFrontText(
                                    "저장", CommonStyle.normalText12KR),
                                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                              ),
                              Checkbox(
                                value: _rememberIdYn,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _rememberIdYn = value ??= false;
                                  });
                                },
                              )
                            ],
                          ))
                        ],
                      )),
                      TextFieldFrontText("비밀번호", CommonStyle.normalText16KR),
                      Container(
                        child: TextField(
                          controller: _passwordTextController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "PW",
                              errorText: isNotValidPassword
                                  ? _passwordErrorMassage
                                  : null,
                              border: isNotValidPassword
                                  ? OutlineInputBorder()
                                  : null),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                          child: SafeArea(
                            child: Row(
                              children: <Widget>[
                                Container(
                                    child: ProgressButton.icon(
                                  iconedButtons: {
                                    ButtonState.idle: IconedButton(
                                        text: "로그인",
                                        icon: Icon(Icons.call_made,
                                            color: Colors.white),
                                        color: Colors.orange.shade400),
                                    ButtonState.loading: IconedButton(
                                        text: "로딩중",
                                        color: Colors.yellow.shade600),
                                    ButtonState.fail: IconedButton(
                                        text: "로그인 실패",
                                        icon: Icon(Icons.cancel,
                                            color: Colors.white),
                                        color: Colors.red.shade400),
                                    ButtonState.success: IconedButton(
                                        text: "성공",
                                        icon: Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        color: Colors.green.shade400),
                                  },
                                  onPressed: () {
                                    if (stateTextWithIcon == ButtonState.idle) {
                                      _submit();
                                    }
                                  },
                                  state: stateTextWithIcon,
                                )),
                                Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(96, 54),
                                      alignment: Alignment.center,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0))),
                                  child: const Text('회원가입'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpPage()));
                                  },
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[300],
    );
  }

  bool _validationCheckId() {
    if (StringUtils.isNullOrEmpty(_idTextController.text)) return false;

    return true;
  }

  bool _validationCheckPassword() {
    if (StringUtils.isNullOrEmpty(_passwordTextController.text)) return false;

    return true;
  }

  void _submit() async {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        if (_validationCheckId() == false) {
          setState(() {
            isNotValidId = true;
            _idTextController.text = "";

            Future.delayed(Duration(milliseconds: 1000), () {
              setState(() {
                isNotValidId = false;
              });
            });
          });

          break;
        }
        if (_validationCheckPassword() == false) {
          setState(() {
            isNotValidPassword = true;
            _passwordTextController.text = "";

            Future.delayed(Duration(milliseconds: 1000), () {
              setState(() {
                isNotValidPassword = false;
              });
            });
          });

          break;
        }

        setState(() {
          stateTextWithIcon = ButtonState.loading;
        });

        String userId = _idTextController.text;
        String password = _passwordTextController.text;

        Map data = {'name': userId, 'password': password};

        authToken = "toke";
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
                builder: (context) => HomePage(authToken)));

        /*var parameters = json.encode(data);
        try {
          final response = await http.post(Uri.parse(authApiUrl),
              headers: {'Content-Type': 'application/json'}, body: parameters);

          setState(() {
            if (response == null) {
              stateTextWithIcon = ButtonState.fail;
            }

            if (response.statusCode == HttpStatus.accepted) {
              authToken = response.body;
              stateTextWithIcon = ButtonState.success;

              if (_rememberIdYn) {
                globalStorage.write(
                    key: AUTH_REMEMBER_ID_YN_KEY,
                    value: _rememberIdYn.toString());
              } else {
                globalStorage.delete(key: AUTH_REMEMBER_ID_YN_KEY);
              }

              globalStorage.write(key: AUTH_TOKEN_KEY, value: authToken);
              globalStorage.write(key: AUTH_USER_ID, value: userId);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => HomePage(authToken)));
            } else {
              stateTextWithIcon = ButtonState.fail;
            }
          });

          *//*Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              stateTextWithIcon = ButtonState.idle;
            });
          });*//*
        } on TimeoutException catch (e) {
          showAlertDialog(context);
        } on Error catch (e) {
          showAlertDialog(context);
        }*/

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }

    setState(() {
      stateTextWithIcon = stateTextWithIcon;
    });
  }

  Future<void> showAlertDialog(BuildContext context) async {
    String result = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("로그인에 문제가 생겼습니다. 다시 시도해주세요.\n지속적으로 문제가 생길 시 문의해주세요."),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context, "OK");
                },
              )
            ],
          );
        });

    setState(() {
      stateTextWithIcon = ButtonState.idle;
    });
  }
}
