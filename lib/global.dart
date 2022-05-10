import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_erp/common/services/services.dart';
import 'package:flutter_erp/common/store/store.dart';
import 'package:flutter_erp/common/utils/utils.dart';
import 'package:fluwx/fluwx.dart';
import 'package:get/get.dart';

import 'common/values/key.dart';

/// 全局静态数据
class Global {
  /// 初始化
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    setSystemUi();
    Loading();
    otherInit();
    await Get.putAsync<StorageService>(() => StorageService().init());
    Get.put<ConfigStore>(ConfigStore());
    Get.put<UserStore>(UserStore());
  }

  static void setSystemUi() {
    if (GetPlatform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
  static void otherInit() async{
   await registerWxApi(
        appId: wxKey,
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: universalLink);
    var result = await isWeChatInstalled;
    print("wx is installed $result");
    var success = await startLog(logLevel: WXLogLevel.NORMAL);
    print('startlog:$success\n');
  }

}
