import 'package:flutter_erp/pages/category/index.dart';
import 'package:flutter_erp/pages/flow_page/logic.dart';
import 'package:flutter_erp/pages/frame/login/logic.dart';
import 'package:flutter_erp/pages/main/index.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<FlowPageLogic>(() => FlowPageLogic());
    Get.lazyPut<LoginLogic>(() => LoginLogic());
  }
}
