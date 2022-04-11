
import 'package:flutter/material.dart';
import 'package:flutter_erp/pages/user_detail/widget/panel.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_star/star.dart';
import 'package:flutter_star/star_score.dart';

import '../../../common/values/cons.dart';
const List<int> colors = Cons.tabColors;
class WidgetDetailTitle extends StatelessWidget {
  final Map<String, dynamic>? usertail;

  WidgetDetailTitle({this.usertail});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                _buildLeft(usertail!),
                _buildRight(usertail!),
              ],
            ),
            Divider(),
          ],
        ));
  }
Widget _buildLeft(Map<String, dynamic> usertail) => Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20),
        child: Text(
          "用户名：" + usertail['user']['userName'],
          style: TextStyle(
              fontSize: 20.sp,
              color: Color(0xff1EBBFD),
              fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Panel(
            child: Text("性别：" +
                (usertail['user']['sex'].toString() == "1" ? "男" : "女") +
                " 年龄：" +
                usertail['user']['age'].toString() +
                " 手机号：" +
                usertail['user']['tel'].toString() +
                " 颜值：" +
                usertail['user']['facescore'].toString())),
      )
    ],
  ),
);

Widget _buildRight(Map<String, dynamic> usertail) => Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    Container(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          //tag: "hero_widget_image_${usertail['user']['memberId'].toString()}",
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.w)),
                child: Image(
                    image: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/ic_launcher.png',
                      image: usertail['user']['img'],
                    ).image))),
      ),
    ),
    StarScore(
      score: 0,
      star: Star(size: 30.sp, fillColor: Colors.blue),
    )
  ],
);
}