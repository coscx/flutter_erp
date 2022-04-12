import 'package:flutter/material.dart';
import 'package:flutter_erp/common/entities/detail/action.dart';
import 'package:flutter_erp/common/entities/detail/appoint.dart';
import 'package:flutter_erp/common/entities/detail/calllog.dart';
import 'package:flutter_erp/common/entities/detail/connect.dart';
import 'package:flutter_erp/common/entities/detail/user_detail.dart';
import 'package:flutter_erp/common/routers/names.dart';
import 'package:flutter_erp/pages/user_detail/widget/common_dialog.dart';
import 'package:flutter_erp/pages/user_detail/widget/share.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/apis/common.dart';
import '../../common/widgets/copy_custom_pop_up_menu.dart';
import 'state.dart';

class UserDetailLogic extends GetxController {
  var popCtrl = CustomPopupMenuController();
  final UserDetailState state = UserDetailState();
  String memberId = "80";
  int connectStatus = 4;
  int canEdit = 0;
  String call = "";
  String uuid = "";
  int status = 10;
  var showBaseControl = false.obs;
  var showEduControl = false.obs;
  var showMarriageControl = false.obs;
  var showSimilarControl = false.obs;
  var showSelectControl = false.obs;
  var showPhotoControl = false.obs;
  var showAppointControl = false.obs;
  var showConnectControl = false.obs;
  var showActionControl = false.obs;
  var showCallControl = false.obs;
  Data? userDetail;

  RxInt load = 0.obs;
  RxList<Connect> connectList = <Connect>[].obs;
  RxList<Appoint> appointList = <Appoint>[].obs;
  RxList<UserAction> actionList = <UserAction>[].obs;
  RxList<CallLog> callList = <CallLog>[].obs;
  final List<ShareOpt> list = [
    ShareOpt(
        title: '微信',
        img: 'assets/packages/images/login_wechat.svg',
        shareType: ShareType.SESSION,
        doAction: (shareType, shareInfo) async {
          if (shareInfo == null) return;

          /// 分享到好友
          var model = fluwx.WeChatShareWebPageModel(
            shareInfo.url,
            title: shareInfo.title,
            thumbnail: fluwx.WeChatImage.network(shareInfo.img),
            scene: fluwx.WeChatScene.SESSION,
          );
          fluwx.shareToWeChat(model);
        }),
  ];
  final GlobalKey addKey = GlobalKey();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() {
    _loadData();
  }

  void _loadData() async {
    uuid = Get.arguments;
    var result = await CommonAPI.getUserDetail(uuid);
    userDetail = result.data;
    load.value = 1;

    Future.delayed(const Duration(seconds: 2), () {
      _loadOtherData();
    });
    //debugPrint(result.toJson().toString());
  }

  void _loadOtherData() async {
    var connect = await CommonAPI.getConnectList(uuid, 1);
    connectList.addAll(connect.data.data);

    var appoint = await CommonAPI.getAppointmentList(uuid, 1);
    appointList.addAll(appoint.data.data);

    var action = await CommonAPI.getActionList(uuid, 1);
    actionList.addAll(action.data.data);

    var call = await CommonAPI.getCallList(uuid, 1);
    callList.addAll(call.data.data);

    //debugPrint(result.toJson().toString());
  }

  // 下拉刷新
  void onRefresh() async {
    //Map<String, dynamic> photo = Map();
    //photo['uuid'] = userDetail.info.uuid;
    //BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetailNoFresh(photo));
    refreshController.refreshCompleted();
  }

  // 上拉加载
  void onLoading() async {
    refreshController.loadComplete();
  }

