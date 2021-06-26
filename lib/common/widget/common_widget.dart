library common_widget;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:will_support/common/constant/common_style.dart';
import 'package:will_support/common/model/todo.dart';
import 'package:will_support/common/model/userTodo.dart';

Widget TextFieldFrontText(String text, [TextStyle? textStyle]) {
  return Container(
    margin: new EdgeInsets.fromLTRB(0, 25, 0, 10),
    child: Text(text,
        style: (textStyle != null) ? textStyle : CommonStyle.normalTextKR,
        textAlign: TextAlign.start),
  );
}

Widget MaterialBackButton(BuildContext context, [String? text]) {
  return IconButton(
    icon: Icon(Icons.arrow_back_ios),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}

Widget CupertinoBackButton(BuildContext context, [String? text]) {
  return CupertinoNavigationBarBackButton(
      previousPageTitle: "Back",
      onPressed: () {
        Navigator.pop(context);
      });
}

Widget EmptyWidget() {
  return SizedBox.shrink();
}

Widget FriendTodo(BuildContext context, UserTodo userTodo) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      //Profile Image
      Container(
          margin: const EdgeInsets.only(
              left: 12.0, top: 8.0, bottom: 8.0, right: 12.0),
          decoration: BoxDecoration(
              color: Color.fromRGBO(210, 210, 210, 0.3),
              shape: BoxShape.circle),
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.width / 4,
          child: userTodo.user.profileImageUrl == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.account_circle_rounded, color: Colors.grey)
                  ],
                )
              : ExtendedImage.network(userTodo.user.profileImageUrl,
                  fit: BoxFit.cover, cache: true, shape: BoxShape.circle)),
      //User TD text
      Expanded(
          child: Container(
        alignment: Alignment.centerLeft,
        child: Text(userTodo.todo.todoText ?? ""),
      )),
      //isComplete Icon
      Container(
        alignment: Alignment.center,
        child: Icon(userTodo.todo.isComplete ? Icons.radio_button_checked : Icons.radio_button_unchecked),
      )
    ],
  );
}
