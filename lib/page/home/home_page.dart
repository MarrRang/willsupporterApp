import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:will_support/common/constant/common_style.dart';
import 'package:will_support/common/model/userTodo.dart';
import 'package:will_support/common/widget/common_widget.dart';
import 'package:will_support/page/login/login_page.dart';
import 'package:flutter/foundation.dart' as foundation;

class HomePage extends StatefulWidget {
  final String loginToken;

  const HomePage(this.loginToken) : super();

  @override
  _HomePageState createState() => _HomePageState(loginToken);
}

class _HomePageState extends State<HomePage> {
  final String loginToken;

  _HomePageState(this.loginToken);

  static late DateTime currentBackPressTime;

  double _contextHeight = 400;
  double _appbarHeight = 70;

  List<UserTodo> friendsTodo = [];

  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    _contextHeight =
        MediaQuery.of(context).size.height - _appbarHeight;

    return WillPopScope(
      onWillPop: () async {
        bool result = _isEnd();
        return await Future.value(result);
      },
      child: Scaffold(
          body: SafeArea(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: _contextHeight * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text("오늘의 목표", textAlign: TextAlign.start),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(12),
                          child: Align(
                            alignment: AlignmentDirectional.center,
                            child: Text("나는 앱을 만들거야", style: CommonStyle.semiBoldText20, textAlign: TextAlign.center),
                          ),
                        ),
                        const Divider(
                          color: Colors.black12,
                          height: 4,
                          thickness: 1,
                          indent: 30,
                          endIndent: 30,
                        ),
                        Expanded(
                            child: CustomScrollView(
                              slivers: <Widget>[
                                SliverFillRemaining(
                                  child: SafeArea(
                                    child: ListView.separated(
                                      itemCount: friendsTodo.length,
                                      itemBuilder: (context, index) {
                                        return FriendTodo(context, friendsTodo[index]);
                                      },
                                      separatorBuilder: (context, index) {
                                        if (index == 0) return EmptyWidget();
                                        return const Divider();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }

  _isEnd() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            content: Text('뒤로가기 버튼을 누르면 종료됩니다')));
      return false;
    }
    return true;
  }
}