  void callSetState(String tag, bool value) {
    if (tag == "base") {
      showBaseControl.value = value;
      showEduControl.value = false;
      showMarriageControl.value = false;
      showSimilarControl.value = false;
      showSelectControl.value = false;
      showPhotoControl.value = false;
      showConnectControl.value = false;
      showAppointControl.value = false;
      showActionControl.value = false;
      showCallControl.value = false;
      update(["user_detail"]);
    }
    if (tag == "education") {
      showBaseControl.value = false;
      showEduControl.value = value;
      showMarriageControl.value = false;
      showSimilarControl.value = false;
      showSelectControl.value = false;
      showPhotoControl.value = false;
      showConnectControl.value = false;
      showAppointControl.value = false;
      showActionControl.value = false;
      showCallControl.value = false;
      update(["user_detail"]);
    }
    if (tag == "marriage") {
      showBaseControl.value = false;
      showEduControl.value = false;
      showMarriageControl.value = value;
      showSimilarControl.value = false;
      showSelectControl.value = false;
      showPhotoControl.value = false;
      showConnectControl.value = false;
      showAppointControl.value = false;
      showActionControl.value = false;
      showCallControl.value = false;
      update(["user_detail"]);
    }
    if (tag == "similar") {
      showBaseControl.value = false;
      showEduControl.value = false;
      showMarriageControl.value = false;
      showSimilarControl.value = value;
      showSelectControl.value = false;
      showPhotoControl.value = false;
      showConnectControl.value = false;
      showAppointControl.value = false;
      showActionControl.value = false;
      showCallControl.value = false;
      update(["user_detail"]);
    }
    if (tag == "select") {
      showBaseControl.value = false;
      showEduControl.value = false;
      showMarriageControl.value = false;
      showSimilarControl.value = false;
      showSelectControl.value = value;
      showPhotoControl.value = false;
      showConnectControl.value = false;
      showAppointControl.value = false;
      showActionControl.value = false;
      showCallControl.value = false;
      update(["user_detail"]);
    }
    if (tag == "photo") {
      showBaseControl.value = false;
      showEduControl.value = false;
      showMarriageControl.value = false;
      showSimilarControl.value = false;
      showSelectControl.value = false;
      showPhotoControl.value = value;
      showConnectControl.value = false;
      showAppointControl.value = false;
      showActionControl.value = false;
      showCallControl.value = false;
      update(["user_detail"]);
    }
    if (tag == "connect") {
      showBaseControl.value = false;
      showEduControl.value = false;
      showMarriageControl.value = false;
      showSimilarControl.value = false;
      showSelectControl.value = false;
      showPhotoControl.value = false;
      showConnectControl.value = value;
      showAppointControl.value = false;
      showActionControl.value = false;
      showCallControl.value = false;
    }
    if (tag == "appoint") {
      showBaseControl.value = false;
      showEduControl.value = false;
      showMarriageControl.value = false;
      showSimilarControl.value = false;
      showSelectControl.value = false;
      showPhotoControl.value = false;
      showConnectControl.value = false;
      showAppointControl.value = value;
      showActionControl.value = false;
      showCallControl.value = false;
    }
    if (tag == "action") {
      showBaseControl.value = false;
      showEduControl.value = false;
      showMarriageControl.value = false;
      showSimilarControl.value = false;
      showSelectControl.value = false;
      showPhotoControl.value = false;
      showConnectControl.value = false;
      showAppointControl.value = false;
      showActionControl.value = value;
      showCallControl.value = false;
    }
    if (tag == "call") {
      showBaseControl.value = false;
      showEduControl.value = false;
      showMarriageControl.value = false;
      showSimilarControl.value = false;
      showSelectControl.value = false;
      showPhotoControl.value = false;
      showConnectControl.value = false;
      showAppointControl.value = false;
      showActionControl.value = false;
      showCallControl.value = value;
    }
  }

  void buildAppointButton() {
    showBaseControl.value = false;
    showEduControl.value = false;
    showMarriageControl.value = false;
    showSimilarControl.value = false;
    showSelectControl.value = false;
    showPhotoControl.value = false;
    showConnectControl.value = false;
    showAppointControl.value = true;
    showActionControl.value = false;
    showCallControl.value = false;
  }

  void buildConnectButton() {
    showBaseControl.value = false;
    showEduControl.value = false;
    showMarriageControl.value = false;
    showSimilarControl.value = false;
    showSelectControl.value = false;
    showPhotoControl.value = false;
    showConnectControl.value = true;
    showAppointControl.value = false;
    showActionControl.value = false;
    showCallControl.value = false;
  }

  Future<void> editUserOnce(String uuid, String type, String text) async {
    var result = await CommonAPI.editCustomerOnceString(uuid, type, text);
    if (result.code == 200) {
      userDetail = setObjectKeyValue(userDetail!, type, text);
      update(["user_detail"]);
      showToast(Get.context!, "编辑成功", false);
    } else {
      showToast(Get.context!, "result", false);
    }
  }

  Data setObjectKeyValue(Data detail, String key, String value) {
    var d = detail.info.toJson();
    d[key] = value;
    detail.info = Info.fromJson(d);
    return detail;
  }
  Future<void> editUserDemandOnce(String uuid, String type, String text) async {
    var result = await CommonAPI.editCustomerDemandOnce(uuid, type, text);
    if (result.code == 200) {
      userDetail = setObjectDemandKeyValue(userDetail!, type, text);
      update(["user_detail"]);
      showToast(Get.context!, "编辑成功", false);
    } else {
      showToast(Get.context!, "result", false);
    }
  }

  Data setObjectDemandKeyValue(Data detail, String key, String value) {
    var d = detail.demand.toJson();
    d[key] = value;
    detail.demand = Demand.fromJson(d);
    return detail;
  }
  Future<void> getUser() async {
    var result = await CommonAPI.claimCustomer(uuid);
    if (result.code == 200) {
      showToast(Get.context!, '认领成功', true);
    } else {
      showToastRed(Get.context!, result.message!, true);
    }
  }

  void changeUser() {
    int? status = userDetail?.info.status;
    if (userDetail?.info.roleId == 0) {
      showToastRed(Get.context!, "暂无权限", true);
    }
    if (status! < 0) {
      showToastRed(Get.context!, "当前用户状态需认领后再划分", true);

      return;
    }
    if (status == 5) {
      if (userDetail?.info.roleId != 1) {
        showToastRed(Get.context!, "暂无划分权限", true);

        return;
      }
    }

    if (status > 3) {
      showToastRed(Get.context!, "暂无权限", true);

      return;
    }
    Get.toNamed(AppRoutes.Distribute, arguments: uuid);
  }

  void addVip() {
    if (status != 0 && status != 1 && status != 30) {
      showToastRed(Get.context!, "当前用户状态不可购买会员套餐", true);
      return;
    }
    debugPrint("addVip");
    Map<String, dynamic> args = <String, dynamic>{};
    args['uuid'] = uuid;
    args['store_id'] = userDetail?.info.storeId;
    Get.toNamed(AppRoutes.BuyVip, arguments: args);
  }
}
