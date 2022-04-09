import 'package:flutter/material.dart';
import 'package:flutter_erp/common/utils/iconfont.dart';
import 'package:flutter_erp/common/values/values.dart';
import 'package:flutter_erp/common/widgets/unit_bottom_bar.dart';
import 'package:flutter_erp/common/widgets/widgets.dart';
import 'package:flutter_erp/pages/category/index.dart';
import 'package:flutter_erp/pages/flow_page/view.dart';
import 'package:flutter_erp/pages/main/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class ApplicationPage extends GetView<ApplicationController> {
  // 顶部导航
  AppBar _buildAppBar() {
    return transparentAppBar(
        title: Obx(() => Text(
              controller.tabTitles[controller.state.page],
              style: TextStyle(
                color: AppColors.primaryText,
                fontFamily: 'Montserrat',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            )),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: AppColors.primaryText,
            ),
            onPressed: () {},
          )
        ]);
  }

  // 内容页
  Widget _buildPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        MainPage(),
        FlowPage(),
        Text('BookmarksPage'),
        Text('AccountPage'),
      ],
      controller: controller.pageController,
      onPageChanged: controller.handlePageChanged,
    );
  }

// 底部导航
  Widget _buildBottomNavigationBar() {
    return Obx(() => BottomNavigationBar(
      items: controller.bottomTabs,
      currentIndex: controller.state.page,
      // fixedColor: AppColors.primaryElement,
      type: BottomNavigationBarType.fixed,
      onTap: controller.handleNavBarTap,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
