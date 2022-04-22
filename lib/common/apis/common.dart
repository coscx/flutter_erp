
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_erp/common/entities/common_result.dart';
import 'package:flutter_erp/common/entities/detail/calllog.dart';
import 'package:flutter_erp/common/entities/detail/claim_customer.dart';
import 'package:flutter_erp/common/entities/detail/connect.dart';
import 'package:flutter_erp/common/entities/detail/edit_customer.dart';
import 'package:flutter_erp/common/entities/detail/user.dart';
import 'package:flutter_erp/common/entities/detail/free_vip.dart';
import 'package:flutter_erp/common/entities/detail/store_vip.dart';
import 'package:flutter_erp/common/entities/detail/user_detail.dart';
import 'package:flutter_erp/common/entities/detail/viewcall.dart';

import 'package:flutter_erp/common/entities/flow/wx_article.dart';
import 'package:flutter_erp/common/entities/home/erp_user.dart';
import 'package:flutter_erp/common/entities/home/tree_store.dart';
import 'package:flutter_erp/common/entities/login/login_model.dart';
import 'package:http_parser/http_parser.dart';
import '../entities/app_version.dart';
import '../entities/detail/action.dart';
import '../entities/detail/appoint.dart';
import '../entities/erp_user.dart';
import '../entities/home/common.dart';
import '../entities/home/only_store.dart';
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
  static Future<LoginEntity> bindAppWeChat(String code) async {
    var response = await ERPHttpUtil().post(
      '/api/v1/auth/version',
      queryParameters: {"code":code},
    );
    return LoginEntity.fromJson(response);
  }
  static Future<Stores> getOnlyStoreList() async {
    var response = await ERPHttpUtil().get(
      '/api/v1/store/select',
      queryParameters: {},
    );
    return Stores.fromJson(response);
  }
  static Future<ErpUserResult> getErpUsers(String storeId) async {
    var response = await NewERPHttpUtil().post(
      '/api/GetErpUserByStoreId',
      queryParameters: {'store_id': storeId},
    );
    return ErpUserResult.fromJson(response);
  }
  static Future<TreeStoreResult> getTreeStoreList() async {
    var response = await ERPHttpUtil().get(
      '/api/v1/system/user/getTreeStoreOnline',
      queryParameters: {},
    );
    return TreeStoreResult.fromJson(response);
  }
  static Future<UserDetailResult> getUserDetail(String uuid) async {
    var response = await NewERPHttpUtil().post(
      '/api/v1/customer/detail/'+uuid,
      queryParameters: {},
    );
    return UserDetailResult.fromJson(response);
  }
  static Future<ConnectDataResult> getConnectList(String uuid, int page) async {
    var response = await NewERPHttpUtil().get(
      '/api/v1/customer/connectList',
      queryParameters: {'customer_uuid': uuid, 'currentPage': page, "pageSize": 20},
    );
    return ConnectDataResult.fromJson(response);
  }
  static Future<AppointDataResult> getAppointmentList(String uuid, int page) async {
    var response = await NewERPHttpUtil().get(
      '/api/v1/customer/appointmentList',
      queryParameters: {'customer_uuid': uuid, 'currentPage': page, "pageSize": 20},
    );
    return AppointDataResult.fromJson(response);
  }

  static Future<UserActionDataResult> getActionList(String uuid, int page) async {
    var response = await NewERPHttpUtil().get(
      '/api/v1/customer/actionList',
      queryParameters: {'customer_uuid': uuid, 'currentPage': page, "pageSize": 20},
    );
    return UserActionDataResult.fromJson(response);
  }
  static Future<CallLogDataResult> getCallList(String uuid, int page) async {
    var response = await NewERPHttpUtil().get(
      '/api/v1/customer/callLogs',
      queryParameters: {'customer_uuid': uuid, 'currentPage': page, "pageSize": 20},
    );
    return CallLogDataResult.fromJson(response);
  }
  static Future<ViewCallResult> viewCall(String uuid) async {
    var response = await ERPHttpUtil().get(
      '/api/v1/auth/getCustomerMobile/' + uuid,
      queryParameters: {'customer_uuid': uuid},
    );
    return ViewCallResult.fromJson(response);
  }

  static Future<ClaimCustomerResult> claimCustomer(String uuid) async {
    var response = await ERPHttpUtil().post(
      '/api/v1/customer/public/claimCustomerApp',
      queryParameters: {'customer_uuids[0]': uuid},
    );
    return ClaimCustomerResult.fromJson(response);
  }
  static Future<StoreVipDataResult> getStoreVips() async {
    var response = await NewERPHttpUtil().post(
      '/api/GetStoreVips',
      data: {},
    );
    return StoreVipDataResult.fromJson(response);
  }
  static Future<FreeVipDataResult> addMealFree( Map<String, dynamic> data) async {
    var response = await ERPHttpUtil().post(
      '/api/v1/store/addMealFree',
      queryParameters: data,
    );
    return FreeVipDataResult.fromJson(response);
  }
  static Future<CommonResult> buyVip( Map<String, dynamic> data) async {
    var response = await ERPHttpUtil().post(
      '/api/v1/customer/buyVipApp',
      queryParameters: data,
    );
    return CommonResult.fromJson(response);
  }
  static Future<UserDataResult> getErpUser() async {
    var response = await NewERPHttpUtil().post(
      '/api/UserList',
      data: {},
    );
    return UserDataResult.fromJson(response);
  }

  static Future<CommonResult> distribute(String uuid, int type, String userUuid) async {
    var response = await ERPHttpUtil().post(
      '/api/v1/customer/system/distribute',
      queryParameters: {'customer_uuids[0]': uuid, 'type': type, 'user_uuid': userUuid},
    );
    return CommonResult.fromJson(response);
  }
  static Future<CommonResult> editCustomerOnceString(String uuid, String type, String answer) async {
    Map<String, dynamic> searchParam = {};
    searchParam[type] = answer;
    var response = await ERPHttpUtil().post(
      '/api/v1/customer/editCustomer/' + uuid,
      queryParameters: searchParam,
    );
    return CommonResult.fromJson(response);
  }
  static Future<CommonResult> editCustomerOnceStringResource(String uuid, String type, String url) async {
    var data = {
      'resources': json.encode([
        {'type': type, 'file_url': url}
      ])
    };
    var response = await ERPHttpUtil().post(
      '/api/v1/customer/editCustomer/' + uuid,
      queryParameters: data,
    );
    return CommonResult.fromJson(response);
  }

  static Future<CommonResult> editCustomerAddress(String uuid, Map<String, dynamic> searchParam) async {

    var response = await ERPHttpUtil().post(
      '/api/v1/customer/editCustomer/' + uuid,
      queryParameters: searchParam,
    );
    return CommonResult.fromJson(response);
  }
  static Future<CommonResult> editCustomerDemndAddress(String uuid, Map<String, dynamic> searchParam) async {

    var response = await ERPHttpUtil().post(
      '/api/v1/customer/editCustomerDemand/' + uuid,
      queryParameters: searchParam,
    );
    return CommonResult.fromJson(response);
  }
  static Future<CommonResult> editCustomerDemandOnce(String uuid, String type, String answer) async {
    Map<String, dynamic> searchParam = {};
    searchParam[type] = answer;
    var response = await ERPHttpUtil().post(
      '/api/v1/customer/editCustomerDemand/' + uuid,
      queryParameters: searchParam,
    );
    return CommonResult.fromJson(response);
  }

  static Future<CommonResult> delPhoto( int imgId,) async {
    var response = await ERPHttpUtil().post(
      '/api/v1/customer/deleteResources' ,
      queryParameters: {'ids[0]': imgId},
    );
    return CommonResult.fromJson(response);
  }
  static Future<CommonResult> uploadPhotoFile( int type, String path) async {
    MultipartFile multipartFile = MultipartFile.fromFileSync(
      path,
      // 文件名
      filename: 'some-file-name.jpg',
      // 文件类型
      contentType: MediaType("image", "jpg"),
    );
    FormData formData = FormData.fromMap({
      // 后端接口的参数名称
      "resource": multipartFile
    });
    Map<String, dynamic> params = Map();
    params['type'] = type;

    var response = await ERPHttpUtil().post(
      '/api/v1/customer/uploadPic' ,
        data: formData, queryParameters: params,
    );
    return CommonResult.fromJson(response);
  }
  static Future<CommonResult> addCustomer(String mobile,
      String name,
      int gender,
      String birthday,
      int marriage,
      int channel,) async {
    Map<String, dynamic> data = {};
    data['mobile'] = mobile;
    data['name'] = name;
    data['gender'] = gender;
    data['birthday'] = birthday;
    data['marriage'] = marriage;
    data['channel'] = channel;
    var response = await ERPHttpUtil().post(
      '/api/v1/customer/personal/addCustomer',
      queryParameters: data,
    );
    return CommonResult.fromJson(response);
  }
  static Future<HomeEntity> searchCustomer(   String page,
      String keyWord,) async {
    Map<String, dynamic> data = {};
    data['app'] = keyWord;
    data['currentPage'] = page;
    data['pageSize'] = 20;
    var response = await NewERPHttpUtil().get(
      '/api/v1/customer/system/index',
      queryParameters: data,
    );
    return HomeEntity.fromJson(response);
  }
  static Future<CommonResult> addAppoint(  String uuid, Map<String, dynamic> data) async {
    var response = await ERPHttpUtil().post(
      '/api/v1/customer/addAppointment',
      queryParameters: data,
    );
    return CommonResult.fromJson(response);
  }
  static Future<CommonResult> addConnect(  String uuid, Map<String, dynamic> data) async {
    var response = await ERPHttpUtil().post(
      '/api/v1/customer/addConnect',
      queryParameters: data,
    );
    return CommonResult.fromJson(response);
  }

  static Future<CommonResult> getUserStatus() async {
    var response = await NewERPHttpUtil().post(
      '/api/GetUserStatus',
      queryParameters: {},
    );
    return CommonResult.fromJson(response);
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
      int sex,
      int mode,
      int serveType,
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
    if (mode == 10) {
      //全部
      url = "/api/v1/customer/system/index";
    }
    if (mode == 1) {
      //良缘
      url = "/api/v1/customer/passive/index";
    }
    if (mode == 2) {
      //我的
      url = "/api/v1/customer/personal/index";
      searchParam['type'] = serveType;
    }
    if (mode == 3) {
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
