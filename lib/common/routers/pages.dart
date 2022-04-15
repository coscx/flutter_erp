import 'package:flutter/material.dart';
import 'package:flutter_erp/common/middlewares/middlewares.dart';
import 'package:flutter_erp/pages/add_vip/view.dart';
import 'package:flutter_erp/pages/amap/binding.dart';
import 'package:flutter_erp/pages/amap/view.dart';
import 'package:flutter_erp/pages/application/index.dart';
import 'package:flutter_erp/pages/create_user/binding.dart';
import 'package:flutter_erp/pages/create_user/view.dart';
import 'package:flutter_erp/pages/distribute/binding.dart';
import 'package:flutter_erp/pages/distribute/view.dart';
import 'package:flutter_erp/pages/frame/login/binding.dart';
import 'package:flutter_erp/pages/frame/login/view.dart';
import 'package:flutter_erp/pages/frame/sign_in/index.dart';
import 'package:flutter_erp/pages/frame/sign_up/index.dart';
import 'package:flutter_erp/pages/frame/welcome/index.dart';
import 'package:flutter_erp/pages/home/view.dart';
import 'package:flutter_erp/pages/peer_chat/binding.dart';
import 'package:flutter_erp/pages/peer_chat/view.dart';
import 'package:flutter_erp/pages/peer_chat/widget/chat_input_view.dart';
import 'package:flutter_erp/pages/search/binding.dart';
import 'package:flutter_erp/pages/search/view.dart';
import 'package:flutter_erp/pages/search_appoint/view.dart';
import 'package:flutter_erp/pages/setting/binding.dart';
import 'package:flutter_erp/pages/setting/logic.dart';
import 'package:flutter_erp/pages/setting/view.dart';
import 'package:flutter_erp/pages/user_detail/binding.dart';
import 'package:flutter_erp/pages/user_detail/view.dart';
import 'package:get/get.dart';

import '../../pages/add_vip/binding.dart';
import '../../pages/home/binding.dart';
import '../../pages/search_appoint/binding.dart';
import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    // 免登陆
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => WelcomePage(),
      binding: WelcomeBinding(),
      middlewares: [
        RouteWelcomeMiddleware(priority: 1),
      ],
    ),
    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => SignInPage(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: AppRoutes.SIGN_UP,
      page: () => SignUpPage(),
      binding: SignUpBinding(),
    ),

    // 需要登录
    GetPage(
      name: AppRoutes.Application,
      page: () => ApplicationPage(),
      binding: ApplicationBinding(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),


    GetPage(
      name: AppRoutes.Home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.Detail,
      page: () => UserDetailPage(),
      binding: UserDetailBinding(),
      transition: Transition.rightToLeft
    ),

    GetPage(
        name: AppRoutes.BuyVip,
        page: () => AddVipPage(),
        binding: AddVipBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.Distribute,
        page: () => DistributePage(),
        binding: DistributeBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.Peer,
        page: () => PeerChatPage(),
        binding: PeerChatBinding(),
        transition: Transition.rightToLeft
    ),

    GetPage(
        name: AppRoutes.Setting,
        page: () => SettingPage(),
        binding: SettingBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.CreateUser,
        page: () => CreateUserPage(),
        binding: CreateUserBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.SearchUser,
        page: () => SearchPage(),
        binding: SearchBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.Amap,
        page: () => AmapPage(),
        binding: AmapBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.SearchUserAppoint,
        page: () => SearchAppointPage(),
        binding: SearchAppointBinding(),
        transition: Transition.rightToLeft
    ),
  ];

  // static final unknownRoute = GetPage(
  //   name: AppRoutes.NotFound,
  //   page: () => NotfoundView(),
  // );

}
