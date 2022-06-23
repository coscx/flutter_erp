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
import 'package:flutter_erp/pages/group_chat/binding.dart';
import 'package:flutter_erp/pages/group_chat/view.dart';
import 'package:flutter_erp/pages/home/view.dart';
import 'package:flutter_erp/pages/oa/application/index.dart';
import 'package:flutter_erp/pages/oa/home_message/binding.dart';
import 'package:flutter_erp/pages/oa/home_message/view.dart';
import 'package:flutter_erp/pages/oa/person/binding.dart';
import 'package:flutter_erp/pages/oa/person/view.dart';
import 'package:flutter_erp/pages/oa/user_detail/binding.dart';
import 'package:flutter_erp/pages/oa/user_detail/logic.dart';
import 'package:flutter_erp/pages/oa/user_detail/view.dart';
import 'package:flutter_erp/pages/oa/work/binding.dart';
import 'package:flutter_erp/pages/oa/work/view.dart';
import 'package:flutter_erp/pages/other/fine/view.dart';
import 'package:flutter_erp/pages/other/fine_detail/view.dart';
import 'package:flutter_erp/pages/other/webview/binding.dart';
import 'package:flutter_erp/pages/other/webview/view.dart';
import 'package:flutter_erp/pages/peer_chat/binding.dart';
import 'package:flutter_erp/pages/peer_chat/view.dart';
import 'package:flutter_erp/common/widgets/chat/chat_input_view.dart';
import 'package:flutter_erp/pages/search/binding.dart';
import 'package:flutter_erp/pages/search/view.dart';
import 'package:flutter_erp/pages/search_appoint/view.dart';
import 'package:flutter_erp/pages/search_flow/binding.dart';
import 'package:flutter_erp/pages/search_flow/logic.dart';
import 'package:flutter_erp/pages/search_flow/view.dart';
import 'package:flutter_erp/pages/setting/binding.dart';
import 'package:flutter_erp/pages/setting/logic.dart';
import 'package:flutter_erp/pages/setting/view.dart';
import 'package:flutter_erp/pages/user_detail/binding.dart';
import 'package:flutter_erp/pages/user_detail/view.dart';
import 'package:get/get.dart';

import '../../pages/add_vip/binding.dart';
import '../../pages/home/binding.dart';
import '../../pages/other/fine/binding.dart';
import '../../pages/other/fine_detail/widget/fine_detail.dart';
import '../../pages/other/fine_detail/binding.dart';
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
        transition: Transition.noTransition
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
    GetPage(
        name: AppRoutes.Fine,
        page: () => FinePage(),
        binding: FineBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.SearchFlow,
        page: () => SearchFlowPage(),
        binding: SearchFlowBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.Webview,
        page: () => WebviewPage(),
        binding: WebviewBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.GroupChat,
        page: () => GroupChatPage(),
        binding: GroupChatBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.FineDetail,
        page: () => FineDetailPage(),
        binding: FineDetailBinding(),
        transition: Transition.rightToLeft
    ),

    GetPage(
        name: AppRoutes.OAApplication,
        page: () => OAApplicationPage(),
        binding: OAApplicationBinding(),
        transition: Transition.rightToLeft
    ),

    GetPage(
        name: AppRoutes.HomeMessage,
        page: () => HomeMessagePage(),
        binding: HomeMessageBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.Work,
        page: () => WorkPage(),
        binding: WorkBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.Person,
        page: () => PersonPage(),
        binding: PersonBinding(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.OADetail,
        page: () => OAUserDetailPage(),
        binding: OAUserDetailBinding(),
        transition: Transition.rightToLeft
    ),
  ];

  // static final unknownRoute = GetPage(
  //   name: AppRoutes.NotFound,
  //   page: () => NotfoundView(),
  // );

}
class SizeTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
        opacity:  CurvedAnimation(
        parent: animation,
        curve: curve!,
      ),
        child: child,
    );
  }
}