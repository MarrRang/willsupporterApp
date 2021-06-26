import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:will_support/common/constant/common_style.dart';
import 'package:will_support/common/constant/ws_constant.dart';
import 'package:will_support/common/util/validation_util.dart';
import 'package:will_support/common/widget/common_widget.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _idTextController = new TextEditingController();
  final TextEditingController _passwordTextController = new TextEditingController();
  final TextEditingController _passwordConfirmTextController = new TextEditingController();
  final TextEditingController _emailTextController = new TextEditingController();

  bool _isNotValidId = false;
  bool _isNotValidPassword = false;
  bool _isNotValidEmail = false;

  String _idErrorMessage = "";
  String _passwordErrorMessage = "";

  String _existIdErrorMessage = "이미 존재하는 아이디입니다";
  String _existEmailErrorMessage = "이미 존재하는 이메일입니다";
  String _notValidIdErrorMessage = "아이디는 4글자 이상으로 만들어주세요";
  String _notValidPasswordErrorMessage = "비밀번호는 8자이상으로 만들어주세요";
  String _notMatchingPasswordErrorMessage = "비밀번호가 일치하지 않습니다";
  String _notValidEmailErrorMessage = "올바르지 않은 이메일입니다";
  String _serverErrorMessage = "서버에 문제가 있습니다.\n죄송해요 ㅠㅠ 문의해주세요";
  String _notValidResponse = "이름, 비밀번호, 이메일을 모두 입력해주세요\n 혹은 이메일을 확인해주세요";

  final Uri signUpApiUrl = Uri.parse("http://aomr.hopto.org:20001/auth/sign-up");
  bool _isLoading = false;
  bool _isSignUpSuccess = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoBackButton(context),
        middle: Image.asset('images/title.png'),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(25.0, 10.0, 25.0 , 10.0),
                                child: Row(
                                  textBaseline: TextBaseline.ideographic,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  children: <Widget>[
                                    Text("회원가입", style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold
                                    ))
                                  ],
                                ),
                              ),
                              const Divider(
                                  color: Colors.black12,
                                  height: 4,
                                  thickness: 1,
                                  indent: 30,
                                  endIndent: 30
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(60.0, 4.0, 60.0, 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFieldFrontText("아이디", CommonStyle.normalText16KR),
                                    Container(
                                      child: TextField(
                                        controller: _idTextController,
                                        decoration: InputDecoration(
                                            hintText: "ID",
                                            errorText: _isNotValidId ? _idErrorMessage : null,
                                            border: _isNotValidId ? OutlineInputBorder() : null),
                                        onChanged: (text) {
                                          setState(() {
                                            _isNotValidId = false;
                                          });
                                        },
                                      ),
                                    ),
                                    TextFieldFrontText("비밀번호", CommonStyle.normalText16KR),
                                    Container(
                                        child: TextField(
                                          controller: _passwordTextController,
                                          decoration: InputDecoration(
                                              hintText: "PASSWORD",
                                              errorText: _isNotValidPassword ? _passwordErrorMessage : null,
                                              border: _isNotValidPassword ? OutlineInputBorder() : null
                                          ),
                                          obscureText: true,
                                          onChanged: (text) {
                                            setState(() {
                                              _isNotValidPassword = false;
                                            });
                                          },
                                        )
                                    ),
                                    TextFieldFrontText("이메일", CommonStyle.normalText16KR),
                                    Container(
                                      child: TextField(
                                        controller: _emailTextController,
                                        decoration: InputDecoration(
                                            hintText: "EMAIL",
                                            errorText: _isNotValidEmail ? _notValidEmailErrorMessage : null,
                                            border: _isNotValidEmail ? OutlineInputBorder() : null
                                        ),
                                        onChanged: (text) {
                                          setState(() {
                                            _isNotValidEmail = false;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                                      child: SafeArea(
                                        child: Row(
                                          children: <Widget>[
                                            Spacer(),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(24.0),
                                                  color: Colors.grey[200]
                                              ),
                                              child: CupertinoButton(
                                                child: Text('Sign Up', style: TextStyle(
                                                    fontSize: 14
                                                )),
                                                onPressed: () {
                                                  _submit();
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                      )
                    ],
                  )
              ),
            ),
            Center(
              child: _isLoading ? _loadingPopUp() : EmptyWidget()
            )
          ],
        )
      ),
    );
  }

  Widget _loadingPopUp() {
    return Container(
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
          color: Colors.white70
      ),
      width: 300.0,
      height: 200.0,
      child: Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: _isSignUpSuccess ? Icon(Icons.check, size: 50.0, color: Colors.white) : SpinKitFadingCube(
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: Center(
                child: Text(
                  _isSignUpSuccess ? "회원가입 성공\n로그인 진행해주세요": "loading.. wait..",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Future showAlertDialog(String errorMessage) {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: new Text("안됐어요 ㅠㅠ"),
          content: new Text(errorMessage),
          actions: [CupertinoDialogAction(isDefaultAction: true, child: Text("Close"), onPressed: () {
            Navigator.pop(context);
          },)],
        )
    );
  }

  void _submit() async {
    if (isNotValidId(_idTextController.value.text.trim())) {
      showAlertDialog("아이디가 유효하지 않습니다. \n아이디를 확인해주세요");

      setState(() {
        _isNotValidId = true;
      });

      return;
    }

    if (isNotValidEmail(_emailTextController.value.text.trim())) {
      showAlertDialog("이메일이 유효하지 않습니다. \n이메일을 확인해주세요");

      setState(() {
        _isNotValidEmail = true;
      });

      return;
    }

    if (isNotValidPassword(_passwordTextController.value.text.trim())) {
      showAlertDialog("비밀번호가 유효하지 않습니다. \n비밀번호를 확인해주세요");

      setState(() {
        _isNotValidPassword = true;
      });

      return;
    }

    setState(() {
      _isLoading = true;
    });

    Map data = {
      "id": _idTextController.value.text.trim(),
      "password": _passwordTextController.value.text.trim(),
      "email": _emailTextController.value.text.trim(),
      "role": USER_ROLE_NORMAL
    };

    var parameters = json.encode(data);
    try {
      final response = await http.post(
        signUpApiUrl,
        headers: {'Content-Type': 'application/json'},
        body: parameters
      );

      if (response.statusCode == HttpStatus.internalServerError) {
        showAlertDialog(_serverErrorMessage);
      }

      if (response.statusCode == HttpStatus.badRequest) {
        switch (response.body) {
          case SIGN_UP_RESULT_INVALID:
            showAlertDialog(_notValidResponse);
            break;
          case SIGN_UP_RESULT_EXIST_EMAIL:
            showAlertDialog(_existEmailErrorMessage);
            break;
          case SIGN_UP_RESULT_EXIST_NAME:
            showAlertDialog(_existIdErrorMessage);
            break;
        }
      }

      if (response.statusCode == HttpStatus.ok) {
        setState(() {
          _isSignUpSuccess = true;
        });

        Future.delayed(Duration(seconds: 3), () {
          _isLoading = false;
          Navigator.pop(context);
        });

        return;
      }
    } on TimeoutException catch (e) {
      showAlertDialog(_serverErrorMessage);
    } on Error catch (e) {
      showAlertDialog(_serverErrorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
