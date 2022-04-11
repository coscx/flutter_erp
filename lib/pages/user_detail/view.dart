import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_erp/common/entities/detail/action.dart';
import 'package:flutter_erp/common/entities/detail/appoint.dart';
import 'package:flutter_erp/common/entities/detail/calllog.dart';
import 'package:flutter_erp/common/entities/detail/connect.dart';
import 'package:flutter_erp/common/entities/detail/user_detail.dart';
import 'package:flutter_erp/pages/user_detail/widget/bottom_sheet.dart';
import 'package:flutter_erp/pages/user_detail/widget/common_dialog.dart';
import 'package:flutter_erp/pages/user_detail/widget/detail_dialog.dart';
import 'package:flutter_erp/pages/user_detail/widget/goods_add_menu.dart';
import 'package:flutter_erp/pages/user_detail/widget/popup_window.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import './widget/detail_common.dart';
import './widget/detail_item.dart';
import '../../common/values/cons.dart';
import '../../common/widgets/DyBehaviorNull.dart';
import '../../common/widgets/refresh.dart';
import 'logic.dart';

class UserDetailPage extends StatelessWidget {
  final logic = Get.find<UserDetailLogic>();
  final state = Get.find<UserDetailLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme.of(context).copyWith(
            brightness: Brightness.light,
          ),
        ),
        child: Obx(() => Scaffold(
            //endDrawer: CategoryEndDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              //去掉Appbar底部阴影
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("用户详情",
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontSize: 38.sp,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  )),
              actions: <Widget>[
                _buildCallButton(),
                _buildAppointButton(),
                _buildConnectButton(),
                _buildRightMenu()
              ],
            ),
            body: logic.load.value == 0
                ? Container()
                : _buildContent(context))));
  }

  Widget _buildRightMenu() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.w, 15.h, 20.w, 0.h),
      child: IconButton(
        tooltip: '用户操作',
        key: logic.addKey,
        onPressed: () {
          showAddMenu(logic.userDetail!.info);
        },
        icon: const Icon(
          Icons.wifi_tethering,
          color: Colors.black,
          key: Key('add'),
        ),
      ),
    );
  }

  void showAddMenu(Info args) {
    final RenderBox button =
        logic.addKey.currentContext?.findRenderObject() as RenderBox;

    showPopupWindow<void>(
      context: Get.context!,
      isShowBg: true,
      offset: Offset(button.size.width - 7.w, -15.h),
      anchor: button,
      child: GoodsAddMenu(
        args: args,
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  List<PopupMenuItem<String>> buildItems() {
    final map = {
      "移入良缘库": Icons.archive_outlined,
      "移入公海": Icons.copyright_rounded,
      "划分客户": Icons.pivot_table_chart,
    };
    return map.keys
        .toList()
        .map((e) => PopupMenuItem<String>(
            value: e,
            child: Wrap(
              spacing: 5.h,
              children: <Widget>[
                Icon(
                  map[e],
                  color: Colors.black,
                ),
                Text(e),
              ],
            )))
        .toList();
  }

  Widget _buildContent(BuildContext context) => WillPopScope(
      onWillPop: () => _whenPop(context),
      child: ScrollConfiguration(
          behavior: DyBehaviorNull(),
          child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              header: DYrefreshHeader(),
              footer: DYrefreshFooter(),
              controller: logic.refreshController,
              onRefresh: logic.onRefresh,
              onLoading: logic.onLoading,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTitle(context),
                    _buildDetail(context)
                  ],
                ),
              ))));

  Widget _buildAppointButton() => Builder(
      builder: (ctx) => GestureDetector(
          onLongPress: () => Scaffold.of(ctx).openEndDrawer(),
          child: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Container(
              width: 60.h,
              height: 60.h,
              margin: EdgeInsets.fromLTRB(10.w, 0.h, 5.w, 0.h),
              child: Lottie.asset(
                  'assets/packages/lottie_flutter/appointment.json'),
            ),
          ),
          onTap: () async {
            if (logic.canEdit == 1) {
              var d = await appointDialog(Get.context!, logic.uuid);
              if (d == true) {
                logic.buildAppointButton();
              }
            } else {
              showToastRed(ctx, "权限不足", true);
            }
          }));

  Widget _buildCallButton() => Builder(
      builder: (ctx) => GestureDetector(
          onLongPress: () => Scaffold.of(ctx).openEndDrawer(),
          child: Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Container(
              width: 60.h,
              height: 60.h,
              margin: EdgeInsets.fromLTRB(10.w, 0.h, 0.w, 0.h),
              child: Lottie.asset(
                  'assets/packages/lottie_flutter/phone-call.json'),
            ),
          ),
          onTap: () async {
            if (logic.canEdit == 0) {
              showToastRed(ctx, "暂无权限", true);
              return;
            }
            // WWDialog.showBottomDialog(Get.context,
            //     content: '请选择',
            //     contentColor: colorWithHex9,
            //     contentFontSize: 30.sp,
            //     location: DiaLogLocation.bottom,
            //     arrangeType: buttonArrangeType.column,
            //     buttons: ['查看号码', '拨打电话'],
            //     otherButtonFontSize: 30.sp,
            //     otherButtonFontWeight: FontWeight.w400,
            //     onTap: (int index, BuildContext context) async {
            //   if (index == 0) {
            //     var actionList = await IssuesApi.viewCall(uuid);
            //     if (actionList['code'] == 200) {
            //       showCupertinoAlertDialog(actionList['data']);
            //     } else {
            //       showToast(ctx, "暂无权限", true);
            //     }
            //   }
            //   if (index == 1) {
            //     var actionList = await IssuesApi.viewCall(uuid);
            //     if (actionList['code'] == 200) {
            //       _makePhoneCall(actionList['data']);
            //     } else {
            //       showToast(ctx, "暂无权限", true);
            //     }
            //   }
            // });
          }));

  Widget _buildConnectButton() {
    return GestureDetector(
      onTap: () async {
        if (logic.canEdit == 1) {
          var d = await commentDialog(
              Get.context!, logic.connectStatus, logic.userDetail!.info);
          if (d == true) {
            logic.buildConnectButton();
          }
        } else {
          showToastRed(Get.context!, "暂无权限", true);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: 20.0, top: 10.h),
        child: Container(
          width: 60.h,
          height: 60.h,
          margin: EdgeInsets.fromLTRB(10.w, 5.h, 5.w, 0.h),
          child: Lottie.asset('assets/packages/lottie_flutter/chat.json'),
        ),
      ),
    );
  }

  showBottomAlert(BuildContext context, confirmCallback, String title,
      String option1, String option2) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return BottomCustomAlterWidget(
              confirmCallback, title, option1, option2);
        });
  }

  void showCupertinoAlertDialog(String mobile) {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("手机号码"),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Align(
                  child: Text(mobile),
                  alignment: Alignment(0, 0),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);
                  print("取消");
                },
              ),
              CupertinoDialogAction(
                child: Text("复制"),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: mobile));
                  showToast(context, "复制成功", true);
                  Navigator.pop(context);
                  print("确定");
                },
              ),
            ],
          );
        });
  }

  final List<int> colors = Cons.tabColors;

  Future<bool> _whenPop(BuildContext context) async {
    if (Scaffold.of(context).isEndDrawerOpen) return true;
    return true;
  }

  List<Widget> _listViewConnectList(List<Connect> connectList) {
    return connectList
        .map((e) => item_connect(
            Get.context!,
            e.username,
            e.connectTime,
            e.connectMessage,
            e.subscribeTime.toString(),
            e.connectStatus.toString(),
            e.connectType.toString(),
            logic.userDetail!.info.roleId))
        .toList();
  }

  List<Widget> _listViewAppointList(List<Appoint> connectList) {
    return connectList
        .map((e) => item_appoint(
            Get.context!,
            e.username,
            e.otherName,
            e.appointmentAddress,
            e.appointmentTime,
            e.canWrite.toString(),
            e.remark.toString(),
            e.message.toString(),
            e.otherId.toString(),
            e.id,
            logic.uuid,
            logic.canEdit))
        .toList();
  }

  List<Widget> _listViewActionList(List<UserAction> connectList) {
    return connectList
        .map((e) => itemAction(Get.context!, e.username, e.title, e.content,
            e.createdAt.toString()))
        .toList();
  }

  List<Widget> _listViewCallList(List<CallLog> connectList) {
    return connectList
        .map((e) => itemCall(Get.context!, e.username, e.count.toString(),
            e.updatedAt.toString()))
        .toList();
  }

  Widget _buildDetail(BuildContext context) {
    return _buildStateDetail(context, logic.userDetail!, logic.connectList,
        logic.appointList, logic.actionList, logic.callList);

    return Container(
      child: Container(
        margin: EdgeInsets.only(
            top: 300.h,
            left: ScreenUtil().screenWidth / 2 - 50.h,
            right: ScreenUtil().screenWidth / 2 - 50.h),
        height: 100.h,
        width: 100.w,
        alignment: Alignment.center,
        child: Lottie.asset(
            'assets/packages/lottie_flutter/16379-an-ios-like-loading.json'),
      ),
    );
  }

  Widget _buildStateDetail(
      BuildContext context,
      Data userDetails,
      List<Connect> connectList,
      List<Appoint> appointList,
      List<UserAction> actionList,
      List<CallLog> callList) {
    void callSetState(String tag, bool value) {
      logic.callSetState(tag, value);
    }

    var info = userDetails.info;
    var demand = userDetails.demand;
    logic.canEdit = userDetails.canEdit;
    logic.call = info.mobile;
    logic.uuid = info.uuid;
    logic.status = info.status;

    if (connectList.isNotEmpty) {
      Connect e = connectList.first;
      logic.connectStatus = e.connectStatus;
    }
    List<Widget> connectListView = _listViewConnectList(connectList);
    List<Widget> appointListView = _listViewAppointList(appointList);
    List<Widget> actionListView = _listViewActionList(actionList);
    List<Widget> callListView = _listViewCallList(callList);

    //String level = getLevel(info['status']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildBase(context, info, logic.canEdit, logic.showBaseControl,
            callSetState, "base"),
        buildEdu(context, info, logic.canEdit, logic.showEduControl,
            callSetState, "education"),
        buildMarriage(context, info, logic.canEdit, logic.showMarriageControl,
            callSetState, "marriage"),
        buildSimilar(context, info, logic.canEdit, logic.showSimilarControl,
            callSetState, "similar"),
        buildUserSelect(context, demand, logic.canEdit, logic.showSelectControl,
            info.uuid, callSetState, "select"),
        buildPhoto(context, userDetails, logic.canEdit, logic.showPhotoControl,
            callSetState, "photo"),
        buildConnect(
            connectListView, logic.showConnectControl, callSetState, "connect"),
        buildAppoint(
            appointListView, logic.showAppointControl, callSetState, "appoint"),
        buildAction(
            actionListView, logic.showActionControl, callSetState, "action"),
        buildCall(callListView, logic.showCallControl, callSetState, "call"),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return header(context, logic.userDetail!);
  }
}
