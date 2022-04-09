import 'dart:convert';
import 'dart:typed_data';

import 'package:city_pickers/modal/result.dart';
import 'package:dio/dio.dart';

import 'package:get/get.dart' as GET;
import 'package:get/get_core/src/get_main.dart';
import 'package:http_parser/http_parser.dart';

import '../entities/erp_user.dart';
import '../entities/home/search_erp.dart';
import '../store/user.dart';

const kBaseUrl = 'https://cores.queqiaochina.com';
const NewBaseUrl = 'https://erp.queqiaochina.com';

class IssuesApi {
  /// 自定义Header
  static Map<String, dynamic> httpHeaders = {
    'Accept': 'application/json,*/*',
    'Content-Type': 'application/json',
    'authorization': ""
  };
  static Dio dio = Dio(BaseOptions(baseUrl: kBaseUrl, headers: httpHeaders));
  static Dio dioA = Dio(BaseOptions(baseUrl: NewBaseUrl, headers: httpHeaders));

  /// 登录
  static Future<Object> searchErpUsers(
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
        channel.add(e.id);
      }
      if (e.type == 1) {
        education.add(e.id);
      }
      if (e.type == 2) {
        income.add(e.id);
      }
      if (e.type == 3) {
        house.add(e.id);
      }
      if (e.type == 4) {
        marriage.add(e.id);
      }

      if (e.type == 5) {
        startBirthday = e.id.toString();
      }
      if (e.type == 6) {
        endBirthday = e.id.toString();
      }
      if (e.type == 7) {
        storeId = e.id;
      }
      if (e.type == 8) {
        userId = e.id;
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
    if (GET.Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
      dioA.options.headers['authorization'] = 'Bearer ${UserStore.to.token}';
    }
    try {
      Response<dynamic>  response = await dioA.get(url, queryParameters: searchParam);
      return HomeEntity.fromJson(response.data);
    } on DioError catch (e) {
      return resSet(e);
    }

  }
  static Map<String, dynamic> resSet(DioError e) {
    if (e.response == null) {
      var dds = <String, dynamic>{};
      dds['code'] = 500;
      dds['message'] = "server not reach";
      dds['data'] = {};
      return dds;
    }
    var dd = e.response?.data;

    if (dd is String) {
      var dds = <String, dynamic>{};
      dds['code'] = 400;
      dds['message'] = dd;
      dds['data'] = {};
      return dds;
    }
    return dd;
  }
}
