import 'package:get/get.dart';

import 'logic.dart';

class UserDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserDetailLogic());
  }
}
