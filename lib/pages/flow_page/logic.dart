import 'package:flutter/cupertino.dart';
import 'package:flutter_erp/common/apis/common.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'state.dart';

class FlowPageLogic extends GetxController {
  final FlowPageState state = FlowPageState();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  /// 成员变量
  String categoryCode = '';
  int curPage = 1;
  int pageSize = 20;
  int total = 20;

  @override
  void onInit() {
    _loadData();

    super.onInit();
  }

  // 下拉刷新
  void _loadData() async {
    var result =
        await CommonAPI.wxArticle(curPage,  []);
    state.wxUser.addAll(result.data.data) ;
    debugPrint(result.toJson().toString());
  }

  // 下拉刷新
  void onRefresh() async {
    var result =
    await CommonAPI.wxArticle(curPage,  []);
    state.wxUser.clear();
    curPage=1;
    state.wxUser.addAll(result.data.data) ;
    debugPrint(result.toString());
    refreshController.refreshCompleted();
  }

  // 上拉加载
  void onLoading() async {
    curPage++;
    var result =
    await CommonAPI.wxArticle(curPage,  []);
    state.wxUser.addAll(result.data.data) ;
    refreshController.loadComplete();
  }
}
