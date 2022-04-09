import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/pages/home/widget/app_bar_component.dart';
import 'package:flutter_erp/pages/home/widget/gzx_filter_goods_page.dart';
import 'package:flutter_erp/pages/home/widget/photo_widget_list_item.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../common/entities/home/common.dart';
import '../../common/widgets/DyBehaviorNull.dart';
import '../../common/widgets/MyScrollPhysics.dart';
import '../../common/widgets/empty_page.dart';
import '../../common/widgets/refresh.dart';
import 'logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();
  final state = Get.find<HomeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme.of(context).copyWith(
            brightness: Brightness.light,
          ),
        ),
        child: Scaffold(
            key: logic.scaffoldKey,
            endDrawer: GZXFilterGoodsPage(
              selectItems: logic.selectItems,
            ),
            appBar: AppBar(
              titleSpacing: 40.w,
              leadingWidth: 0,
              title: Row(
                children: [
                  Text(logic.title,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 48.sp,
                          fontWeight: FontWeight.bold)),
                    logic.totalCount == ""
                      ? Container()
                      : Text('      共:',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w200)),
                  Text(logic.totalCount,
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.normal)),
                ],
              ),
              //leading:const Text('Demo',style: TextStyle(color: Colors.black, fontSize: 15)),
              backgroundColor: Colors.white,
              elevation: 0,
              //去掉Appbar底部阴影
              actions: <Widget>[
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      //Navigator.pushNamed(context, UnitRouter.search);
                    },
                  ),
                ),
                SizedBox(width: 20.w),

              ],

              //bottom: bar(),
            ),
            body:  Container(
                  decoration: new BoxDecoration(
                    //背景
                    color: Color.fromRGBO(247, 247, 247, 100),
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(0.h)),
                    //设置四周边框
                    //border: new Border.all(width: 1, color: Colors.red),
                  ),
                  child: Stack(
                      children: <Widget>[
                        //BlocBuilder<GlobalBloc, GlobalState>(builder: _buildBackground),
                        Container(
                          padding: EdgeInsets.only(top: 150.h),
                          child: ScrollConfiguration(
                              behavior: DyBehaviorNull(),
                              child: SmartRefresher(
                                physics: MyScrollPhysics(),
                                enablePullDown: true,
                                enablePullUp: true,
                                header: DYrefreshHeader(),
                                footer: DYrefreshFooter(),
                                controller: logic.refreshController,
                                onRefresh: logic.onRefresh,
                                onLoading: logic.onLoading,
                                child: CustomScrollView(
                                  controller: logic.scrollController,
                                  physics: BouncingScrollPhysics(),
                                  slivers: <Widget>[
                                    _buildContent(context),
                                  ],
                                ),
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 70.h),
                          child: _buildHead(context),
                        ),
                        bar(
                          selectItems: logic.selectItems,
                          roleId: logic.roleId,
                          scaffoldState: logic.scaffoldKey,
                        ),
                      ],
                    )
                )
        )
    );
  }
  Widget _buildHead(BuildContext context ) {
    return Container(
        child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              //                交叉轴的布局方式，对于column来说就是水平方向的布局方式
              crossAxisAlignment: CrossAxisAlignment.center,
              //就是字child的垂直布局方向，向上还是向下
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(
                  width: 1.w,
                ),
                Container(
                  width: 100.w,
                  child: Text(
                    "筛选:",
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                CupertinoSegmentedControl<int>(
                  //unselectedColor: Colors.yellow,
                  //selectedColor: Colors.green,
                  //pressedColor: Colors.blue,
                  //borderColor: Colors.red,
                  groupValue: logic.sex == 0 ? 1 : logic.sex,
                  onValueChanged: _onValueChanged,
                  padding: EdgeInsets.only(right: 0.w),
                  children: {
                    1: logic.sex == 1
                        ? Padding(
                      padding: EdgeInsets.only(left: 50.w, right: 40.w),
                      child: Text("男",
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.white,
                          )),
                    )
                        : Text("男",
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: Colors.blue,
                        )),
                    2: logic.sex == 2
                        ? Padding(
                      padding: EdgeInsets.only(left: 50.w, right: 40.w),
                      child: Text("女",
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.white,
                          )),
                    )
                        : Text("女",
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: Colors.blue,
                        )),
                  },
                ),
                buildHeadTxt(context),
                PopupMenuButton<String>(
                  itemBuilder: (context) => buildItems(),
                  padding: EdgeInsets.only(right: 0.w),
                  offset: Offset(-15.w, 20.h),
                  color: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.w),
                        bottomRight: Radius.circular(20.w),
                        topRight: Radius.circular(5.w),
                        bottomLeft: Radius.circular(20.w),
                      )),
                  onSelected: (e) async {
                    //print(e);
                    var ccMode = 0;
                    if (e == '全部') {

                      ccMode = 10;
                    }
                    if (e == '我的') {

                      ccMode = 2;
                    }
                    if (e == '良缘') {

                      ccMode = 1;
                    }
                    if (e == '公海') {

                      ccMode = 3;
                    }


                      logic.roleId = ccMode;

                  },
                  onCanceled: () => print('onCanceled'),
                )
              ],
            )));
  }
  void _onValueChanged(int value) {

  }
  List<PopupMenuItem<String>> buildItems() {
    final map = {
      "全部": Icons.margin,
      "我的": Icons.person_outline,
      "良缘": Icons.wc,
      "公海": Icons.album_outlined,
    };
    return map.keys
        .toList()
        .map((e) => PopupMenuItem<String>(
        value: e,
        child: Row(
          //spacing: 10.w,
          children: <Widget>[
            Icon(
              map[e],
              color: Colors.blue,
            ),
            Text(e),
          ],
        )))
        .toList();
  }

  Widget buildHeadTxt(BuildContext context) {
    if (logic.currentPhotoMode == 0) {
      return SizedBox(
        width: 70.w,
        child: Text("全部"),
      );
    }
    if (logic.currentPhotoMode == 2) {
      return SizedBox(
        width: 70.w,
        child: Text("我的"),
      );
    }
    if (logic.currentPhotoMode == 1) {
      return SizedBox(
        width: 70.w,
        child: Text("良缘"),
      );
    }
    if (logic.currentPhotoMode == 3) {
      return SizedBox(
        width: 70.w,
        child: Text("公海"),
      );
    }
    return SizedBox(
      width: 70.w,
      child: Text("全部"),
    );
  }
  Widget _buildContent(BuildContext context) {

      if (logic.state.homeUser.isEmpty) return SliverToBoxAdapter(child: EmptyPage());
      return logic.state.homeUser.isNotEmpty
          ? SliverList(
        delegate: SliverChildBuilderDelegate(
                (_, int index) => PhotoWidgetListItem( photo: logic.state.homeUser[index]),
            childCount: logic.state.homeUser.length),
      )
          : SliverToBoxAdapter(
          child: Center(
            child: Container(
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.airplay,
                      color: Colors.orangeAccent, size: 120.0),
                  Container(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      "暂时没有用户了",
                      style: TextStyle(
                        fontSize: 40.sp,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
  }
}
class bar extends StatelessWidget implements PreferredSizeWidget {
  final List<SelectItem> selectItems;
  final int roleId;
  final  GlobalKey<ScaffoldState> scaffoldState;
  bar({
    required this.selectItems,
    required this.roleId,
    required this.scaffoldState,
  });

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(580.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Column(
        children: [
          Expanded(
              child: AppBarComponent(
                selectItems: selectItems,
                state: scaffoldState,
                mode: roleId,
              )),
        ],
      ),
    );
  }
}
