import 'dart:async';
import 'package:flt_im_plugin/conversion.dart';
import 'package:flt_im_plugin/flt_im_plugin.dart';
import 'package:flt_im_plugin/message.dart';
import 'package:flt_im_plugin/value_util.dart';
import 'package:get/get.dart';
import 'state.dart';

class PeerChatLogic extends GetxController {
  final PeerChatState state = PeerChatState();
  Conversion model = Get.arguments;
  String memId = "";
  List<Message> messageList = <Message>[];
  @override
  void onInit() {
    eventFirstLoadMessage();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
  Future<void> receiveMsgFresh() async {
    try {
      Map<String, dynamic> messageMap = {};
      FltImPlugin im = FltImPlugin();
      var res = await im.createConversion(
        currentUID:  model.memId!,
        peerUID: model.cid!,
      );
      Map? response = await im.loadData(messageID: '0');
      var messages = ValueUtil.toArr(response!["data"])
          .map((e) => Message.fromMap(ValueUtil.toMap(e)))
          .toList()
          .reversed
          .toList();
      messages.map((e) {
        e.content!['text'] =(e.content!['text']);
        return e;
      }).toList();
      messageList.clear();
      messageList.addAll(messages);
      update();
    } catch (err) {
      print(err);

    }
  }

  Future<void> eventFirstLoadMessage() async {
    try {
      Map<String, dynamic> messageMap = {};
      FltImPlugin im = FltImPlugin();
      var res = await im.createConversion(
        currentUID:  model.memId!,
        peerUID: model.cid!,
      );
      Map? response = await im.loadData(messageID: '0');
      var messages = ValueUtil.toArr(response!["data"])
          .map((e) => Message.fromMap(ValueUtil.toMap(e)))
          .toList()
          .reversed
          .toList();
      messages.map((e) {
        e.content!['text'] =(e.content!['text']);
        return e;
      }).toList();
      messageList.addAll(messages);
      update();
    } catch (err) {
      print(err);

    }
  }


}
