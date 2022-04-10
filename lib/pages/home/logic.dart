import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/apis/common.dart';
import '../../common/entities/home/common.dart';
import 'state.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();
  final List<SelectItem> selectItems = <SelectItem>[];
  var scaffoldKey =  GlobalKey<ScaffoldState>();
  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  ScrollController scrollController = ScrollController();
  String serveType = "1";
  String totalCount = "";
  String title = "客户管理";
  int curPage = 1;
  int pageSize = 20;
  int total = 20;
  int roleId = 0;
  int currentPhotoMode =0;
  int sex =1;
  @override
  void onInit() {
    _loadData();
    super.onInit();
  }
  // 下拉刷新
  void _loadData() async {
    var result =
    await CommonAPI.searchErpUser(curPage.toString(), "1", "0", "1", []);
    state.homeUser.addAll(result.data.data) ;
    debugPrint(result.toJson().toString());
  }

  // 下拉刷新
  void onRefresh() async {

    curPage=1;
    var result =
    await CommonAPI.searchErpUser(curPage.toString(), "1", "0", "1", []);
    state.homeUser.clear();
    state.homeUser .addAll(result.data.data) ;
    debugPrint(result.toString());
    refreshController.refreshCompleted();
  }

  // 上拉加载
  void onLoading() async {
    curPage++;
    var result =
    await CommonAPI.searchErpUser(curPage.toString(), "1", "0", "1", []);
    state.homeUser.addAll(result.data.data) ;
    refreshController.loadComplete();
  }
}
