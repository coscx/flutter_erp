import 'package:flutter/material.dart';
import 'package:flutter_erp/common/entities/detail/action.dart';
import 'package:flutter_erp/common/entities/detail/appoint.dart';
import 'package:flutter_erp/common/entities/detail/calllog.dart';
import 'package:flutter_erp/common/entities/detail/connect.dart';
import 'package:flutter_erp/common/entities/detail/user_detail.dart';
import 'package:flutter_erp/pages/user_detail/widget/share.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/apis/common.dart';
import 'state.dart';

class UserDetailLogic extends GetxController {
  final UserDetailState state = UserDetailState();
  String memberId = "80";
  int connectStatus = 4;
  int canEdit = 0;
  String call = "";
  String uuid = "";
  int status = 10;
  bool showBaseControl = false;
  bool showEduControl = false;
  bool showMarriageControl = false;
  bool showSimilarControl = false;
  bool showSelectControl = false;
  bool showPhotoControl = false;
  bool showAppointControl = false;
  bool showConnectControl = false;
  bool showActionControl = false;
  bool showCallControl = false;
  Data? userDetail ;
  RxInt load =0.obs;
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
    uuid=Get.arguments;
    var result = await CommonAPI.getUserDetail(uuid);
    userDetail = result.data;
    load.value =1;
    _loadOtherData();
    //debugPrint(result.toJson().toString());
  }
  void _loadOtherData() async {
    var connect = await CommonAPI.getConnectList(uuid,1);
    connectList.addAll(connect.data.data);

    var appoint = await CommonAPI.getAppointmentList(uuid,1);
    appointList.addAll(appoint.data.data) ;

    var action = await CommonAPI.getActionList(uuid,1);
    actionList.addAll(action.data.data)  ;

    var call = await CommonAPI.getCallList(uuid,1);
    callList.addAll(call.data.data)  ;

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
      showBaseControl = value;
      showEduControl = false;
      showMarriageControl = false;
      showSimilarControl = false;
      showSelectControl = false;
      showPhotoControl = false;
      showConnectControl = false;
      showAppointControl = false;
      showActionControl = false;
      showCallControl = false;
    }
    if (tag == "education") {
      showBaseControl = false;
      showEduControl = value;
      showMarriageControl = false;
      showSimilarControl = false;
      showSelectControl = false;
      showPhotoControl = false;
      showConnectControl = false;
      showAppointControl = false;
      showActionControl = false;
      showCallControl = false;
    }
    if (tag == "marriage") {
      showBaseControl = false;
      showEduControl = false;
      showMarriageControl = value;
      showSimilarControl = false;
      showSelectControl = false;
      showPhotoControl = false;
      showConnectControl = false;
      showAppointControl = false;
      showActionControl = false;
      showCallControl = false;
    }
    if (tag == "similar") {
      showBaseControl = false;
      showEduControl = false;
      showMarriageControl = false;
      showSimilarControl = value;
      showSelectControl = false;
      showPhotoControl = false;
      showConnectControl = false;
      showAppointControl = false;
      showActionControl = false;
      showCallControl = false;
    }
    if (tag == "select") {
      showBaseControl = false;
      showEduControl = false;
      showMarriageControl = false;
      showSimilarControl = false;
      showSelectControl = value;
      showPhotoControl = false;
      showConnectControl = false;
      showAppointControl = false;
      showActionControl = false;
      showCallControl = false;
    }
    if (tag == "photo") {
      showBaseControl = false;
      showEduControl = false;
      showMarriageControl = false;
      showSimilarControl = false;
      showSelectControl = false;
      showPhotoControl = value;
      showConnectControl = false;
      showAppointControl = false;
      showActionControl = false;
      showCallControl = false;
    }
    if (tag == "connect") {
      showBaseControl = false;
      showEduControl = false;
      showMarriageControl = false;
      showSimilarControl = false;
      showSelectControl = false;
      showPhotoControl = false;
      showConnectControl = value;
      showAppointControl = false;
      showActionControl = false;
      showCallControl = false;
    }
    if (tag == "appoint") {
      showBaseControl = false;
      showEduControl = false;
      showMarriageControl = false;
      showSimilarControl = false;
      showSelectControl = false;
      showPhotoControl = false;
      showConnectControl = false;
      showAppointControl = value;
      showActionControl = false;
      showCallControl = false;
    }
    if (tag == "action") {
      showBaseControl = false;
      showEduControl = false;
      showMarriageControl = false;
      showSimilarControl = false;
      showSelectControl = false;
      showPhotoControl = false;
      showConnectControl = false;
      showAppointControl = false;
      showActionControl = value;
      showCallControl = false;
    }
    if (tag == "call") {
      showBaseControl = false;
      showEduControl = false;
      showMarriageControl = false;
      showSimilarControl = false;
      showSelectControl = false;
      showPhotoControl = false;
      showConnectControl = false;
      showAppointControl = false;
      showActionControl = false;
      showCallControl = value;
    }
  }

  void buildAppointButton() {
    showBaseControl = false;
    showEduControl = false;
    showMarriageControl = false;
    showSimilarControl = false;
    showSelectControl = false;
    showPhotoControl = false;
    showConnectControl = false;
    showAppointControl = true;
    showActionControl = false;
    showCallControl = false;
  }

  void buildConnectButton() {
    showBaseControl = false;
    showEduControl = false;
    showMarriageControl = false;
    showSimilarControl = false;
    showSelectControl = false;
    showPhotoControl = false;
    showConnectControl = true;
    showAppointControl = false;
    showActionControl = false;
    showCallControl = false;
  }
}
