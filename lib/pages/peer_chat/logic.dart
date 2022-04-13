import 'dart:async';
import 'dart:io';

import 'package:flt_im_plugin/conversion.dart';
import 'package:flt_im_plugin/flt_im_plugin.dart';
import 'package:flt_im_plugin/message.dart';
import 'package:flt_im_plugin/value_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_erp/pages/peer_chat/widget/peer_chat_item.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:frefresh/frefresh.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

import '../conversion/widget/colors.dart';
import '../conversion/widget/object_util.dart';
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
        currentUID:  model.memId,
        peerUID: model.cid,
      );
      Map response = await im.loadData();
      var messages = ValueUtil.toArr(response["data"])
          .map((e) => Message.fromMap(ValueUtil.toMap(e)))
          .toList()
          .reversed
          .toList();
      messages.map((e) {
        e.content['text'] =(e.content['text']);
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
        currentUID:  model.memId,
        peerUID: model.cid,
      );
      Map response = await im.loadData();
      var messages = ValueUtil.toArr(response["data"])
          .map((e) => Message.fromMap(ValueUtil.toMap(e)))
          .toList()
          .reversed
          .toList();
      messages.map((e) {
        e.content['text'] =(e.content['text']);
        return e;
      }).toList();
      messageList.addAll(messages);
      update();
    } catch (err) {
      print(err);

    }
  }


}
