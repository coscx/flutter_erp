import 'package:flt_im_plugin/conversion.dart';
import 'package:flt_im_plugin/flt_im_plugin.dart';
import 'package:flt_im_plugin/value_util.dart';
import 'package:flutter_erp/common/services/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'state.dart';

class ConversionLogic extends GetxController {
  final ConversionState state = ConversionState();
  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  var popString = ['清空记录', '删除好友', '加入黑名单'];
  int offset = 0;
  int limit = 10; //一次加载10条数据,不建议加载太多。
   String memberId="82";
  void onRefresh() async {
    FltImPlugin im = FltImPlugin();
    Map response = await im.getConversations();
    var  conversions = ValueUtil.toArr(response["data"]).map((e) => Conversion.fromMap(ValueUtil.toMap(e))).toList();
    conversions.map((e) {
      e.detail= (e.detail);
      return e;
    }).toList();
    state.conversion.clear();
    state.conversion.addAll(conversions);
    offset = 0;
    refreshController.refreshCompleted();
  }
  @override
  void onInit() {
   init();
    super.onInit();
  }
  void onTapDeleteConversion(String cid){
    FltImPlugin im = FltImPlugin();
    im.deleteConversation(cid: cid);

  }

  void onTap(Conversion msg){
    FltImPlugin im = FltImPlugin();
    List<Conversion> messages;
    if (msg.type == ConversionType.CONVERSATION_GROUP) {
      im.clearGroupReadCount(cid: msg.cid);
    var   message = state.conversion.map((e) {
        if (e.type == ConversionType.CONVERSATION_GROUP) {
          e.newMsgCount = 0;
          return e;
        } else {
          return e;
        }
      }).toList();
    state.conversion.addAll(message);
    }

    if (msg.type == ConversionType.CONVERSATION_PEER) {
      im.clearGroupReadCount(cid: msg.cid);
      var   message = state.conversion.map((e) {
        if (e.type == ConversionType.CONVERSATION_PEER) {
          e.newMsgCount = 0;
          return e;
        } else {
          return e;
        }
      }).toList();
      state.conversion.addAll(message);
    }

    var count = 0;
    state.conversion.map((e) {
      count += e.newMsgCount;
    }).toList();
    if (count == 0) {
      //BlocProvider.of<GlobalBloc>(context).add(EventSetBar3(0));
    }
    var memberId = StorageService.to.getString("memberId");
    if (memberId != "" && memberId != null) {
      memberId = memberId.toString();
    }

    final Conversion model = Conversion.fromMap({
      "memId": memberId,
      "cid": msg.cid,
      "name": msg.name
    });
    if (msg.type ==
        ConversionType.CONVERSATION_GROUP) {

    }
    if (msg.type ==
        ConversionType.CONVERSATION_PEER) {

    }
  }

  Future<void> init() async {

    FltImPlugin im = FltImPlugin();
    Map response = await im.getConversations();
    var  conversions = ValueUtil.toArr(response["data"]).map((e) => Conversion.fromMap(ValueUtil.toMap(e))).toList();
    conversions.map((e) {
      e.detail= (e.detail);
      return e;
    }).toList();
    state.conversion.addAll(conversions);
  }
}
