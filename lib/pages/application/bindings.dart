import 'package:flutter_erp/pages/conversion/logic.dart';
import 'package:flutter_erp/pages/conversion/view.dart';
import 'package:flutter_erp/pages/flow_page/logic.dart';
import 'package:flutter_erp/pages/frame/login/logic.dart';
import 'package:flutter_erp/pages/home/logic.dart';
import 'package:flutter_erp/pages/main/index.dart';
import 'package:flutter_erp/pages/peer_chat/logic.dart';
import 'package:get/get.dart';

import '../mine/logic.dart';
import '../search/logic.dart';
import 'controller.dart';

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<FlowPageLogic>(() => FlowPageLogic());

    Get.lazyPut<HomeLogic>(() => HomeLogic());
    Get.lazyPut<MineLogic>(() => MineLogic());
    Get.lazyPut<ConversionLogic>(() => ConversionLogic());
  }
}
