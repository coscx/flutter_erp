import 'package:flutter/material.dart';
import 'package:flutter_erp/common/middlewares/middlewares.dart';
import 'package:flutter_erp/pages/application/index.dart';
import 'package:flutter_erp/pages/category/index.dart';
import 'package:flutter_erp/pages/frame/login/binding.dart';
import 'package:flutter_erp/pages/frame/login/view.dart';
import 'package:flutter_erp/pages/frame/sign_in/index.dart';
import 'package:flutter_erp/pages/frame/sign_up/index.dart';
import 'package:flutter_erp/pages/frame/welcome/index.dart';
import 'package:flutter_erp/pages/home/view.dart';
import 'package:flutter_erp/pages/user_detail/binding.dart';
import 'package:flutter_erp/pages/user_detail/view.dart';
import 'package:get/get.dart';

import '../../pages/home/binding.dart';
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

    // 分类列表
    GetPage(
      name: AppRoutes.Category,
      page: () => CategoryPage(),
      binding: CategoryBinding(),
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



  ];

  // static final unknownRoute = GetPage(
  //   name: AppRoutes.NotFound,
  //   page: () => NotfoundView(),
  // );

}
