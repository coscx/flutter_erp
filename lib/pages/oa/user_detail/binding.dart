import 'package:flutter_erp/pages/search/logic.dart';
import 'package:flutter_erp/pages/search/view.dart';
import 'package:get/get.dart';

import 'logic.dart';

class OAUserDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OAUserDetailLogic());
    Get.lazyPut(() => SearchLogic());
  }
}
