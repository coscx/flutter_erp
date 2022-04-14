import 'package:flutter_erp/common/services/services.dart';
import 'package:get/get.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import '../../common/apis/common.dart';
import 'state.dart';

class MineLogic extends GetxController {
  final MineState state = MineState();
  var name ="MSTAR".obs;
  String bind="微信绑定";
  var memberId="0".obs;
  var userHead =
      'https://img.bosszhipin.com/beijin/mcs/useravatar/20171211/4d147d8bb3e2a3478e20b50ad614f4d02062e3aec7ce2519b427d24a3f300d68_s.jpg'.obs;
  String lost="0";
  String join="0";
  String connect="0";
  @override
  void onInit() {
    init();
    super.onInit();
  }
 void init()async{
   memberId.value = StorageService.to.getString("memberId");
   userHead.value = StorageService.to.getString("avatar");
   name.value = StorageService.to.getString("name");
   fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) async {
     if (res is fluwx.WeChatAuthResponse) {
       if(res.state =="wechat_sdk_demo_bind") {
         var result = await CommonAPI.bindAppWeChat(res.code!);
         if (result.code == 200) {
            //StorageService.to.setString("openid",result.data!.imToken);

             bind="已绑定微信";

         } else {
           // _showToast(context, result['message'], false);
         }
       }
     }
   });
  }
  void bindWxOnTap(){
    fluwx
        .sendWeChatAuth(
        scope: "snsapi_userinfo", state: "wechat_sdk_demo_bind")
        .then((data) {});
  }

}
