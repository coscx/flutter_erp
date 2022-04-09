import 'package:dio/dio.dart';
import 'package:flutter_erp/common/entities/entities.dart';
import 'package:flutter_erp/common/entities/flow/wx_article.dart';
import 'package:flutter_erp/common/entities/login/login_model.dart';
import 'package:flutter_erp/common/utils/utils.dart';

import '../entities/app_version.dart';
import '../entities/erp_user.dart';
import '../entities/home/common.dart';
import '../entities/home/search_erp.dart';
import '../utils/common_http.dart';
import '../utils/new_common_http.dart';

/// 用户
class CommonAPI {
  /// 登录
  static Future<AppVersionEntity> getVersion() async {
    var response = await ERPHttpUtil().post(
      '/api/v1/auth/version',
      data: {},
    );
    return AppVersionEntity.fromJson(response);
  }
  static Future<LoginEntity> login(String username, String password) async {
    var data = {'username': username, 'password': password};
    var response = await ERPHttpUtil().post(
      '/api/v1/auth/loginApp',
      queryParameters: data,
    );
    return LoginEntity.fromJson(response);
  }
  static Future<LoginEntity> wxLogin(String code) async {
    var data = {'code': code};
    var response = await ERPHttpUtil().post(
      '/api/v1/auth/loginAppByWechat',
      queryParameters: data,
    );
    return LoginEntity.fromJson(response);
  }
  static Future<WxArticleEntity> wxArticle(  int page, final List<SelectItem> selectItems) async {
    Map<String, dynamic> searchParm = {};
    searchParm['currentPage'] = page;

    selectItems.map((e) {
      if (e.type == 300) {
        searchParm['start_age'] = e.id;
      }
      if (e.type == 301) {
        searchParm['end_age'] = e.id;
      }
      if (e.type == 600) {
        if (e.id != "0") {
          searchParm['store_id'] = e.id;
        }
      }
      if (e.type == 1000) {
        searchParm['gender'] = e.id;
      }
    }).toList();
    Map<String, dynamic> response = await NewERPHttpUtil().post(
      '/api/IPadCommonArticle',
      data: searchParm,
    );
    return WxArticleEntity.fromJson(response);
  }
  /// 登录
  static Future<HomeEntity> searchErpUser(
      String page,
      String sex,
      String mode,
      String serveType,
      final List<SelectItem> selectItems) async {
    Map<String, dynamic> searchParam = {};
    var channel = <String>[];
    var education = <String>[];
    var income = <String>[];
    var house = <String>[];
    var marriage = <String>[];
    var startBirthday = "";
    var endBirthday = "";
    var storeId = "0";
    var userId = "0";
    selectItems.map((e) {
      if (e.type == 100) {
        searchParam['store_id'] = e.id;
      }
      if (e.type == 120) {
        if (e.id == "1") {
          searchParam['status'] = 1;
        }
        if (e.id == "2") {
          searchParam['status'] = 2;
        }
        if (e.id == "30") {
          searchParam['status'] = 30;
        }
        if (e.id == "100") {
          searchParam['status'] = 0;
        }
      }
      if (e.type == 130) {
        searchParam['connect'] = e.id;
      }
      if (e.type == 0) {
        channel.add(e.id!);
      }
      if (e.type == 1) {
        education.add(e.id!);
      }
      if (e.type == 2) {
        income.add(e.id!);
      }
      if (e.type == 3) {
        house.add(e.id!);
      }
      if (e.type == 4) {
        marriage.add(e.id!);
      }

      if (e.type == 5) {
        startBirthday = e.id.toString();
      }
      if (e.type == 6) {
        endBirthday = e.id.toString();
      }
      if (e.type == 7) {
        storeId = e.id!;
      }
      if (e.type == 8) {
        userId = e.id!;
      }
    }).toList();
    if (channel.isNotEmpty) {
      searchParam['channel_multi'] = channel.join(",");
    }

    if (education.isNotEmpty) {
      searchParam['education_multi'] = education.join(",");
    }

    if (income.isNotEmpty) {
      searchParam['income_multi'] = income.join(",");
    }
    if (house.isNotEmpty) {
      searchParam['house_multi'] = house.join(",");
    }

    if (marriage.isNotEmpty) {
      searchParam['marriage_multi'] = marriage.join(",");
    }
    if (startBirthday != "" && endBirthday != "") {
      searchParam['startBirthday'] = startBirthday;
      searchParam['endBirthday'] = endBirthday;
    }
    // if (storeId !=""){
    //
    //   searchParm['store_id'] = storeId;
    //
    // }
    if (userId != "") {
      searchParam['user_id'] = userId;
    }

    searchParam['gender'] = sex;

    searchParam['pageSize'] = 20;
    searchParam['currentPage'] = page;
    String url = "/api/v1/customer/system/index";
    if (mode == "0") {
      //全部
      url = "/api/v1/customer/system/index";
    }
    if (mode == "1") {
      //良缘
      url = "/api/v1/customer/passive/index";
    }
    if (mode == "2") {
      //我的
      url = "/api/v1/customer/personal/index";
      searchParam['type'] = serveType;
    }
    if (mode == "3") {
      //我的
      url = "/api/v1/customer/public/index";
    }
    var response = await NewERPHttpUtil().get(
      url,
      queryParameters: searchParam,
    );
    return HomeEntity.fromJson(response);
  }


}
