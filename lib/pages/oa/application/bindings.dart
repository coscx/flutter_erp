import 'package:flutter_erp/pages/conversion/logic.dart';
import 'package:flutter_erp/pages/conversion/view.dart';
import 'package:flutter_erp/pages/flow_page/logic.dart';
import 'package:flutter_erp/pages/frame/login/logic.dart';
import 'package:flutter_erp/pages/home/logic.dart';
import 'package:flutter_erp/pages/main/index.dart';
import 'package:flutter_erp/pages/oa/home_message/logic.dart';
import 'package:flutter_erp/pages/oa/person/logic.dart';
import 'package:flutter_erp/pages/oa/work/logic.dart';
import 'package:flutter_erp/pages/peer_chat/logic.dart';
import 'package:get/get.dart';

import 'controller.dart';

class OAApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OAApplicationController>(() => OAApplicationController());
    Get.lazyPut<HomeMessageLogic>(() => HomeMessageLogic());
    Get.lazyPut<PersonLogic>(() => PersonLogic());
    Get.lazyPut<WorkLogic>(() => WorkLogic());

  }
}
