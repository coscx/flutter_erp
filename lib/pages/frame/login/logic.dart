import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/apis/common.dart';
import '../../../common/routers/names.dart';
import '../../../common/services/storage.dart';
import '../../../common/store/user.dart';
import 'state.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
class LoginLogic extends GetxController {
  final LoginState state = LoginState();
  final usernameController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  FocusNode textFieldNode = FocusNode();
  bool showPwd = false;
  String result = "无";
  bool autoLogin =true;
  @override
  void onInit() {
    wxInit();
    super.onInit();
  }
  void wxInit(){
    fluwx.weChatResponseEventHandler
        .distinct((a, b) => a == b)
        .listen((res) async {
      if (res is fluwx.WeChatAuthResponse) {
        if (res.state == "wechat_sdk_demo_login") {
           wxToLogin( res.code!);
        }
      }
    });
  }

  void wxLogin(){
    fluwx
        .sendWeChatAuth(
        scope: "snsapi_userinfo", state: "wechat_sdk_demo_login")
        .then((data) {});
  }

  Future<bool> login(String username, String password) async {
    var result = await CommonAPI.login(username, password);
    if (result.code == 200) {
      StorageService.to.setString("im_sender", result.data!.user.id.toString());
      StorageService.to.setString("name", result.data!.user.relname);
      StorageService.to.setString("uuid", result.data!.user.uuid);
      StorageService.to.setString("openid", result.data!.user.openid);
      StorageService.to.setString("user_token", result.data!.token.accessToken);
      StorageService.to.setString("fresh_token", result.data!.token.refreshToken);
      StorageService.to.setString("memberId", result.data!.user.id.toString());
      StorageService.to.setString("im_token", result.data!.imToken);
      StorageService.to.setString("avatar", result.data!.user.avatar);
      StorageService.to.setString("roleId", result.data!.user.idcardVerified.toString());
      UserStore.to.saveProfile(result);
      Get.offAndToNamed(AppRoutes.Application);
      return true;
    }

    debugPrint(result.toJson().toString());
    return false;
  }

  Future<bool> wxToLogin(String code) async {
    var result = await CommonAPI.wxLogin(code);
    if (result.code == 200) {
      StorageService.to.setString("im_sender", result.data!.user.id.toString());
      StorageService.to.setString("name", result.data!.user.relname);
      StorageService.to.setString("uuid", result.data!.user.uuid);
      StorageService.to.setString("openid", result.data!.user.openid);
      StorageService.to.setString("user_token", result.data!.token.accessToken);
      StorageService.to.setString("fresh_token", result.data!.token.refreshToken);
      StorageService.to.setString("memberId", result.data!.user.id.toString());
      StorageService.to.setString("im_token", result.data!.imToken);
      StorageService.to.setString("avatar", result.data!.user.avatar);
      StorageService.to.setString("roleId", result.data!.user.idcardVerified.toString());
      UserStore.to.saveProfile(result);
      Get.offAndToNamed(AppRoutes.Application);
      return true;
    }

    debugPrint(result.toJson().toString());
    return false;
  }
}
